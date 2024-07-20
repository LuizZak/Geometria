import Geometria
import MiniDigraph

extension Simplex2Graph {
    static func fromParametricIntersections<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        tolerance: Scalar
    ) -> Self where T1.Vector == Vector, T2.Vector == Vector {

        typealias Winding = Parametric2Contour<Vector>.Winding

        let lhsContours = lhs.allContours()
        let rhsContours = rhs.allContours()

        var edgeId: Int = 0
        func nextEdgeId() -> Int {
            defer { edgeId += 1 }
            return edgeId
        }


        var result = Self(
            lhsCount: lhsContours.count,
            rhsCount: rhsContours.count
        )

        func addContour(
            _ contour: Parametric2Contour<Vector>,
            shapeIndex: Int
        ) {
            let simplexes = contour.allSimplexes()

            // Create nodes
            var nodes: [(Parametric2GeometrySimplex<Vector>, Node)] = []
            for simplex in simplexes {
                let node = Node(
                    location: simplex.start,
                    kind: .geometry(
                        shapeIndex: shapeIndex,
                        period: simplex.startPeriod
                    )
                )
                nodes.append((simplex, node))
            }

            guard nodes.count > 1 else {
                return
            }

            // Create edges
            var edges: [Edge] = []
            for (current, next) in zip(nodes, nodes.dropFirst() + [nodes[0]]) {
                let kind: Edge.Kind
                switch current.0 {
                case .lineSegment2:
                    kind = .line

                case .circleArc2(let arc):
                    kind = .circleArc(
                        center: arc.circleArc.center,
                        sweepAngle: arc.circleArc.sweepAngle
                    )
                }

                let edge = Edge(
                    id: nextEdgeId(),
                    start: current.1,
                    end: next.1,
                    shapeIndex: shapeIndex,
                    startPeriod: current.0.startPeriod,
                    endPeriod: current.0.endPeriod,
                    kind: kind
                )
                edges.append(edge)
            }

            result.addNodes(nodes.map(\.1))
            result.addEdges(edges)
        }

        // Populate with contours
        for (i, contour) in lhsContours.enumerated() {
            addContour(contour, shapeIndex: i)
        }
        for (i, contour) in rhsContours.enumerated() {
            addContour(contour, shapeIndex: lhsContours.count + i)
        }

        let allContours = lhsContours + rhsContours

        func computeWinding(_ edge: Edge) {
            let contour = allContours[edge.shapeIndex]
            edge.winding = contour.winding

            let center = edge.queryPoint(contour.normalizedCenter(_:_:))

            edge.totalWinding =
                allContours.enumerated()
                .filter({ $0.offset != edge.shapeIndex })
                .filter({ $0.element.contains(center) })
                .reduce(contour.winding.value, { $0 + $1.element.winding.value })
        }

        // Populate with intersections
        for (lhs, lhsContour) in lhsContours.enumerated() {
            for (rhs, rhsContour) in rhsContours.enumerated() {

                let rhs = rhs + lhsContours.count
                let intersections = lhsContour.rawIntersectionPeriods(
                    rhsContour,
                    tolerance: tolerance
                )

                for intersection in intersections {
                    guard
                        let lhsEdge = result.edgeForPeriod(
                            intersection.`self`,
                            shapeIndex: lhs
                        ),
                        let rhsEdge = result.edgeForPeriod(
                            intersection.other,
                            shapeIndex: rhs
                        )
                    else {
                        continue
                    }

                    let point = lhsContour.compute(at: intersection.`self`)
                    let node = Node(
                        location: point,
                        kind: .intersection(
                            lhs: lhs,
                            lhsPeriod: intersection.`self`,
                            rhs: rhs,
                            rhsPeriod: intersection.other
                        )
                    )

                    result.addNode(node)

                    result.splitEdge(
                        lhsEdge,
                        period: intersection.`self`,
                        midNode: node,
                        idGenerator: nextEdgeId
                    )

                    result.splitEdge(
                        rhsEdge,
                        period: intersection.other,
                        midNode: node,
                        idGenerator: nextEdgeId
                    )

                    result.assertIsValid()
                }
            }
        }

        // Compute edge windings
        for edge in result.edges {
            computeWinding(edge)
        }

        result.assertIsValid()

        return result
    }

    /// Prunes all nodes that have no ingoing and/or outgoing connections.
    ///
    /// Edges still connected to the nodes are also removed in the process.
    internal mutating func prune() {
        for node in nodes {
            if indegree(of: node) == 0 || outdegree(of: node) == 0 {
                removeNode(node)
            }
        }
    }

    @inlinable
    internal func assertIsValid(file: StaticString = #file, line: UInt = #line) {
        #if DEBUG

        for edge in self.edges {
            assert(containsNode(edge.start))
            assert(containsNode(edge.end))
        }

        for node in self.nodes {
            if node.isIntersection {
                let indegree = self.indegree(of: node)
                let outdegree = self.outdegree(of: node)

                assert(indegree == 2, "intersection.indegree == 2", file: file, line: line)
                assert(outdegree == 2, "intersection.outdegree == 2", file: file, line: line)
            } else {
                let indegree = self.indegree(of: node)
                let outdegree = self.outdegree(of: node)

                assert(indegree > 0, "geometry.indegree > 0", file: file, line: line)
                assert(outdegree > 0, "geometry.outdegree > 0", file: file, line: line)
            }
        }

        #endif
    }

    /// Splits an edge into two sub-edges, covering the same period range, but with
    /// an intermediary node `midNode` in between the end nodes at `period`.
    ///
    /// If `period` matches the edge's `startPeriod` or `endPeriod`, then the
    /// node at the end point of the edge is replaced with 'midNode' instead of
    /// being spliced in, with all edges from the original node copied to the
    /// new node.
    mutating func splitEdge(
        _ edge: Edge,
        period: Period,
        midNode: Node,
        idGenerator: () -> Int
    ) {
        assert(edge.periodRange.contains(period))

        if period == edge.startPeriod {
            let incoming = edges(towards: edge.start)
            let outgoing = edges(from: edge.start)

            removeNode(edge.start)

            for incoming in incoming {
                incoming.end = midNode
                addEdge(incoming)
            }
            for outgoing in outgoing {
                outgoing.start = midNode
                addEdge(outgoing)
            }

            return
        } else if period == edge.endPeriod {
            let incoming = edges(towards: edge.end)
            let outgoing = edges(from: edge.end)

            removeNode(edge.start)

            for incoming in incoming {
                incoming.end = midNode
            }
            for outgoing in outgoing {
                outgoing.start = midNode
            }

            return
        }

        let periodDiff = edge.endPeriod - edge.startPeriod

        let kindStart: Edge.Kind
        let kindEnd: Edge.Kind
        switch edge.kind {
        case .line:
            kindStart = .line
            kindEnd = .line

        case .circleArc(let center, let sweepAngle):
            kindStart = .circleArc(
                center: center,
                sweepAngle: sweepAngle * ((period - edge.startPeriod) / periodDiff)
            )

            kindEnd = .circleArc(
                center: center,
                sweepAngle: sweepAngle * (1 - (period - edge.startPeriod) / periodDiff)
            )
        }

        let newStart = Edge(
            id: idGenerator(),
            start: edge.start,
            end: midNode,
            shapeIndex: edge.shapeIndex,
            startPeriod: edge.startPeriod,
            endPeriod: period,
            kind: kindStart
        )
        let newEnd = Edge(
            id: idGenerator(),
            start: midNode,
            end: edge.end,
            shapeIndex: edge.shapeIndex,
            startPeriod: period,
            endPeriod: edge.endPeriod,
            kind: kindEnd
        )

        removeEdge(edge)
        addEdge(newStart)
        addEdge(newEnd)
    }
}

