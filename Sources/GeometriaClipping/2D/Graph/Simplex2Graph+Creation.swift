import MiniDigraph
import Geometria
import GeometriaAlgorithms

extension Simplex2Graph {
    @inlinable
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

    @inlinable
    public static func fromParametricIntersections(
        geometries: [some ParametricClip2Geometry<Vector>],
        tolerance: Scalar
    ) -> Self {

        return fromParametricIntersections(
            contours: geometries.flatMap({ $0.allContours() }),
            tolerance: tolerance
        )
    }

    @inlinable
    public static func fromParametricIntersections(
        contours: [Contour],
        tolerance: Scalar
    ) -> Self {

        var result = Self()

        // Populate with contours
        for contour in contours {
            result.appendContour(contour)
        }

        // TODO: Reuse check of edges in computeInterferences to generate intersections

        // Compute interferences
        if result.computeInterferences(tolerance: tolerance) {
            // If interferences where found, we need to recompute the contours
            // based on the existing edges
            let recombined = result.recombine()

            result = Self()
            for contour in recombined {
                result.appendContour(contour)
            }

            result.assertIsValid()
        }

        // Populate with intersections
        result.computeIntersections(tolerance: tolerance)

        // Compute edge windings
        result.computeWinding()

        result.assertIsValid()

        return result
    }

    /// Appends a new contour into this graph.
    @inlinable
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

    @inlinable
    internal mutating func computeIntersections(tolerance: Scalar) {
        let edges = Array(edges)

        var allIntersections: [(lhs: Int, lhsPeriod: Vector.Scalar, rhs: Int, rhsPeriod: Vector.Scalar)] = []
        var visited: Set<OrderedEdgePair> = []

        for lhs in edges.sorted(by: { $0.id < $1.id }) {
            let lhsSimplex = lhs.materialize()
            let coincident = edgeTree.query(lhs)

            for rhs in coincident where lhs.shapeIndex != rhs.shapeIndex {
                guard visited.insert(.init(lhs: lhs, rhs: rhs)).inserted else {
                    continue
                }

                let intersections =
                    lhsSimplex
                    .intersectionPeriods(with: rhs.materialize())

                for intersection in intersections {
                    allIntersections.append(
                        (lhs.shapeIndex, intersection.`self`, rhs.shapeIndex, intersection.other)
                    )
                }
            }
        }

        for intersection in allIntersections {
            guard
                let lhs = edgeForPeriod(intersection.lhsPeriod, shapeIndex: intersection.lhs),
                let rhs = edgeForPeriod(intersection.rhsPeriod, shapeIndex: intersection.rhs)
            else {
                continue
            }

            assert(lhs != rhs, "lhs != rhs")
            assert(lhs.shapeIndex != rhs.shapeIndex, "lhs != rhs")

            let point = lhs.materialize().compute(at: intersection.lhsPeriod)
            let node = Node(
                location: point,
                kind: .intersection(
                    lhs: intersection.lhs,
                    lhsPeriod: intersection.lhsPeriod,
                    rhs: intersection.rhs,
                    rhsPeriod: intersection.rhsPeriod
                )
            )

            addNode(node)

            splitEdge(
                lhs,
                period: intersection.lhsPeriod,
                midNode: node
            )

            splitEdge(
                rhs,
                period: intersection.rhsPeriod,
                midNode: node
            )

            assertIsValid()
        }
    }

