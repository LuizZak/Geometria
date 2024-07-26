import MiniDigraph
import Geometria
import GeometriaAlgorithms

/// A graph that describes a set of geometry vertices + intersection points, with
/// edges that correspond to simplexes of a 2-dimensional geometry.
public struct Simplex2Graph<Vector: Vector2Real & Hashable> {
    public typealias Scalar = Vector.Scalar
    public typealias Period = Scalar
    public typealias Contour = Parametric2Contour<Vector>

    /// Internal cached graph implementation.
    var graph: CachingDirectedGraph<Node, Edge>

    /// kd-tree of nodes.
    @usableFromInline
    var nodeTree: KDTree<Node> = .init(dimensionCount: 2, elements: [])

    /// Quad-tree of edges.
    @usableFromInline
    var edgeTree: QuadTree<Edge> = .init(maxSubdivisions: 8, maxElementsPerLevelBeforeSplit: 5)

    /// The next available edge ID to be used when adding contours.
    var edgeId: Int = 0

    public var contours: [Contour]

    public var nodes: Set<Node> {
        graph.nodes
    }
    public var edges: Set<Edge> {
        graph.edges
    }

    @usableFromInline
    mutating func nextEdgeId() -> Int {
        defer { edgeId += 1 }
        return edgeId
    }

    /// Returns `true` if any of the nodes within this simplex graph is an
    /// intersection.
    public func hasIntersections() -> Bool {
        nodes.contains(where: \.isIntersection)
    }

    /// Returns the edge for a given period within a given shape index number.
    @usableFromInline
    func edgeForPeriod(_ period: Period, shapeIndex: Int) -> Edge? {
        edges.first { edge in
            edge.shapeIndex == shapeIndex && edge.periodRange.contains(period)
        }
    }

    public class Node: Hashable, CustomStringConvertible {
        public typealias ShapeIndex = Int

        public var location: Vector
        public var kind: Kind

        public var description: String {
            "Node(location: \(location), kind: \(kind))"
        }

        public var isIntersection: Bool {
            kind.isIntersection
        }

        public var shapeIndex: Int? {
            kind.shapeIndex
        }

        public var lhsIndex: Int? {
            kind.lhsIndex
        }

        public var rhsIndex: Int? {
            kind.rhsIndex
        }

        @usableFromInline
        init(location: Vector, kind: Kind) {
            self.location = location
            self.kind = kind
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        public static func == (lhs: Node, rhs: Node) -> Bool {
            lhs === rhs
        }

        public enum Kind: Equatable, CustomStringConvertible {
            /// A geometry node.
            case geometry(
                shapeIndex: ShapeIndex,
                period: Period
            )

            /// A geometry node that is shared amongst different geometries.
            case sharedGeometry(
                [SharedGeometryEntry]
            )

            /// An intersection node.
            case intersection(
                lhs: ShapeIndex,
                lhsPeriod: Period,
                rhs: ShapeIndex,
                rhsPeriod: Period
            )

            public var description: String {
                switch self {
                case .geometry(let shapeIndex, let period):
                    return ".geometry(shapeIndex: \(shapeIndex), period: \(period))"

                case .sharedGeometry(let entries):
                    return ".sharedGeometry(\(entries))"

                case .intersection(let lhs, let lhsPeriod, let rhs, let rhsPeriod):
                    return ".intersection(lhs: \(lhs), lhsPeriod: \(lhsPeriod), rhs: \(rhs), rhsPeriod: \(rhsPeriod))"
                }
            }

            public var isIntersection: Bool {
                switch self {
                case .intersection:
                    return true

                default:
                    return false
                }
            }

            public var shapeIndex: Int? {
                switch self {
                case .geometry(let shapeIndex, _):
                    return shapeIndex

                default:
                    return nil
                }
            }

            public var lhsIndex: Int? {
                switch self {
                case .intersection(let index, _, _, _):
                    return index

                default:
                    return nil
                }
            }

            public var rhsIndex: Int? {
                switch self {
                case .intersection(_, _, let index, _):
                    return index

                default:
                    return nil
                }
            }

            public struct SharedGeometryEntry: Equatable, CustomStringConvertible {
                public var shapeIndex: ShapeIndex
                public var period: Period

                public var description: String {
                    "\(type(of: self))(shapeIndex: \(shapeIndex), period: \(period))"
                }

                @usableFromInline
                internal init(
                    shapeIndex: ShapeIndex,
                    period: Period
                ) {
                    self.shapeIndex = shapeIndex
                    self.period = period
                }
            }
        }
    }

