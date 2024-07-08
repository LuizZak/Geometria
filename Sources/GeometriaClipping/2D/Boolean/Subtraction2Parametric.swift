/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Subtraction2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
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

        let rhsReversed = rhs.reversed()

        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhsReversed,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isOtherWithinSelf() {
                // TODO: Implement holes
                return [lhs.allSimplexes()]
            }
            if lookup.isSelfWithinOther() {
                return []
            }

            return [lhs.allSimplexes()]
        }

        // For subtractions, every final shape is composed of parts of the positive
        // geometry (lhs, in this case), and the negative geometry (rhs), in
        // sequence, alternating, until looping back to the starting point of
        // the current sub-section.
        //
        // To find the sub-sections that are part of the remaining positive
        // geometries, we first find a starting intersection point that brings
        // lhs into rhs, and from that point, split the path into two: one path
        // handles the looping of the current section, and the other searches
        // for the next geometry part to subtract.
        //
        // On path 1 (looping of current section):
        //   Travel through all intersections, starting from lhs, alternating
        //   between of lhs <-> rhs at every intersection point, until the initial
        //   point is reached; the geometry is then flushed as a separate simplex
        //   sequence.
        //
        // On path 2 (finding next section to subtract):
        //   Travel through lhs until the next intersection point that brings it
        //   into rhs is found, and check if that point is not party of an existing
        //   simplex produced by loop 1; if not, start the first path on the current
        //   point and proceed until all points belong to simplexes in rhs.
        var resultOverall: [[Simplex]] = []
        var simplexVisited: Set<State> = []
        var visitedOverall: Set<State> = []

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state)
        } else {
            state = lookup.previous(state)
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
