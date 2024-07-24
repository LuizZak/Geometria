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
            if other === self {
                return false
            }
            if shapeIndex == other.shapeIndex {
                return false
            }

            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)

                if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
                    let lhsStart = rhsLine.projectAsScalar(lhsLine.start)
                    if lhsStart >= 0 && lhsStart <= 1 {
                        return true
                    }

                    let lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
                    if lhsEnd >= 0 && lhsEnd <= 1 {
                        return true
                    }

                    let rhsStart = lhsLine.projectAsScalar(rhsLine.start)
                    if rhsStart >= 0 && rhsStart <= 1 {
                        return true
                    }

                    let rhsEnd = lhsLine.projectAsScalar(rhsLine.end)
                    if rhsEnd >= 0 && rhsEnd <= 1 {
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

        graph.removeEdges(edges)
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
