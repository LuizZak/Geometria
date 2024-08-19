import MiniDigraph
import Geometria
import GeometriaAlgorithms
import OrderedCollections

@_specializeExtension
extension Simplex2Graph {
    @usableFromInline
    internal typealias GlobalIntersection = (lhs: Int, lhsPeriod: Vector.Scalar, rhs: Int, rhsPeriod: Vector.Scalar)

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
    @_specialize(exported: true, kind: full, where Vector == Vector2D)
    @_specialize(exported: true, kind: full, where Vector == Vector2F)
    public static func fromParametricIntersections(
        contours: [Contour],
        tolerance: Scalar
    ) -> Self {

        var result = Self()

        let contourBounds = AABB(aabbs: contours.map(\.bounds))
        result.edgeTree.ensureContains(bounds: contourBounds)
        result.contourTree.ensureContains(bounds: contourBounds)

        let (contours, intersections) = Self.splitContours(contours: contours, tolerance: tolerance)

        // Populate with contours
        for contour in contours {
            result.appendContour(contour, tolerance: tolerance)
        }

        // Compute interferences
        if result.computeInterferences(intersections: intersections, tolerance: tolerance).hasMergedEdges {
            // If interferences where found, we need to recompute the contours
            // based on the new edges
            let recombined = result.recombine { edge in
                switch edge.winding {
                case .clockwise:
                    return edge.totalWinding == 1

                case .counterClockwise:
                    return edge.totalWinding == 0
                }
            }

            var newGraph = Self()
            newGraph.edgeTree.ensureContains(bounds: contourBounds)
            newGraph.contourTree.ensureContains(bounds: contourBounds)
            for contour in recombined {
                newGraph.appendContour(contour, tolerance: tolerance)
            }

            newGraph.assertIsValid()
            result = newGraph
        }

        result.assertIsValid()

        return result
    }

    @inlinable
    internal static func splitContours(
        contours: [Contour],
        tolerance: Scalar
    ) -> ([Contour], [GlobalIntersection]) {
        var contours = contours
        var allIntersections: [GlobalIntersection] = []

        let toleranceSquared = tolerance
        for (lhsIndex, lhs) in contours.enumerated() {
            for (rhsIndex, rhs) in contours.enumerated().dropFirst(lhsIndex + 1) {
                let intersections = lhs.rawIntersectionPeriods(rhs, tolerance: tolerance)

                for intersection in intersections {
                    // Ignore interference intersections between vertices/edges
                    if lhs.isOnVertex(rhs.compute(at: intersection.other), toleranceSquared: toleranceSquared) {
                        continue
                    }
                    if rhs.isOnVertex(lhs.compute(at: intersection.`self`), toleranceSquared: toleranceSquared) {
                        continue
                    }

                    contours[lhsIndex].split(at: intersection.`self`)
                    contours[rhsIndex].split(at: intersection.other)

                    allIntersections.append((
                        lhsIndex, intersection.`self`,
                        rhsIndex, intersection.other
                    ))
                }

                // TODO: Figure out why moving the interference splitting to here breaks exclusive disjunctions
                #if false

                // Compute vertex/edge interference intersections
                for lhsSimplex in lhs.allSimplexes() {
                    for rhsSimplex in rhs.allSimplexes() {
                        if lhsSimplex.isOnSurface(rhsSimplex.start, toleranceSquared: toleranceSquared) {
                            let period = lhsSimplex.closestPeriod(to: rhsSimplex.start)
                            contours[lhsIndex].split(at: period)
                        }
                        if lhsSimplex.isOnSurface(rhsSimplex.end, toleranceSquared: toleranceSquared) {
                            let period = lhsSimplex.closestPeriod(to: rhsSimplex.end)
                            contours[lhsIndex].split(at: period)
                        }

                        if rhsSimplex.isOnSurface(lhsSimplex.start, toleranceSquared: toleranceSquared) {
                            let period = rhsSimplex.closestPeriod(to: lhsSimplex.start)
                            contours[rhsIndex].split(at: period)
                        }
                        if rhsSimplex.isOnSurface(lhsSimplex.end, toleranceSquared: toleranceSquared) {
                            let period = rhsSimplex.closestPeriod(to: lhsSimplex.end)
                            contours[rhsIndex].split(at: period)
                        }
                    }
                }

                #endif // #if false
            }
        }

        return (contours, allIntersections)
    }

