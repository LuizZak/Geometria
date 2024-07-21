import Geometria

/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Union2Parametric<Vector: Vector2Real & Hashable>: Boolean2Parametric {
    public typealias Contour = Parametric2Contour<Vector>

    public let contours: [Contour]
    public let tolerance: Scalar

    public init<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        tolerance: T1.Scalar = .leastNonzeroMagnitude
    ) where T1.Vector == T2.Vector, T1.Vector == Vector, T1.Vector: Hashable {
        self.init(
            contours: lhs.allContours() + rhs.allContours(),
            tolerance: tolerance
        )
    }

    public init(
        contours: [Contour],
        tolerance: Scalar = .leastNonzeroMagnitude
    ) {
        self.contours = contours
        self.tolerance = tolerance
    }

    public func allContours() -> [Contour] {
        typealias Graph = Simplex2Graph<Vector>

        var graph = Graph.fromParametricIntersections(
            contours: contours,
            tolerance: tolerance
        )

        // Remove all edges that have incompatible total windings according to
        // their contour windings
        for edge in graph.edges {
            let shouldRemove: Bool

            switch edge.winding {
            case .clockwise:
                shouldRemove = edge.totalWinding != 1

            case .counterClockwise:
                shouldRemove = edge.totalWinding != 0
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
            return resultOverall.allContours(applyWindingFiltering: false)
        }

        // TODO: Refactor this common part out of Intersection2Parametric

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
                break
            }

            current = next.start
        }

        return resultOverall.allContours(applyWindingFiltering: false)
    }

    static func union<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        tolerance: Vector.Scalar = .leastNonzeroMagnitude,
        _ lhs: T1,
        _ rhs: T2
    ) -> Compound2Parametric<Vector> where T1.Vector == T2.Vector, T1.Vector == Vector, T1.Vector: Hashable {
        let op = Self(lhs, rhs, tolerance: tolerance)
        return .init(contours: op.allContours())
    }
}

/// Performs a union operation across all given parametric geometries.
///
/// - precondition: `shapes` is not empty.
public func union<Vector: Hashable>(
    tolerance: Vector.Scalar = .leastNonzeroMagnitude,
    _ shapes: [some ParametricClip2Geometry<Vector>]
) -> Compound2Parametric<Vector> {
    guard let first = shapes.first else {
        preconditionFailure("!shapes.isEmpty")
    }

    var result = Compound2Parametric<Vector>(first)
    for next in shapes.dropFirst() {
        result = Union2Parametric<Vector>
            .union(
                tolerance: tolerance,
                result,
                Compound2Parametric<Vector>(next)
            )
    }
    return result
}
