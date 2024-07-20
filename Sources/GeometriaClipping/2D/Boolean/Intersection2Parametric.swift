import Geometria

/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Intersection2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
    where T1.Vector == T2.Vector, T1.Vector: Hashable
{
    public typealias Vector = T1.Vector
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar = .leastNonzeroMagnitude) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allContours() -> [Contour] {
        typealias Graph = Simplex2Graph<Vector>

        var graph = Graph.fromParametricIntersections(
            lhs,
            rhs,
            tolerance: tolerance
        )

        // Remove all edges that have incompatible total windings according to
        // their contour windings
        for edge in graph.edges {
            let shouldRemove: Bool

            switch edge.winding {
            case .clockwise:
                shouldRemove = edge.totalWinding != 2

            case .counterClockwise:
                shouldRemove = true
            }

            if shouldRemove {
                graph.removeEdge(edge)
            }
        }

        graph.prune()

        let resultOverall = ContourManager<Vector>()

        func candidateIsAscending(_ lhs: Graph.Edge, _ rhs: Graph.Edge) -> Bool {
            return lhs.id < rhs.id
        }

        var visitedOverall: Set<Graph.Node> = []

        guard var current = graph.edges.min(by: candidateIsAscending)?.start else {
            return resultOverall.allContours()
        }

        // Keep visiting nodes on the graph, removing them after each complete visit
        while visitedOverall.insert(current).inserted {
            let result = resultOverall.beginContour()
            var visited: Set<Graph.Node> = []

            // Visit all reachable nodes
            // The existing edges shouldn't matter as long as we pick any
            // suitable edge in a stable fashion for unit testing
            while visited.insert(current).inserted {
                guard let nextEdge = graph.edges(from: current).min(by: candidateIsAscending) else {
                    break
                }

                graph.removeEdge(nextEdge)

                result.append(nextEdge.materialize())
                current = nextEdge.end
            }

            result.endContour(startPeriod: .zero, endPeriod: 1)

            // Prune the graph by removing dead-end nodes and pull a new edge to
            // start traversing on any remaining nodes
            graph.prune()

            guard let next = graph.edges.min(by: candidateIsAscending) else {
                return resultOverall.allContours()
            }

            current = next.start
        }

        return resultOverall.allContours()
    }

    public static func intersection(
        tolerance: Scalar = .leastNonzeroMagnitude,
        _ lhs: T1,
        _ rhs: T2
    ) -> Compound2Parametric<Vector> {
        let op = Self(lhs, rhs, tolerance: tolerance)
        return .init(contours: op.allContours())
    }
}

/// Performs an intersection operation across all given parametric geometries.
///
/// - precondition: `shapes` is not empty.
public func intersection<Vector: Hashable>(
    tolerance: Vector.Scalar = .leastNonzeroMagnitude,
    _ shapes: [some ParametricClip2Geometry<Vector>]
) -> Compound2Parametric<Vector> {
    guard let first = shapes.first else {
        preconditionFailure("!shapes.isEmpty")
    }

    var result = Compound2Parametric<Vector>(first)
    for next in shapes.dropFirst() {
        result = Intersection2Parametric<Compound2Parametric<Vector>, Compound2Parametric<Vector>>
            .intersection(
                tolerance: tolerance,
                result,
                Compound2Parametric(next)
            )
    }
    return result
}
