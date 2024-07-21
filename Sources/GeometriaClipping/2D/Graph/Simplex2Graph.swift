import MiniDigraph
import Geometria

/// A graph that describes a set of geometry vertices + intersection points, with
/// edges that correspond to simplexes of a 2-dimensional geometry.
public struct Simplex2Graph<Vector: Vector2Real & Hashable> {
    public typealias Scalar = Vector.Scalar
    public typealias Period = Scalar
    public typealias Contour = Parametric2Contour<Vector>

    /// The next available edge ID to be used when adding contours.
    var edgeId: Int = 0

    public internal(set) var contours: [Contour]

    public fileprivate(set) var nodes: Set<Node> = []
    public fileprivate(set) var edges: Set<Edge> = []

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
        }
    }

    public class Edge: DirectedGraphEdge, Hashable, CustomStringConvertible {
        /// A unique identifier assigned during graph generation, used to sort
        /// edges by earliest generation.
        public var id: Int

        public var start: Node
        public var end: Node
        public var shapeIndex: Int
        public var startPeriod: Period
        public var endPeriod: Period
        public var kind: Kind

        public var totalWinding: Int = 0
        public var winding: Parametric2Contour<Vector>.Winding = .clockwise

        public var description: String {
            return "\(ObjectIdentifier(start)) -(\(kind))-> \(ObjectIdentifier(end))"
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
            kind: Kind
        ) {
            self.id = id
            self.start = start
            self.end = end
            self.shapeIndex = shapeIndex
            self.startPeriod = startPeriod
            self.endPeriod = endPeriod
            self.kind = kind
        }

        func queryPoint(_ center: (Period, Period) -> Period) -> Vector {
            func centerOfSimplex(_ simplex: Parametric2GeometrySimplex<Vector>) -> Vector {
                simplex.compute(at: center(simplex.startPeriod, simplex.endPeriod))
            }

            let simplex = materialize()
            return centerOfSimplex(simplex)
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
        guard let node = nodes.first(where: { $0 == edge.start }) else {
            preconditionFailure("Edge references node ID \(edge.start) that is not in this graph")
        }

        return node
    }

    public func endNode(for edge: Edge) -> Node {
        guard let node = nodes.first(where: { $0 == edge.end }) else {
            preconditionFailure("Edge references node ID \(edge.end) that is not in this graph")
        }

        return node
    }

    public func edges(from node: Node) -> Set<Edge> {
        edges.filter { $0.start == node }
    }

    public func edges(towards node: Node) -> Set<Edge> {
        edges.filter { $0.end == node }
    }

    public func edge(from start: Node, to end: Node) -> Edge? {
        edges.first(where: { $0.start == start && $0.end == end })
    }
}

extension Simplex2Graph: MutableDirectedGraphType {
    public init() {
        self.nodes = []
        self.edges = []
        self.contours = []
    }

    public mutating func addNode(_ node: Node) {
        nodes.insert(node)
    }

    public mutating func removeNode(_ node: Node) {
        nodes.remove(node)
        edges = edges.filter { edge in
            edge.start != node && edge.end != node
        }
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        edges.insert(edge).memberAfterInsert
    }

    public mutating func removeEdge(_ edge: Edge) {
        edges.remove(edge)
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