    public class Edge: AbstractDirectedGraphEdge, Hashable, CustomStringConvertible {
        /// A unique identifier assigned during graph generation, used to sort
        /// edges by earliest generation.
        public var id: Int

        public var start: Node
        public var end: Node
        public var shapeIndex: Int
        public var startPeriod: Period
        public var endPeriod: Period
        public var kind: Kind

        public var totalWinding: Int
        public var winding: Parametric2Contour<Vector>.Winding

        public var description: String {
            return "\(ObjectIdentifier(start)) -(\(kind))-> \(ObjectIdentifier(end))"
        }

        public var bounds: AABB<Vector> {
            materialize().bounds
        }

        public var lengthSquared: Vector.Scalar {
            materialize().lengthSquared
        }

        public var periodRange: Range<Period> {
            startPeriod..<endPeriod
        }

        public init(
            id: Int,
            start: Node,
            end: Node,
            shapeIndex: Int,
            startPeriod: Period,
            endPeriod: Period,
            kind: Kind,
            totalWinding: Int = 0,
            winding: Parametric2Contour<Vector>.Winding = .clockwise
        ) {
            self.id = id
            self.start = start
            self.end = end
            self.shapeIndex = shapeIndex
            self.startPeriod = startPeriod
            self.endPeriod = endPeriod
            self.kind = kind
            self.totalWinding = totalWinding
            self.winding = winding
        }

        @inlinable
        func queryPoint(_ center: (Period, Period) -> Period) -> Vector {
            func centerOfSimplex(_ simplex: Parametric2GeometrySimplex<Vector>) -> Vector {
                simplex.compute(at: center(simplex.startPeriod, simplex.endPeriod))
            }

            let simplex = materialize()
            return centerOfSimplex(simplex)
        }

        /// Returns `true` if `self` is coincident with `other`, i.e. both edges
        /// represent the same underlying stroke, overlapping in space.
        ///
        /// The check ignores other edges that belong to the same shape.
        @usableFromInline
        func isCoincident(with other: Edge, tolerance: Scalar) -> Bool {
            // Edges cannot be collinear with themselves
            if other === self {
                return false
            }
            // TODO: Relax this step to a parameter to allow joining collinear edges later on
            // Edges cannot be collinear with other edges from the same shape
            if shapeIndex == other.shapeIndex {
                return false
            }

            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)

                if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
                    func lhsContains(_ scalar: Scalar) -> Bool {
                        return lhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }
                    func rhsContains(_ scalar: Scalar) -> Bool {
                        return rhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }

                    let lhsStart = rhsLine.projectAsScalar(lhsLine.start)
                    if rhsContains(lhsStart) {
                        return true
                    }

                    let lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
                    if rhsContains(lhsEnd) {
                        return true
                    }

                    let rhsStart = lhsLine.projectAsScalar(rhsLine.start)
                    if lhsContains(rhsStart) {
                        return true
                    }

                    let rhsEnd = lhsLine.projectAsScalar(rhsLine.end)
                    if lhsContains(rhsEnd) {
                        return true
                    }
                }

                return false

            case (
                .circleArc(let lhsCenter, let lhsRadius, let lhsStart, let lhsSweep),
                .circleArc(let rhsCenter, let rhsRadius, let rhsStart, let rhsSweep)
                ) where lhsCenter == rhsCenter && lhsRadius == rhsRadius:
                let lhsSweep = AngleSweep(start: lhsStart, sweep: lhsSweep)
                let rhsSweep = AngleSweep(start: rhsStart, sweep: rhsSweep)

                // Ignore angles that are joined end-to-end
                func withinTolerance(_ v1: Scalar, _ v2: Scalar) -> Bool {
                    (v1 - v2).magnitude <= tolerance
                }
                if
                    withinTolerance(lhsSweep.start.normalized(from: .zero), rhsSweep.stop.normalized(from: .zero)) ||
                    withinTolerance(lhsSweep.stop.normalized(from: .zero), rhsSweep.start.normalized(from: .zero))
                {
                    return false
                }

                return lhsSweep.intersects(rhsSweep)

