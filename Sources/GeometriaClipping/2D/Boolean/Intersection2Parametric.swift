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

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            // If we don't flip here, the result behaves like a union instead of
            // an intersection
            state = lookup.next(state).flipped()
        } else {
            // ...and the same here
            state = lookup.previous(state).flipped()
        }

        var result: [Simplex] = []
        var visited: Set<State> = []

        while visited.insert(state).inserted {
            // Find next intersection
            let next = lookup.next(state)

            // Append simplex
            let simplex = lookup.clampedSimplexesRange(state, next)
            result.append(contentsOf: simplex)

            // Flip over to the next geometry
            state = next.flipped()
        }

        // Re-normalize the simplex periods
        result = result.normalized(startPeriod: .zero, endPeriod: 1)

        return [result]
    }
}
