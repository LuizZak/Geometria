import Geometria
import MiniDigraph

extension Simplex2Graph {
    public static func fromParametricIntersections<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        tolerance: Scalar
    ) -> Self where T1.Vector == Vector, T2.Vector == Vector {

        return fromParametricIntersections(
            contours: lhs.allContours() + rhs.allContours(),
            tolerance: tolerance
        )
    }

    public static func fromParametricIntersections(
        geometries: [some ParametricClip2Geometry<Vector>],
        tolerance: Scalar
    ) -> Self {

        return fromParametricIntersections(
            contours: geometries.flatMap({ $0.allContours() }),
            tolerance: tolerance
        )
    }

    public static func fromParametricIntersections(
        contours: [Contour],
        tolerance: Scalar
    ) -> Self {

        var result = Self()

        // Populate with contours
        for contour in contours {
            result.appendContour(contour)
        }

        // Populate with intersections
        result.computeIntersections(tolerance: tolerance)

        // Compute edge windings
        result.computeWinding()

        result.assertIsValid()

        return result
    }

    /// Appends a new contour into this graph.
    internal mutating func appendContour(_ contour: Contour) {
        let simplexes = contour.allSimplexes()
        let shapeIndex = contours.count

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
                    radius: arc.circleArc.radius,
                    startAngle: arc.circleArc.startAngle,
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

        addNodes(nodes.map(\.1))
        addEdges(edges)

        contours.append(contour)
    }

    internal mutating func computeIntersections(tolerance: Scalar) {
        for (lhs, lhsContour) in contours.enumerated() {
            for (rhs, rhsContour) in contours.enumerated().dropFirst(lhs + 1) {

                let intersections = lhsContour.rawIntersectionPeriods(
                    rhsContour,
                    tolerance: tolerance
                )

                for intersection in intersections {
                    guard
                        let lhsEdge = edgeForPeriod(
                            intersection.`self`,
                            shapeIndex: lhs
                        ),
                        let rhsEdge = edgeForPeriod(
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

                    addNode(node)

                    splitEdge(
                        lhsEdge,
                        period: intersection.`self`,
                        midNode: node
                    )

                    splitEdge(
                        rhsEdge,
                        period: intersection.other,
                        midNode: node
                    )

                    assertIsValid()
                }
            }
        }
    }

    /// Re-computes edge windings within this simplex graph.
    internal mutating func computeWinding() {
        for edge in edges {
            let contour = contours[edge.shapeIndex]
            edge.winding = contour.winding

            let center = edge.queryPoint(contour.normalizedCenter(_:_:))

            edge.totalWinding =
                contours.enumerated()
                .filter({ $0.offset != edge.shapeIndex })
                .filter({ $0.element.contains(center) })
                .reduce(contour.winding.value, { $0 + $1.element.winding.value })
        }
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
        midNode: Node
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

        let kindStart: Edge.Kind
        let kindEnd: Edge.Kind
        switch edge.kind {
        case .line:
            kindStart = .line
            kindEnd = .line

        case .circleArc(let center, let radius, let startAngle, let sweepAngle):
            func ratioForPeriod(_ period: Period) -> Period {
                (period - edge.startPeriod) / (edge.endPeriod - edge.startPeriod)
            }

            let ratio = ratioForPeriod(period)

            kindStart = .circleArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                sweepAngle: sweepAngle * ratio
            )

            kindEnd = .circleArc(
                center: center,
                radius: radius,
                startAngle: startAngle + sweepAngle * ratio,
                sweepAngle: sweepAngle * (1 - ratio)
            )
        }

        let newStart = Edge(
            id: nextEdgeId(),
            start: edge.start,
            end: midNode,
            shapeIndex: edge.shapeIndex,
            startPeriod: edge.startPeriod,
            endPeriod: period,
            kind: kindStart
        )
        let newEnd = Edge(
            id: nextEdgeId(),
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
