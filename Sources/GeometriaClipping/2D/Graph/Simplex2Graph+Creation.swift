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

        let intersectionCache = GlobalIntersectionCache.fromIntersections(intersections: intersections)

        // Populate with contours
        for contour in contours {
            result.appendContour(contour, tolerance: tolerance, intersections: intersectionCache)
        }

        // Compute interferences
        if result.computeInterferences(intersections: intersections, tolerance: tolerance).hasMergedEdges {
            result.assertIsValid()

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
                newGraph.appendContour(contour, tolerance: tolerance, intersections: .fromIntersections(intersections: []))
            }

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

        let contourIndices = contours.enumerated().map {
            ContourIndexPair(bounds: $0.element.bounds, index: $0.offset)
        }
        let contourTree = SpatialTree(contourIndices, maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 4)

        let toleranceSquared = tolerance
        for lhsIndex in 0..<contours.count {
            contourTree.lazyQuery(contours[lhsIndex]) { element in
                if element.index == lhsIndex {
                    return
                }
                if element.index < lhsIndex {
                    return
                }

                let rhsIndex = element.index
                let intersections = contours[lhsIndex].rawIntersectionPeriods(contours[rhsIndex], tolerance: tolerance)

                for intersection in intersections {
                    // Ignore interference intersections between vertices/edges
                    if contours[lhsIndex].isOnVertex(contours[rhsIndex].compute(at: intersection.other), toleranceSquared: toleranceSquared) {
                        continue
                    }
                    if contours[rhsIndex].isOnVertex(contours[lhsIndex].compute(at: intersection.`self`), toleranceSquared: toleranceSquared) {
                        continue
                    }

                    contours[lhsIndex].split(at: intersection.`self`, tolerance: tolerance)
                    contours[rhsIndex].split(at: intersection.other, tolerance: tolerance)

                    allIntersections.append((
                        lhsIndex, intersection.`self`,
                        rhsIndex, intersection.other
                    ))
                }

                // Compute edge/edge interference intersections
                for lhsSimplex in contours[lhsIndex].allSimplexes() {
                    for rhsSimplex in contours[rhsIndex].allSimplexes() {
                        let coincidence = lhsSimplex.coincidenceRelationship(with: rhsSimplex, tolerance: tolerance)

                        switch coincidence {
                        case .sameSpan, .notCoincident:
                            break

                        case .lhsContainsRhs(let lhsStart, let lhsEnd):
                            contours[lhsIndex].split(at: lhsStart, tolerance: tolerance)
                            contours[lhsIndex].split(at: lhsEnd, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsStart, rhsIndex, rhsSimplex.startPeriod)
                            )
                            allIntersections.append(
                                (lhsIndex, lhsEnd, rhsIndex, rhsSimplex.endPeriod)
                            )

                        case .rhsContainsLhs(let rhsStart, let rhsEnd):
                            contours[rhsIndex].split(at: rhsStart, tolerance: tolerance)
                            contours[rhsIndex].split(at: rhsEnd, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsSimplex.startPeriod, rhsIndex, rhsStart)
                            )
                            allIntersections.append(
                                (lhsIndex, lhsSimplex.endPeriod, rhsIndex, rhsEnd)
                            )

                        case .lhsPrefixesRhs(let rhsEnd):
                            contours[rhsIndex].split(at: rhsEnd, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsSimplex.endPeriod, rhsIndex, rhsEnd)
                            )

                        case .lhsSuffixesRhs(let rhsStart):
                            contours[rhsIndex].split(at: rhsStart, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsSimplex.startPeriod, rhsIndex, rhsStart)
                            )

                        case .rhsPrefixesLhs(let lhsEnd):
                            contours[lhsIndex].split(at: lhsEnd, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsEnd, rhsIndex, rhsSimplex.endPeriod)
                            )

                        case .rhsSuffixesLhs(let lhsStart):
                            contours[lhsIndex].split(at: lhsStart, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsStart, rhsIndex, rhsSimplex.startPeriod)
                            )

                        case .rhsContainsLhsStart(let rhsStart, let lhsEnd):
                            contours[rhsIndex].split(at: rhsStart, tolerance: tolerance)
                            contours[lhsIndex].split(at: lhsEnd, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsSimplex.startPeriod, rhsIndex, rhsStart)
                            )
                            allIntersections.append(
                                (lhsIndex, lhsEnd, rhsIndex, rhsSimplex.endPeriod)
                            )

                        case .rhsContainsLhsEnd(let lhsEnd, let rhsStart):
                            contours[lhsIndex].split(at: lhsEnd, tolerance: tolerance)
                            contours[rhsIndex].split(at: rhsStart, tolerance: tolerance)

                            allIntersections.append(
                                (lhsIndex, lhsEnd, rhsIndex, rhsSimplex.startPeriod)
                            )
                            allIntersections.append(
                                (lhsIndex, lhsSimplex.endPeriod, rhsIndex, rhsStart)
                            )
                        }
                    }
                }
            }
        }

        return (contours, allIntersections)
    }

    /// Appends a new contour into this graph.
    @inlinable
    internal mutating func appendContour(
        _ contour: Contour,
        tolerance: Scalar,
        intersections: GlobalIntersectionCache
    ) {
        let simplexes = contour.allSimplexes()
        guard !simplexes.isEmpty else {
            return
        }

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
                var shouldMerge = false

                if neighbor.location.distanceSquared(to: simplex.start) < tolerance * 2 {
                    shouldMerge = true
                } else if neighbor.location.distanceSquared(to: simplex.start) < 1 {
                    for geometry in neighbor.geometries {
                        let intersections = intersections.intersections[geometry.shapeIndex, default: []]

                        for intersection in intersections {
                            if shapeIndex == intersection.1 && simplex.startPeriod == intersection.2 {
                                shouldMerge = true
                            }
                        }
                    }
                }

                if shouldMerge {
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

        var nodesToMerge: OrderedSet<OrderedSet<Node>> = []

        // MARK: Edge-vertex interferences
        for node in nodes {
            let nodeAABB = AABB2(center: node.location, size: .init(repeating: tolerance * 2))

            edgeTree.lazyQuery(nodeAABB) { edge in
                guard edge.start != node && edge.end != node else {
                    return
                }

                let (ratio, distanceSquared) = edge.closestRatio(to: node.location)

                // Avoid attempts to split an edge at its end points.
                guard ratio > 0 && ratio < 1 else {
                    return
                }

                if distanceSquared < tolerance {
                    let midNode = splitEdge(edge, ratio: ratio)

                    nodesToMerge.append([node, midNode])
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

        for node in nodes {
            let neighbors = nodeTree.nearestNeighbors(
                to: node.location,
                distanceSquared: tolerance * tolerance
            )

            var finalSet: OrderedSet<Node> = []
            for neighbor in neighbors {
                guard neighbor !== node else {
                    finalSet.append(neighbor)
                    continue
                }
                if areClose(neighbor.location, node.location) {
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

        // MARK: Merge edges
        var edgesToCheck: OrderedSet<OrderedSet<Edge>> = []

        for edge in edges {
            var coincident: [Edge] = []

            edgeTree.lazyQuery(edge) { next in
                if next.coincidenceRelationship(with: edge, tolerance: tolerance) == .sameSpan {
                    coincident.append(next)
                }
            }

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

                // Merge edge references
                for nextEdge in edges.dropFirst() {
                    for geometry in nextEdge.geometry {
                        edges[0].appending(
                            shapeIndex: geometry.shapeIndex,
                            startPeriod: geometry.startPeriod,
                            endPeriod: geometry.endPeriod
                        )
                    }
                }
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
        #if DEBUG

        for edge in self.edges {
            assert(containsNode(edge.start))
            assert(containsNode(edge.end))
        }

        for node in self.nodes {
            let indegree = self.indegree(of: node)
            let outdegree = self.outdegree(of: node)

            assert(indegree > 0, "geometry.indegree > 0", file: file, line: line)
            assert(outdegree > 0, "geometry.outdegree > 0", file: file, line: line)
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
    @discardableResult
    @inlinable
    mutating func splitEdge(
        _ edge: Edge,
        ratio: Scalar
    ) -> Node {
        guard ratio > 0 else {
            return edge.start
        }
        guard ratio < 1 else {
            return edge.end
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

        return midNode
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
    func dbg_edgeTree() {
        var buffer = """
        function setup() {
            createCanvas(800, 600)
            rectMode(CORNER)
        }

        function draw() {
            noFill()
        """

        let views = edgeTree.viewsForSubdivisions()

        for view in views {
            buffer += "\n    stroke(0)"

            let line = "rect(\(view.bounds.x), \(view.bounds.y), \(view.bounds.width), \(view.bounds.height))"
            buffer += "\n    \(line)"

            buffer += "\n    stroke(255, 0, 0)"

            for element in view.elements {
                let line = "rect(\(element.bounds.x), \(element.bounds.y), \(element.bounds.width), \(element.bounds.height))"
                buffer += "\n        \(line)"

                switch element.materializePrimitive() {
                case .lineSegment2(let lineSegment2):
                    let line = "line(\(lineSegment2.start.x), \(lineSegment2.start.y), \(lineSegment2.end.x), \(lineSegment2.end.y))"
                    buffer += "\n        \(line)"

                case .circleArc2(_):
                    break
                }
            }
        }

        buffer += "\n}"

        print(buffer)
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

    @usableFromInline
    internal struct ContourIndexPair: BoundableType {
        @usableFromInline
        let bounds: AABB<Vector>
        @usableFromInline
        let index: Int

        @usableFromInline
        init(bounds: AABB<Vector>, index: Int) {
            self.bounds = bounds
            self.index = index
        }
    }

    @usableFromInline
    internal struct GlobalIntersectionCache {
        @usableFromInline
        var intersections: [Int: [(Period, Int, Period)]]

        @inlinable
        init(intersections: [Int: [(Period, Int, Period)]] = [:]) {
            self.intersections = intersections
        }

        @usableFromInline
        mutating func register(lhsIndex: Int, lhsPeriod: Period, rhsIndex: Int, rhsPeriod: Period) {
            self.intersections[lhsIndex, default: []].append((lhsPeriod, rhsIndex, rhsPeriod))
        }

        @usableFromInline
        static func fromIntersections(intersections: [GlobalIntersection]) -> Self {
            var result = Self()

            for intersection in intersections {
                result.register(
                    lhsIndex: intersection.lhs,
                    lhsPeriod: intersection.lhsPeriod,
                    rhsIndex: intersection.rhs,
                    rhsPeriod: intersection.rhsPeriod
                )
            }

            return result
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
                let periods = selfSimplex.intersectionPeriods(with: otherSimplex)
                atoms.append(contentsOf: periods)
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
