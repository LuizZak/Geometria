import Geometria

/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Intersection2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
    where T1.Vector == T2.Vector, T1.Vector: Hashable
{
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allContours() -> [Contour] {
        #if true

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

        var simplexVisited: Set<Graph.Node> = []
        var visitedOverall: Set<Graph.Node> = []

        guard var current = graph.edges.min(by: candidateIsAscending)?.start else {
            return resultOverall.allContours()
        }

        var isOnLhs = true

        while visitedOverall.insert(current).inserted {
            if !simplexVisited.contains(current) {
                let result = resultOverall.beginContour()
                var visited: Set<Graph.Node> = []

                while visited.insert(current).inserted {
                    guard let nextEdge = graph.edges(from: current).min(by: candidateIsAscending) else {
                        break
                    }

                    graph.removeEdge(nextEdge)

                    result.append(nextEdge.materialize())
                    current = nextEdge.end

                    if current.isIntersection {
                        isOnLhs = !isOnLhs
                    }
                }

                result.endContour(startPeriod: .zero, endPeriod: 1)

                simplexVisited.formUnion(visited)
            }

            graph.prune()

            guard let next = graph.edges.min(by: candidateIsAscending) else {
                return resultOverall.allContours()
            }

            current = next.start
        }

        return resultOverall.allContours()

        #else

        typealias State = GeometriaClipping.State<Period>

        let lhsContours = lhs.allContours()
        let rhsContours = rhs.allContours()

        let lookup: IntersectionLookup<Vector> = .init(
            lhsShapes: lhsContours,
            lhsRange: lhs.startPeriod..<lhs.endPeriod,
            rhsShapes: rhsContours,
            rhsRange: rhs.startPeriod..<rhs.endPeriod,
            tolerance: tolerance
        )

        let resultOverall = ContourManager<Vector>()

        // Re-combine the contours by working from bottom-to-top, stopping at
        // contours that participate in intersections, adding the contours on top
        // of the result
        for index in 0..<lhsContours.count {
            if !lookup.hasIntersections(lhsIndex: index) {
                if lookup.isInside(lhsContours[index], rhsContours) {
                    resultOverall.append(lhsContours[index])
                }
            }
        }
        for index in 0..<rhsContours.count {
            if !lookup.hasIntersections(rhsIndex: index) {
                if lookup.isInside(rhsContours[index], lhsContours) {
                    resultOverall.append(lhsContours[index])
                }
            }
        }

        // For intersections, we need to visit every possible corner of lhs, so
        // we keep track of simplexes visited overall during production, as well
        // as continually produce simplexes for the isolated segments that need
        // to be built
        var simplexVisited: Set<State> = []
        var visitedOverall: Set<State> = []

        guard var state = lookup.candidateStart()?.flipped() else {
            return resultOverall.allContours()
        }

        while visitedOverall.insert(state).inserted {
            if !simplexVisited.contains(state) {
                let result = resultOverall.beginContour()
                var visited: Set<State> = []

                while visited.insert(state).inserted {
                    // Find next intersection
                    let next = lookup.next(state)

                    // Append simplex
                    let simplex = lookup.clampedSimplexesRange(state, next)
                    result.append(contentsOf: simplex)

                    // Flip to the next intersection
                    state = next.flipped()
                }

                simplexVisited.formUnion(visited)

                // Re-normalize the simplex periods
                result.endContour(startPeriod: .zero, endPeriod: 1)
            }

            // Here we skip twice in order to skip the portion of lhs that is
            // occluded behind rhs, and land on the next intersection that brings
            // lhs inside rhs
            state = lookup.next(lookup.next(state))
        }

        return resultOverall.allContours()

        #endif
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