fileprivate extension Collection {
    func simplexIndex<V: VectorType>(
        containingPeriod period: V.Scalar
    ) -> Index? where Element == Parametric2GeometrySimplex<V> {
        for index in indices {
            let element = self[index]

            if element.periodRange.contains(period) {
                return index
            }
        }

        return nil
    }
}

extension Parametric2Contour {
    func rawIntersectionPeriods(
        _ other: Self,
        tolerance: Scalar
    ) -> [ParametricClip2Intersection<Scalar>.Atom] {
        var atoms: [ParametricClip2Intersection<Scalar>.Atom] = []

        for selfSimplex in self.allSimplexes() {
            for otherSimplex in other.allSimplexes() {
                atoms.append(
                    contentsOf: selfSimplex.intersectionPeriods(with: otherSimplex)
                )
            }
        }

        // Attempt to tie intersections as pairs by biasing the list of atoms as
        // sorted periods on 'self', and working on sequential periods instead
        // of sequential points of intersections
        atoms = atoms.sorted(by: { $0.`self` < $1.`self` })

        // Combine atoms with `tolerance`
        if tolerance.isFinite {
            var index = 0
            while index < (atoms.count - 1) {
                defer { atoms.formIndex(after: &index) }

                let atom = atoms[index]
                let next = atoms[atoms.index(after: index)]

                if
                    ParametricClip2Intersection<Scalar>.areApproximatelyEqual(
                        atom,
                        next,
                        tolerance: tolerance
                    )
                {
                    atoms.remove(at: atoms.index(after: index))
                    atoms.formIndex(before: &index)
                }
            }
        }

        return atoms
    }
}