    /// Computes interferences between edges and vertices.
    ///
    /// Interferences occur under a specified tolerance, where geometry is
    /// coincidental under that tolerance in space.
    ///
    /// Returns `true` if interferences where found and merged.
    @inlinable
    internal mutating func computeInterferences(tolerance: Scalar) -> Bool {
        var hasMerged = false

        // MARK: Merge edges - part 1
        var edgesToCheck: Set<Set<Edge>> = []
        for edge in edges {
            let coincident =
                edgeTree
                .query(edge)
                .filter({ $0.isCoincident(with: edge, tolerance: tolerance) })

            guard !coincident.isEmpty else {
                continue
            }

            edgesToCheck.insert(Set(coincident).union([edge]))
        }

        // Merge edge groups that appear multiple times
        var minimal: [Set<Edge>] = []
        for edgesToCheck in edgesToCheck {
            var merged = false
            for i in 0..<minimal.count {
                if !minimal[i].isDisjoint(with: edgesToCheck) {
                    minimal[i].formUnion(edgesToCheck)
                    merged = true
                    break
                }
            }

            if !merged {
                minimal.append(edgesToCheck)
            }
        }

        // Start by first splitting all edges that coincide such that the result
        // are edges that either coincide as the same span, or not at all.
        //
        // The next step of merging nodes works to combine the edge endpoints,
        // allowing a last pass across the edges to compute the result of the
        // coinciding edges.
        for edgesToCheck in minimal {
            let edgesToCheck = Array(edgesToCheck)

            for (i, edge) in edgesToCheck.enumerated() {
                for (_, next) in edgesToCheck.enumerated().dropFirst(i + 1) {
                    let relationship = edge.coincidenceRelationship(
                        with: next,
                        tolerance: tolerance
                    )

                    switch relationship {
                    case .sameSpan, .notCoincident:
                        break

                    case .lhsContainsRhs(let lhsStart, let lhsEnd):
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsStart)
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsEnd)

                    case .rhsContainsLhs(let rhsStart, let rhsEnd):
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsStart)
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsEnd)

                    case .lhsPrefixesRhs(let rhsEnd):
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsEnd)

