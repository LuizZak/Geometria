import MiniDigraph
import Geometria

/// A graph that describes a set of geometry vertices + intersection points, with
/// edges that correspond to simplexes of a 2-dimensional geometry.
struct Simplex2Graph<Vector: Vector2Real & Hashable> {
    typealias Scalar = Vector.Scalar

    fileprivate(set) var nodes: Set<Node> = []
    fileprivate(set) var edges: Set<Edge> = []

    /// Returns first intersection before `node`
    ///
    /// - note: Respects `onLhs` of node, if it's a geometry node.
    func firstIntersection(before node: Node) -> Node? {
        let onLhs = node.onLhs
        var result: Node?

        customBreadthFirstSearch(start: node, reversed: true) { visit in
            let nextEdges = edges(towards: visit.node)

            guard visit.node.isIntersection else {
                return nextEdges.filter { edge in
                    let node = startNode(for: edge)
                    return node.isIntersection || node.onLhs == onLhs
                }
            }

            result = visit.node
            return nil
        }

        return result
    }

    /// Returns first intersection past `node`
    ///
    /// - note: Respects `onLhs` of node, if it's a geometry node.
    func firstIntersection(after node: Node) -> Node? {
        let onLhs = node.onLhs
        var result: Node?

        customBreadthFirstSearch(start: node) { visit in
            let nextEdges = edges(from: visit.node)

            guard visit.node.isIntersection else {
                return nextEdges.filter { edge in
                    let node = endNode(for: edge)
                    return node.isIntersection || node.onLhs == onLhs
                }
            }

            result = visit.node
            return nil
        }

        return result
    }

    struct Node: Identifiable, Hashable {
        var id: Int
        var kind: Kind

        var point: Vector {
            kind.point
        }

        var onLhs: Bool? {
            kind.onLhs
        }

        var isIntersection: Bool {
            kind.isIntersection
        }

        enum Kind: Hashable {
            /// A geometry node.
            case geometry(Vector, onLhs: Bool)

            /// An intersection node.
            case intersection(Vector)

            var point: Vector {
                switch self {
                case .geometry(let point, _),
                    .intersection(let point):
                    return point
                }
            }

            var onLhs: Bool? {
                switch self {
                case .geometry(_, let onLhs):
                    return onLhs

                case .intersection:
                    return nil
                }
            }

            var isIntersection: Bool {
                switch self {
                case .geometry:
                    return false
                case .intersection:
                    return true
                }
            }
        }
    }

    struct Edge: DirectedGraphEdge {
        var start: Node.ID
        var end: Node.ID

        var lengthSquared: Scalar
        var kind: Kind

        enum Kind: Hashable {
            /// A simple straight line edge.
            case line

            /// A circular arc edge, with a center point and sweep.
            case circleArc(center: Vector, sweep: Angle<Vector.Scalar>)
        }
    }
}

extension Simplex2Graph: DirectedGraphType {
    func startNode(for edge: Edge) -> Node {
        guard let node = nodes.first(where: { $0.id == edge.start }) else {
            preconditionFailure("Edge references node ID \(edge.start) that is not in this graph")
        }

        return node
    }

    func endNode(for edge: Edge) -> Node {
        guard let node = nodes.first(where: { $0.id == edge.end }) else {
            preconditionFailure("Edge references node ID \(edge.end) that is not in this graph")
        }

        return node
    }

    func edges(from node: Node) -> Set<Edge> {
        edges.filter { $0.start == node.id }
    }

    func edges(towards node: Node) -> Set<Edge> {
        edges.filter { $0.end == node.id }
    }

    func edge(from start: Node, to end: Node) -> Edge? {
        edges.first(where: { $0.start == start.id && $0.end == end.id })
    }
}

extension Simplex2Graph: MutableDirectedGraphType {
    mutating func addNode(_ node: Simplex2Graph<Vector>.Node) {
        nodes.insert(node)
    }

    mutating func removeNode(_ node: Simplex2Graph<Vector>.Node) {
        nodes.remove(node)
    }

    mutating func addEdge(_ edge: Simplex2Graph<Vector>.Edge) -> Simplex2Graph<Vector>.Edge {
        edges.insert(edge).memberAfterInsert
    }

    mutating func removeEdge(_ edge: Simplex2Graph<Vector>.Edge) {
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