    /// Appends a new contour into this graph.
    @inlinable
    internal mutating func appendContour(_ contour: Contour, tolerance: Scalar) {
        let simplexes = contour.allSimplexes()
        let shapeIndex = contours.count

        contourTree.insert(
            .init(
                contour: contour,
                bounds: contour.bounds,
                index: shapeIndex
            )
        )

        // Create nodes
        var nodes: [(Parametric2GeometrySimplex<Vector>, Node)] = []
        for simplex in simplexes {
            if let neighbor = nodeTree.nearestNeighbor(to: simplex.start) {
                if neighbor.location.distanceSquared(to: simplex.start) < tolerance * 2 {
                    neighbor.append(shapeIndex: shapeIndex, period: simplex.startPeriod)
                    nodes.append((simplex, neighbor))
                    continue
                }
            }

            let node = Node(
                id: nextNodeId(),
                location: simplex.start,
                kind: .geometry(
                    shapeIndex: shapeIndex,
                    period: simplex.startPeriod
                )
            )
            nodes.append((simplex, node))
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
                kind: kind,
                shapeIndex: shapeIndex,
                startPeriod: current.0.startPeriod,
                endPeriod: current.0.endPeriod
            )
            edges.append(edge)
        }

        let newNodes = nodes.map(\.1)
        let newEdges = edges

        addNodes(newNodes)
        addEdges(newEdges)