                    case .lhsSuffixesRhs(let rhsStart):
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsStart)

                    case .rhsPrefixesLhs(let lhsEnd):
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsEnd)

                    case .rhsSuffixesLhs(let lhsStart):
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsStart)

                    case .rhsContainsLhsStart(let rhsStart, let lhsEnd):
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsEnd)
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsStart)

                    case .rhsContainsLhsEnd(let lhsEnd, let rhsStart):
                        splitEdge(shapeIndex: edge.shapeIndex, period: lhsEnd)
                        splitEdge(shapeIndex: next.shapeIndex, period: rhsStart)
                    }
                }
            }
        }

        // MARK: Merge nodes
        func areClose(_ v1: Vector, _ v2: Vector) -> Bool {
            let diff = (v1 - v2)

            return diff.absolute.maximalComponent.magnitude < tolerance
        }
        func areClose(_ n1: Node, _ n2: Node) -> Bool {
            areClose(n1.location, n2.location)
        }

        var nodesToMerge: Set<Set<Node>> = []

        for node in nodes {
            let neighbors = nodeTree.nearestNeighbors(
                to: node.location,
                distanceSquared: tolerance
            )

            nodesToMerge.insert(
                Set(neighbors)
            )
        }

        // Merge node groups that appear multiple times
        var minimalNodes: [Set<Node>] = []
        for nodesToMerge in nodesToMerge {
            var merged = false
            for i in 0..<minimalNodes.count {
                if !minimalNodes[i].isDisjoint(with: nodesToMerge) {
                    minimalNodes[i].formUnion(nodesToMerge)
                    merged = true
                    break
                }
            }

            if !merged {
                minimalNodes.append(nodesToMerge)
            }
        }

        for nodesToMerge in minimalNodes {
            guard nodesToMerge.count > 1, let first = nodesToMerge.first else {
                continue
            }

            let geometries: [Node.Kind.SharedGeometryEntry] = nodesToMerge.compactMap { node in
                switch node.kind {
                case .geometry(let shapeIndex, let period):
                    return [Node.Kind.SharedGeometryEntry(
                        shapeIndex: shapeIndex, period: period
                    )]

                case .sharedGeometry(let geometries):
                    return geometries

                case .intersection:
                    return nil
                }
            }.flatMap({ $0 })

            let entries = nodesToMerge
                .flatMap(edges(towards:))
                .filter { edge in !nodesToMerge.contains(edge.start) || !nodesToMerge.contains(edge.end) }
            let exits = nodesToMerge
                .flatMap(edges(from:))
                .filter { edge in !nodesToMerge.contains(edge.start) || !nodesToMerge.contains(edge.end) }
            let newNode = Node(
                location: first.location,
                kind: .sharedGeometry(geometries)
            )

            // Remove old nodes
            removeNodes(nodesToMerge)

            // Re-add nodes and edges
            addNode(newNode)

            for entry in entries {
                assert(!containsEdge(entry))

                entry.end = newNode
                addEdge(entry)
            }
            for exit in exits {
                assert(!containsEdge(exit))

                exit.start = newNode
                addEdge(exit)
            }

            hasMerged = true
        }

        // MARK: Merge edges - part 2
        edgesToCheck = []
        for edge in edges {
            let coincident =
                edgeTree
                .query(edge)
                .filter({ next in
                    next.coincidenceRelationship(with: edge, tolerance: tolerance) == .sameSpan
                })

            guard !coincident.isEmpty else {
                continue
            }

            edgesToCheck.insert(Set(coincident).union([edge]))
        }

        for edgesToCheck in edgesToCheck {
            let edges = Array(edgesToCheck)
            guard let first = edges.first else {
                continue
            }

            var totalWinding = 0
            for next in edges.dropFirst() {
                if first.isOpposingCoincident(next) {
                    totalWinding -= 1
                } else {
                    totalWinding += 1
                }
            }

            if totalWinding <= 0 {
                // Remove all edges
                removeEdges(edges)
            } else {
                // Keep first edge only
                removeEdges(edges.dropFirst())
            }
        }

        prune()

        return hasMerged
    }

    /// Re-computes edge windings within this simplex graph.
    @inlinable
    internal mutating func computeWinding() {
        for edge in edges {
            let contour = contours[edge.shapeIndex]
            edge.winding = contour.winding

            let center = edge.queryPoint(contour.normalizedCenter(_:_:))

            edge.totalWinding =
                contours.enumerated()
                .filter({ $0.offset != edge.shapeIndex })
                .filter({ $0.element.contains(center) })
                .reduce(edge.winding.value, { $0 + $1.element.winding.value })
        }
    }

    /// Prunes all nodes that have no ingoing and/or outgoing connections.
    ///
    /// Edges still connected to the nodes are also removed in the process.
    @inlinable
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

    /// Splits an edge of a given shape index into two sub-edges, covering the
    /// same period range, but with a new intermediary geometry node in between
    /// the end nodes at `period`.
    ///
    /// If `period` matches the edge's `startPeriod` or `endPeriod`, then the edge
    /// is not split and nothing is done.
    @inlinable
    mutating func splitEdge(
        shapeIndex: Int,
        period: Period
    ) {
        guard let edge = edgeForPeriod(period, shapeIndex: shapeIndex) else {
            return
        }

        splitEdge(edge, period: period)
    }

    /// Splits an edge into two sub-edges, covering the same period range, but
    /// with a new intermediary geometry node in between the end nodes at `period`.
    ///
    /// If `period` matches the edge's `startPeriod` or `endPeriod`, then the edge
    /// is not split and nothing is done.
    @inlinable
    mutating func splitEdge(
        _ edge: Edge,
        period: Period
    ) {
        assert(edge.periodRange.contains(period))

        guard period > edge.startPeriod && period < edge.endPeriod else {
            return
        }

        let midNode = Node(
            location: edge.materialize().compute(at: period),
            kind: .geometry(
                shapeIndex: edge.shapeIndex,
                period: period
            )
        )

        addNode(midNode)
        splitEdge(edge, period: period, midNode: midNode)
    }

    /// Splits an edge into two sub-edges, covering the same period range, but with
    /// an intermediary node `midNode` in between the end nodes at `period`.
    ///
    /// If `period` matches the edge's `startPeriod` or `endPeriod`, then the
    /// node at the end point of the edge is replaced with 'midNode' instead of
    /// being spliced in, with all edges from the original node copied to the
    /// new node.
    @inlinable
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
            kind: kindStart,
            totalWinding: edge.totalWinding,
            winding: edge.winding
        )
        let newEnd = Edge(
            id: nextEdgeId(),
            start: midNode,
            end: edge.end,
            shapeIndex: edge.shapeIndex,
            startPeriod: period,
            endPeriod: edge.endPeriod,
            kind: kindEnd,
            totalWinding: edge.totalWinding,
            winding: edge.winding
        )

        removeEdge(edge)
        addEdge(newStart)
        addEdge(newEnd)
    }

    @usableFromInline
    internal struct OrderedEdgePair: Hashable {
        @usableFromInline
        var lhs: Edge
        @usableFromInline
        var rhs: Edge

        @inlinable
        init(lhs: Edge, rhs: Edge) {
            if lhs.id < rhs.id {
                self.lhs = lhs
                self.rhs = rhs
            } else {
                self.rhs = lhs
                self.lhs = rhs
            }
        }
    }
}

extension Parametric2Contour {
    @inlinable
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