            default:
                return false
            }
        }

        /// Returns `true` if this edge opposes the direction of another coincident
        /// edge.
        ///
        /// - note: Assumes that `self` and `other` are coincident edges, and
        /// returns `false` if the edges are of different kinds.
        @usableFromInline
        func isOpposingCoincident(_ other: Edge) -> Bool {
            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let lhsSlope = lhsLine.lineSlope
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)
                let rhsSlope = rhsLine.lineSlope

                return lhsSlope.sign == -rhsSlope.sign

            case (.circleArc(_, _, _, let lhsSweep), .circleArc(_, _, _, let rhsSweep)):
                return lhsSweep.radians.sign != rhsSweep.radians.sign

            default:
                return false
            }
        }

        /// Performs a coincidence check against another edge.
        @usableFromInline
        func coincidenceRelationship(
            with other: Edge,
            tolerance: Scalar
        ) -> CoincidenceRelationship {
            if other === self {
                // An edge cannot be coincident with itself.
                return .notCoincident
            }
            if shapeIndex == other.shapeIndex {
                // Edges belonging to the same shape are never coincident.
                return .notCoincident
            }

            func areClose(_ v1: Vector, _ v2: Vector) -> Bool {
                let diff = (v1 - v2)

                return diff.absolute.maximalComponent.magnitude < tolerance
            }

            let lhsStartCoincident: Bool
            let lhsEndCoincident: Bool

            var lhsStart: Scalar
            var lhsEnd: Scalar
            var rhsStart: Scalar
            var rhsEnd: Scalar

            let lhsContains: (_ scalar: Scalar) -> Bool
            let rhsContains: (_ scalar: Scalar) -> Bool
            let lhsPeriod: (_ scalar: Scalar) -> Period
            let rhsPeriod: (_ scalar: Scalar) -> Period

            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)

                // lhs:  •----•
                // rhs:  •----•
                lhsStartCoincident = areClose(lhsLine.start, rhsLine.start) || areClose(lhsLine.start, rhsLine.end)
                lhsEndCoincident = areClose(lhsLine.end, rhsLine.start) || areClose(lhsLine.end, rhsLine.end)

                if
                    lhsStartCoincident && lhsEndCoincident
                {
                    return .sameSpan
                }

                if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
                    lhsStart = rhsLine.projectAsScalar(lhsLine.start)
                    lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
                    rhsStart = lhsLine.projectAsScalar(rhsLine.start)
                    rhsEnd = lhsLine.projectAsScalar(rhsLine.end)

                    lhsContains = { scalar in
                        lhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }
                    rhsContains = { scalar in
                        rhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }

                    // Ensure start < end so checks are easier to make
                    if lhsStart > lhsEnd {
                        swap(&lhsStart, &lhsEnd)
                    }
                    if rhsStart > rhsEnd {
                        swap(&rhsStart, &rhsEnd)
                    }
                } else {
                    return .notCoincident
                }

            case (
                .circleArc(let lhsCenter, let lhsRadius, let lhsStartAngle, let lhsSweepAngle),
                .circleArc(let rhsCenter, let rhsRadius, let rhsStartAngle, let rhsSweepAngle)
                ) where lhsCenter == rhsCenter && lhsRadius == rhsRadius:
                let lhsSweep = AngleSweep(start: lhsStartAngle, sweep: lhsSweepAngle)
                let rhsSweep = AngleSweep(start: rhsStartAngle, sweep: rhsSweepAngle)

                guard lhsSweep.intersects(rhsSweep) else {
                    return .notCoincident
                }

                lhsStart = lhsSweep.start.radians
                lhsEnd = lhsSweep.stop.radians
                rhsStart = lhsSweep.start.radians
                rhsEnd = lhsSweep.stop.radians

                lhsContains = { value in
                    lhsSweep.contains(.init(radians: value))
                }
                rhsContains = { value in
                    rhsSweep.contains(.init(radians: value))
                }

                let lhs = CircleArc2(
                    center: lhsCenter,
                    radius: lhsRadius,
                    startAngle: lhsStartAngle,
                    sweepAngle: lhsSweepAngle
                )
                let rhs = CircleArc2(
                    center: rhsCenter,
                    radius: rhsRadius,
                    startAngle: rhsStartAngle,
                    sweepAngle: rhsSweepAngle
                )

                lhsStartCoincident =
                    areClose(lhs.startPoint, rhs.startPoint) ||
                    areClose(lhs.startPoint, rhs.endPoint)

                lhsEndCoincident =
                    areClose(lhs.endPoint, rhs.startPoint) ||
                    areClose(lhs.endPoint, rhs.endPoint)

                if
                    lhsStartCoincident && lhsEndCoincident
                {
                    return .sameSpan
                }

                // Ignore angles that are joined end-to-end
                func withinTolerance(_ v1: Scalar, _ v2: Scalar) -> Bool {
                    (v1 - v2).magnitude <= tolerance
                }

                if
                    withinTolerance(lhsSweep.start.normalized(from: .zero), rhsSweep.stop.normalized(from: .zero)) ||
                    withinTolerance(lhsSweep.stop.normalized(from: .zero), rhsSweep.start.normalized(from: .zero))
                {
                    return .notCoincident
                }

            default:
                return .notCoincident
            }

            lhsPeriod = { scalar in
                self.startPeriod + (self.endPeriod - self.startPeriod) * scalar
            }
            rhsPeriod = { scalar in
                other.startPeriod + (other.endPeriod - other.startPeriod) * scalar
            }

            // lhs:  •------•
            // rhs:   •----•
            if lhsContains(rhsStart) && lhsContains(rhsEnd) {
                return .lhsContainsRhs(
                    lhsStart: lhsPeriod(rhsStart), lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:   •----•
            // rhs:  •------•
            if rhsContains(lhsStart) && rhsContains(lhsEnd) {
                return .rhsContainsLhs(
                    rhsStart: rhsPeriod(lhsStart), rhsEnd: rhsPeriod(lhsEnd)
                )
            }

            // lhs:  •----•
            // rhs:    •----•
            if lhsContains(rhsStart) && rhsContains(lhsEnd) {
                return .rhsContainsLhsEnd(
                    lhsEnd: lhsPeriod(rhsStart), rhsStart: rhsPeriod(lhsEnd)
                )
            }

            // lhs:    •----•
            // rhs:  •----•
            if rhsContains(lhsStart) && lhsContains(rhsEnd) {
                return .rhsContainsLhsStart(
                    rhsStart: rhsPeriod(lhsStart), lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:  •------•
            // rhs:  •----•
            if lhsStartCoincident && lhsContains(rhsEnd) {
                return .rhsPrefixesLhs(
                    lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:  •----•
            // rhs:  •------•
            if lhsStartCoincident && rhsContains(lhsEnd) {
                return .lhsPrefixesRhs(
                    rhsEnd: rhsPeriod(lhsEnd)
                )
            }

            // lhs:  •------•
            // rhs:    •----•
            if lhsEndCoincident && lhsContains(rhsStart) {
                return .rhsSuffixesLhs(
                    lhsStart: lhsPeriod(rhsStart)
                )
            }

            // lhs:    •----•
            // rhs:  •------•
            if lhsEndCoincident && rhsContains(lhsEnd) {
                return .lhsSuffixesRhs(
                    rhsStart: rhsPeriod(lhsEnd)
                )
            }

            return .notCoincident
        }

        public func materialize() -> Parametric2GeometrySimplex<Vector> {
            switch kind {
            case .line:
                return .lineSegment2(
                    .init(
                        lineSegment: .init(
                            start: start.location,
                            end: end.location
                        ),
                        startPeriod: startPeriod,
                        endPeriod: endPeriod
                    )
                )

            case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                let arc = CircleArc2(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    sweepAngle: sweepAngle
                )

                return .circleArc2(
                    .init(
                        circleArc: arc,
                        startPeriod: startPeriod,
                        endPeriod: endPeriod
                    )
                )
            }
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        public static func == (lhs: Edge, rhs: Edge) -> Bool {
            lhs === rhs
        }

        public enum Kind: Equatable, CustomStringConvertible {
            /// A straight line edge.
            case line

            /// A circular arc edge, with a center point, radius, and start+sweep
            /// angles.
            case circleArc(
                center: Vector,
                radius: Vector.Scalar,
                startAngle: Angle<Vector.Scalar>,
                sweepAngle: Angle<Vector.Scalar>
            )

            public var description: String {
                switch self {
                case .line:
                    return ".line"

                case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                    return ".circleArc(center: \(center), radius: \(radius), startAngle: \(startAngle), sweepAngle: \(sweepAngle))"
                }
            }
        }

        /// A coincidence relationship between two edges that are coincident.
        ///
        /// The relationship between start/end nodes is relative to the receiver
        /// of the coincidence check call, e.g. 'lhs prefixing rhs' means that
        /// the incoming edge coincides with the receiver's start point, and its
        /// other point is contained within the receiver's span in space.
        public enum CoincidenceRelationship: Hashable {
            /// Edges are not coincident.
            case notCoincident

            /// Both edges span the same points in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:   •----•
            /// rhs:   •----•
            /// ```
            case sameSpan

            /// The receiver of the coincidence call contains the incoming edge
            /// parameter within its two points.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:   •----•
            /// ```
            case lhsContainsRhs(lhsStart: Period, lhsEnd: Period)

            /// The incoming edge parameter contains the receiver of the coincidence
            /// call within its two points.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:   •----•
            /// rhs:  •------•
            /// ```
            case rhsContainsLhs(rhsStart: Period, rhsEnd: Period)

            /// The receiver of the coincidence call overlaps the incoming edge
            /// parameter, prefixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •----•
            /// rhs:  •------•
            /// ```
            case lhsPrefixesRhs(rhsEnd: Period)

            /// The incoming edge parameter overlaps the receiver of the coincidence
            /// call, prefixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:  •----•
            /// ```
            case rhsPrefixesLhs(lhsEnd: Period)

            /// The receiver of the coincidence call overlaps the incoming edge
            /// parameter, suffixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:    •----•
            /// rhs:  •------•
            /// ```
            case lhsSuffixesRhs(rhsStart: Period)

            /// The incoming edge parameter overlaps the receiver of the coincidence
            /// call, suffixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:    •----•
            /// ```
            case rhsSuffixesLhs(lhsStart: Period)

            /// The incoming edge parameter overlaps the start point of the receiver
            /// of the coincidence call.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:    •----•
            /// rhs:  •----•
            /// ```
            case rhsContainsLhsStart(rhsStart: Period, lhsEnd: Period)

            /// The incoming edge parameter overlaps the end point of the receiver
            /// of the coincidence call.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •----•
            /// rhs:    •----•
            /// ```
            case rhsContainsLhsEnd(lhsEnd: Period, rhsStart: Period)
        }
    }
}

extension Simplex2Graph: DirectedGraphType {
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    public func edges(from node: Node) -> Set<Edge> {
        graph.edges(from: node)
    }

    public func edges(towards node: Node) -> Set<Edge> {
        graph.edges(towards: node)
    }

    public func edges(from start: Node, to end: Node) -> Set<Edge> {
        graph.edges(from: start, to: end)
    }

    public func indegree(of node: Node) -> Int {
        graph.indegree(of: node)
    }

    public func outdegree(of node: Node) -> Int {
        graph.outdegree(of: node)
    }
}

extension Simplex2Graph: MutableDirectedGraphType {
    public init() {
        self.graph = .init()
        self.contours = []
    }

    public mutating func addNode(_ node: Node) {
        nodeTree.insert(node)

        graph.addNode(node)
    }

    public mutating func removeNode(_ node: Node) {
        nodeTree.remove(node)

        graph.removeNode(node)
    }

    public mutating func removeNodes(_ nodes: some Sequence<Node>) {
        for edge in nodes.flatMap({ allEdges(for: $0) }) {
            edgeTree.remove(edge)
        }
        for node in nodes {
            nodeTree.remove(node)
        }

        graph.removeNodes(nodes)
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        edgeTree.insert(edge)

        return graph.addEdge(edge)
    }

    public mutating func removeEdge(_ edge: Edge) {
        graph.removeEdge(edge)

        edgeTree.remove(edge)
    }

    public mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>) {
        for edge in edgesToRemove {
            edgeTree.remove(edge)
        }

        graph.removeEdges(edgesToRemove)
    }
}

extension DirectedGraphType {
    func customBreadthFirstSearch(
        start: Node,
        reversed: Bool = false,
        visitor: (DirectedGraphRecordingVisitElement<Edge, Node>) -> Set<Edge>?
    ) {
        var visited: Set<Node> = []
        var queue: [VisitElement] = []

        queue.append(.start(start))

        while !queue.isEmpty {
            let next = queue.removeFirst()
            visited.insert(next.node)

            guard let nextEdges = visitor(next) else {
                return
            }

            for nextEdge in nextEdges {
                var node: Node
                if reversed {
                    node = startNode(for: nextEdge)
                } else {
                    node = endNode(for: nextEdge)
                }
                if visited.contains(node) {
                    continue
                }

                queue.append(next.appendingVisit(nextEdge, towards: node))
            }
        }
    }
}

extension Simplex2Graph.Node: KDTreeLocatable { }
extension Simplex2Graph.Edge: BoundableType { }