        contours.append(contour)
    }

    /// Computes interferences between edges and vertices, merging interfering
    /// edges and vertices.
    ///
    /// Interferences occur under a specified tolerance, where geometry is
    /// coincidental under that tolerance in space.
    ///
    /// Returns `true` if interferences where found and merged.
    @inlinable
    internal mutating func computeInterferences(
        intersections: [GlobalIntersection],
        tolerance: Scalar
    ) -> (hasMergedNodes: Bool, hasMergedEdges: Bool) {
        var hasMergedNodes = false
        var hasMergedEdges = false

        var intersectionsPerShape: [Int: [GlobalIntersection]] = [:]
        for intersection in intersections {
            intersectionsPerShape[intersection.lhs, default: []].append(intersection)
            intersectionsPerShape[intersection.rhs, default: []].append(intersection)
        }

        // MARK: Merge edges - part 1
        var edgesToCheck: OrderedSet<OrderedSet<Edge>> = []
        for edge in edges {
            let coincident =
                edgeTree
                .query(edge)
                .filter({ $0.isCoincident(with: edge, tolerance: tolerance) })

            guard !coincident.isEmpty else {
                continue
            }

            edgesToCheck.append(OrderedSet(coincident).union([edge]))
        }

        // Start by first splitting all edges that coincide such that the result
        // are edges that either coincide as the same span, or not at all.
        //
        // The next step of merging nodes works to combine the edge endpoints,
        // allowing a last pass across the edges to compute the result of the
        // coinciding edges.
        for edgesToCheck in edgesToCheck.minimized() {
            let edgesToCheck = edgesToCheck.sorted(by: { $0.id < $1.id })

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
                        splitEdge(shapeIndex: lhsStart[0].shapeIndex, period: lhsStart[0].period)
                        splitEdge(shapeIndex: lhsEnd[0].shapeIndex, period: lhsEnd[0].period)

                    case .rhsContainsLhs(let rhsStart, let rhsEnd):
                        splitEdge(shapeIndex: rhsStart[0].shapeIndex, period: rhsStart[0].period)
                        splitEdge(shapeIndex: rhsEnd[0].shapeIndex, period: rhsEnd[0].period)

                    case .lhsPrefixesRhs(let rhsEnd):
                        splitEdge(shapeIndex: rhsEnd[0].shapeIndex, period: rhsEnd[0].period)

                    case .lhsSuffixesRhs(let rhsStart):
                        splitEdge(shapeIndex: rhsStart[0].shapeIndex, period: rhsStart[0].period)

                    case .rhsPrefixesLhs(let lhsEnd):
                        splitEdge(shapeIndex: lhsEnd[0].shapeIndex, period: lhsEnd[0].period)

                    case .rhsSuffixesLhs(let lhsStart):
                        splitEdge(shapeIndex: lhsStart[0].shapeIndex, period: lhsStart[0].period)

                    case .rhsContainsLhsStart(let rhsStart, let lhsEnd):
                        splitEdge(shapeIndex: lhsEnd[0].shapeIndex, period: lhsEnd[0].period)
                        splitEdge(shapeIndex: rhsStart[0].shapeIndex, period: rhsStart[0].period)

                    case .rhsContainsLhsEnd(let lhsEnd, let rhsStart):
                        splitEdge(shapeIndex: lhsEnd[0].shapeIndex, period: lhsEnd[0].period)
                        splitEdge(shapeIndex: rhsStart[0].shapeIndex, period: rhsStart[0].period)
                    }
                }
            }
        }

        // MARK: Edge-vertex interferences
        for node in nodes {
            let nodeAABB = AABB2(center: node.location, size: .init(repeating: tolerance * 2))
            let edgesNearNode = edgeTree.query(nodeAABB)

            for edge in edgesNearNode where edge.start != node && edge.end != node {
                let (ratio, distanceSquared) = edge.closestRatio(to: node.location)

                // Avoid attempts to split an edge at its end points.
                guard ratio > 0 && ratio < 1 else {
                    continue
                }

                if distanceSquared.squareRoot() < tolerance {
                    splitEdge(edge, ratio: ratio)
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
        func areIntersection(_ n1: Node, _ n2: Node) -> Bool {
            for geometry in n1.geometries {
                guard let intersections = intersectionsPerShape[geometry.shapeIndex] else {
                    continue
                }

                if
                    intersections.contains(where: { intersection in
                        if
                            n1.references(shapeIndex: intersection.lhs, period: intersection.lhsPeriod)
                            && n2.references(shapeIndex: intersection.rhs, period: intersection.rhsPeriod)
                        {
                            return true
                        }

                        // Invert check
                        if
                            n1.references(shapeIndex: intersection.rhs, period: intersection.rhsPeriod)
                            && n2.references(shapeIndex: intersection.lhs, period: intersection.lhsPeriod)
                        {
                            return true
                        }

                        return false
                    })
                {
                    return true
                }
            }

            return false
        }

        var nodesToMerge: OrderedSet<OrderedSet<Node>> = []

        for node in nodes {
            let neighbors = nodeTree.nearestNeighbors(
                to: node.location,
                distanceSquared: 10
            )

            var finalSet: OrderedSet<Node> = []
            for neighbor in neighbors {
                guard neighbor !== node else {
                    finalSet.append(neighbor)
                    continue
                }
                if areClose(neighbor.location, node.location) || areIntersection(node, neighbor) {
                    finalSet.append(neighbor)
                }
            }

            if finalSet.count > 1 {
                nodesToMerge.append(finalSet)
            }
        }

        #if DEBUG

        var _nodesVisited: Set<Node> = []

        #endif

        for nodesToMerge in nodesToMerge.minimized() {
            let nodesToMerge = nodesToMerge.sorted(by: { $0.id < $1.id })

            guard nodesToMerge.count > 1, let first = nodesToMerge.first else {
                continue
            }

            #if DEBUG

            for node in nodesToMerge {
                assert(_nodesVisited.insert(node).inserted, "Found two minimized node sets that contained the same node reference: \(node)")
            }

            #endif

            let geometries: [Node.Kind.SharedGeometryEntry] = nodesToMerge.flatMap { node in
                switch node.kind {
                case .geometry(let shapeIndex, let period):
                    return [Node.Kind.SharedGeometryEntry(
                        shapeIndex: shapeIndex, period: period
                    )]

                case .sharedGeometry(let geometries):
                    return geometries
                }
            }

            let entries = nodesToMerge
                .flatMap(edges(towards:))
                .sorted(by: { $0.id < $1.id })
                .filter { edge in !nodesToMerge.contains(edge.start) || !nodesToMerge.contains(edge.end) }

            let exits = nodesToMerge
                .flatMap(edges(from:))
                .sorted(by: { $0.id < $1.id })
                .filter { edge in !nodesToMerge.contains(edge.start) || !nodesToMerge.contains(edge.end) }

            let newNode = Node(
                id: nextNodeId(),
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

            hasMergedNodes = true
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

            edgesToCheck.append(OrderedSet(coincident).union([edge]))
        }

        for edgesToCheck in edgesToCheck.minimized() {
            let edges = edgesToCheck.sorted(by: { $0.id < $1.id })
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

            hasMergedEdges = true
        }

        prune()

        return (hasMergedNodes, hasMergedEdges)
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
        /*
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
        */
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

        guard let geometry = edge.geometry.first(where: { $0.shapeIndex == shapeIndex }) else {
            return
        }

        let ratio = (period - geometry.startPeriod) / (geometry.endPeriod - geometry.startPeriod)

        splitEdge(edge, ratio: ratio)
    }

    /// Splits an edge into two sub-edges, covering the same period range, but
    /// with a new intermediary geometry node in between the end nodes at `period`.
    ///
    /// If `period` matches the edge's `startPeriod` or `endPeriod`, then the edge
    /// is not split and nothing is done.
    @inlinable
    mutating func splitEdge(
        _ edge: Edge,
        ratio: Scalar
    ) {
        guard ratio > 0 && ratio < 1 else {
            return
        }

        let kind: Node.Kind
        if edge.geometry.count == 1 {
            let geometry = edge.geometry[0]
            kind = .geometry(
                shapeIndex: geometry.shapeIndex,
                period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * ratio
            )
        } else {
            kind = .sharedGeometry(
                edge.geometry.map { geometry in
                    .init(
                        shapeIndex: geometry.shapeIndex,
                        period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * ratio
                    )
                }
            )
        }

        let midNode = Node(
            id: nextNodeId(),
            location: edge.materializePrimitive().ratioPoint(ratio),
            kind: kind
        )

        addNode(midNode)
        splitEdge(edge, ratio: ratio, midNode: midNode)
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
        ratio: Scalar,
        midNode: Node
    ) {
        if ratio == 0 {
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
        } else if ratio == 1 {
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

        let startGeometry: [Edge.SharedGeometryEntry] = edge.geometry.map { entry in
            return .init(
                shapeIndex: entry.shapeIndex,
                startPeriod: entry.startPeriod,
                endPeriod: entry.startPeriod + (entry.endPeriod - entry.startPeriod) * ratio
            )
        }
        let endGeometry: [Edge.SharedGeometryEntry] = edge.geometry.map { entry in
            return .init(
                shapeIndex: entry.shapeIndex,
                startPeriod: entry.startPeriod + (entry.endPeriod - entry.startPeriod) * ratio,
                endPeriod: entry.endPeriod
            )
        }

        let newStart = Edge(
            id: nextEdgeId(),
            start: edge.start,
            end: midNode,
            kind: kindStart,
            geometry: startGeometry,
            totalWinding: edge.totalWinding,
            winding: edge.winding
        )
        let newEnd = Edge(
            id: nextEdgeId(),
            start: midNode,
            end: edge.end,
            kind: kindEnd,
            geometry: endGeometry,
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
