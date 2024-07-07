/// A Union boolean periodic that joins two shapes into a single shape, if they
/// intersect in space.
public struct Union2Periodic<T1: Periodic2Geometry, T2: Periodic2Geometry>: Boolean2Periodic
    where T1.Vector == T2.Vector
{
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allSimplexes() -> [[Simplex]] {
        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhs,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isSelfWithinOther() {
                return [lhs.allSimplexes()]
            }
            if lookup.isOtherWithinSelf() {
                return [rhs.allSimplexes()]
            }

            return [lhs.allSimplexes(), rhs.allSimplexes()]
        }

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state)
        } else {
            state = lookup.previous(state)
        }

        var result: [Simplex] = []
        var visited: Set<State> = []

        while visited.insert(state).inserted {
            var next = lookup.next(state)
            let nextSimplexEnd = lookup.nextSimplexEnd(state)
            var usedIntersection: Bool = true

            if lookup.periodPrecedes(from: state, nextSimplexEnd, next) {
                next = nextSimplexEnd
                usedIntersection = false
            }

            // Append simplex
            let simplex = lookup.clampedSimplexesRange(state, next)
            result.append(contentsOf: simplex)

            if usedIntersection {
                state = next.flipped()
            } else {
                state = next
            }
        }

        // Re-normalize the simplex periods
        result = result.normalized(startPeriod: .zero, endPeriod: 1)

        return [result]
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

fileprivate extension IntersectionLookup {
    typealias State = Union2Periodic<T1, T2>.State

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

    func periodPrecedes(from start: State, _ lhs: State, _ rhs: State) -> Bool {
        switch (start, lhs, rhs) {
        case (.onLhs(let start, _), .onLhs(let lhs, _), .onLhs(let rhs, _)):
            return selfShape.periodPrecedes(from: start, lhs, rhs)

        case (.onLhs(_, let start), .onRhs(_, let lhs), .onRhs(_, let rhs)):
            return otherShape.periodPrecedes(from: start, lhs, rhs)

        default:
            return false
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
