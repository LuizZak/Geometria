/// A Union boolean periodic that joins two shapes into a single shape, if they
/// intersect in space.
public struct Subtraction2Periodic<T1: Periodic2Geometry, T2: Periodic2Geometry>: Boolean2Periodic
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
        let rhsReversed = rhs.reversed()

        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhsReversed,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isSelfWithinOther() {
                return []
            }
            if lookup.isOtherWithinSelf() {
                // TODO: Implement holes
                return [lhs.allSimplexes()]
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
        var visitedOverall: Set<State> = []

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state).flipped()
        } else {
            state = lookup.previous(state).flipped()
        }

        while visitedOverall.insert(state).inserted {
            var result: [Simplex] = []
            var visited: Set<State> = []

            while visited.insert(state).inserted {
                let next = lookup.next(state)

                // Append simplex
                let simplex = lookup.clampedSimplexesRange(state, next)
                result.append(contentsOf: simplex)

                state = next.flipped()
            }

            // Re-normalize the simplex periods
            result = result.normalized(startPeriod: .zero, endPeriod: 1)
            resultOverall.append(result)

            state = lookup.next(state)
            state = lookup.next(state)
        }

        return resultOverall
    }

    enum State: Hashable {
        case onLhs(T1.Period, T2.Period)
        case onRhs(T1.Period, T2.Period)

        var isLhs: Bool {
            switch self {
            case .onLhs: return true
            case .onRhs: return false
            }
        }

        var isRhs: Bool {
            switch self {
            case .onLhs: return false
            case .onRhs: return true
            }
        }

        var activePeriod: Period {
            switch self {
            case .onLhs(let period, _),
                .onRhs(_, let period):
                return period
            }
        }

        var lhsPeriod: T1.Period {
            switch self {
            case .onLhs(let lhs, _), .onRhs(let lhs, _):
                return lhs
            }
        }

        var rhsPeriod: T1.Period {
            switch self {
            case .onLhs(_, let rhs), .onRhs(_, let rhs):
                return rhs
            }
        }

        func flipped() -> Self {
            switch self {
            case .onLhs(let lhs, let rhs):
                return .onRhs(lhs, rhs)

            case .onRhs(let lhs, let rhs):
                return .onLhs(lhs, rhs)
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .onLhs(let value, _):
                hasher.combine(0)
                hasher.combine(value)

            case .onRhs(_, let value):
                hasher.combine(1)
                hasher.combine(value)
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs.isLhs, rhs.isLhs) {
            case (true, true):
                return lhs.lhsPeriod == rhs.lhsPeriod

            case (false, false):
                return lhs.rhsPeriod == rhs.rhsPeriod

            default:
                return false
            }
        }
    }
}

fileprivate extension IntersectionLookup where T1.Vector: Hashable {
    typealias State = Subtraction2Periodic<T1, T2>.State

    func clampedSimplexesRange(
        _ start: State,
        _ end: State
    ) -> [T1.Simplex] {

        switch start {
        case .onLhs(let lhsPeriod, _):
            // If start > end, clamp as two ranges that cross the origin instead
            if lhsPeriod > end.lhsPeriod {
                return selfShape.clampedSimplexes(in: lhsPeriod..<selfShape.endPeriod)
                    + selfShape.clampedSimplexes(in: selfShape.startPeriod..<end.lhsPeriod)
            }

            return selfShape.clampedSimplexes(in: lhsPeriod..<end.lhsPeriod)

        case .onRhs(_, let rhsPeriod):
            // Ditto here
            if rhsPeriod > end.rhsPeriod {
                return otherShape.clampedSimplexes(in: rhsPeriod..<otherShape.endPeriod)
                    + otherShape.clampedSimplexes(in: otherShape.startPeriod..<end.rhsPeriod)
            }

            return otherShape.clampedSimplexes(in: rhsPeriod..<end.rhsPeriod)
        }
    }

    /// - note: Calling `flip` with the result of this method may lead to the
    /// incorrect period on the flipped state; calling `next(state)` collapses
    /// the invalid secondary period back to a valid period that can be flipped
    /// to again.
    func nextSimplexEnd(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, let rhs):
            guard let simplex = nextSimplexEnd(onSelf: lhs) else {
                return state
            }

            return .onLhs(simplex.endPeriod, rhs)

        case .onRhs(let lhs, let rhs):
            guard let simplex = nextSimplexEnd(onOther: rhs) else {
                return state
            }

            return .onRhs(lhs, simplex.endPeriod)
        }
    }

    func next(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, _):
            guard let intersection = next(onSelf: lhs) else {
                return state
            }

            return .onLhs(intersection.`self`, intersection.other)

        case .onRhs(_, let rhs):
            guard let intersection = next(onOther: rhs) else {
                return state
            }

            return .onRhs(intersection.`self`, intersection.other)
        }
    }

    func previous(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, _):
            guard let intersection = previous(onSelf: lhs) else {
                return state
            }

            return .onLhs(intersection.`self`, intersection.other)

        case .onRhs(_, let rhs):
            guard let intersection = previous(onOther: rhs) else {
                return state
            }

            return .onRhs(intersection.`self`, intersection.other)
        }
    }
}
