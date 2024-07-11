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

    public func allSimplexes() -> [[Simplex]] {
        typealias State = GeometriaClipping.State<T1, T2>

        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhs,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isOtherWithinSelf() {
                return [rhs.allSimplexes()]
            }
            if lookup.isSelfWithinOther() {
                return [lhs.allSimplexes()]
            }

            return []
        }

        // For intersections, we need to visit every possible corner of lhs, so
        // we keep track of simplexes visited overall during production, as well
        // as continually produce simplexes for the isolated segments that need
        // to be built
        var resultOverall: [[Simplex]] = []
        var simplexVisited: Set<State> = []
        var visitedOverall: Set<State> = []

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state).flipped()
        } else {
            state = lookup.previousOrEqual(state).flipped()
        }

        while visitedOverall.insert(state).inserted {
            if !simplexVisited.contains(state) {
                var result: [Simplex] = []
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
                result = result.normalized(startPeriod: .zero, endPeriod: 1)
                resultOverall.append(result)
            }

            // Here we skip twice in order to skip the portion of lhs that is
            // occluded behind rhs, and land on the next intersection that brings
            // lhs inside rhs
            state = lookup.next(lookup.next(state))
        }

        return resultOverall
    }
}
