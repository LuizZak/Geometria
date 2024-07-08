import Geometria

/// Retains information about intersections and the shapes that produced them to
/// be used by boolean parametric operators.
internal class IntersectionLookup<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry> where T1.Vector == T2.Vector {
    typealias Intersection = (`self`: T1.Period, other: T2.Period)

    private let selfSimplexes: [T1.Simplex]
    private let otherSimplexes: [T2.Simplex]

    private let selfSorted: [Intersection]
    private let otherSorted: [Intersection]

    let selfShape: T1
    let otherShape: T2
    let intersections: [Intersection]

    convenience init(intersectionsOfSelfShape selfShape: T1, otherShape: T2, tolerance: T1.Scalar) {
        let intersections = selfShape.allIntersectionPeriods(
            otherShape,
            tolerance: tolerance
        )

        self.init(
            selfShape: selfShape,
            otherShape: otherShape,
            intersections: intersections
        )
    }

    init(selfShape: T1, otherShape: T2, intersections: [Intersection]) {
        self.intersections = intersections
        self.selfShape = selfShape
        self.otherShape = otherShape

        self.selfSimplexes = selfShape.allSimplexes()
        self.otherSimplexes = otherShape.allSimplexes()

        selfSorted = intersections.sorted(by: { $0.`self` < $1.`self` })
        otherSorted = intersections.sorted(by: { $0.other < $1.other })
    }

    /// Returns `true` if `self` is fully contained within `other`.
    ///
    /// This requires that no intersections be present.
    func isSelfWithinOther() -> Bool {
        guard intersections.isEmpty else {
            return false
        }

        // Sample at two random points to improve the chances we avoid floating-point
        // errors from failing containment checks
        return isInsideOther(selfPeriod: selfShape.startPeriod)
            || isInsideOther(selfPeriod: (selfShape.startPeriod + selfShape.endPeriod) / 2)
    }

    /// Returns `true` if `other` is fully contained within `self`.
    ///
    /// This requires that no intersections be present.
    func isOtherWithinSelf() -> Bool {
        guard intersections.isEmpty else {
            return false
        }

        // Sample at two random points to improve the chances we avoid floating-point
        // errors from failing containment checks
        return isInsideOther(otherPeriod: otherShape.startPeriod)
            || isInsideOther(otherPeriod: (otherShape.startPeriod + otherShape.endPeriod) / 2)
    }

    /// Returns `true` if the given period on `selfShape` computes to a point
    /// that is contained within `otherShape`.
    func isInsideOther(selfPeriod period: T1.Period) -> Bool {
        let point = selfShape.compute(at: period)

        return otherShape.contains(point)
    }

    /// Returns `true` if the given period on `otherShape` computes to a point
    /// that is contained within `selfShape`.
    func isInsideOther(otherPeriod period: T2.Period) -> Bool {
        let point = otherShape.compute(at: period)

        return selfShape.contains(point)
    }

    /// Returns the next simplex that ends after the given period point.
    ///
    /// If `selfShape` has no simplexes, `nil` is returned, instead.
    func nextSimplexEnd(onSelf period: T1.Period) -> T1.Simplex? {
        guard let index = selfSimplexes.firstIndex(where: {
            selfShape.periodPrecedes(period, $0.endPeriod)
        }) else {
            return selfSimplexes.first
        }

        return selfSimplexes[index]
    }

    /// Returns the next simplex that ends after the given period point.
    ///
    /// If `otherShape` has no simplexes, `nil` is returned, instead.
    func nextSimplexEnd(onOther period: T1.Period) -> T1.Simplex? {
        guard let index = otherSimplexes.firstIndex(where: {
            otherShape.periodPrecedes(period, $0.endPeriod)
        }) else {
            return otherSimplexes.first
        }

        return otherSimplexes[index]
    }

    /// Returns the previous simplex that start before the given period point.
    ///
    /// If `selfShape` has no simplexes, `nil` is returned, instead.
    func previousSimplexStart(onSelf period: T1.Period) -> T1.Simplex? {
        guard let index = selfSimplexes.lastIndex(where: {
            selfShape.periodPrecedes($0.startPeriod, period)
        }) else {
            return selfSimplexes.last
        }

        return selfSimplexes[index]
    }

    /// Returns the previous simplex that start before the given period point.
    ///
    /// If `otherShape` has no simplexes, `nil` is returned, instead.
    func previousSimplexStart(onOther period: T1.Period) -> T1.Simplex? {
        guard let index = otherSimplexes.lastIndex(where: {
            otherShape.periodPrecedes($0.startPeriod, period)
        }) else {
            return otherSimplexes.last
        }

        return otherSimplexes[index]
    }

    /// Returns the immediately next intersection period of the `self` shape
    /// in the intersection list that is strictly greater than `period`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func next(onSelf period: T1.Period) -> Intersection? {
        guard let index = selfSorted.firstIndex(where: { $0.`self` > period }) else {
            return selfSorted.first
        }

        return selfSorted[index]
    }

    /// Returns the immediately next intersection period of the `other` shape
    /// in the intersection list that is strictly greater than `period`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func next(onOther period: T2.Period) -> Intersection? {
        guard let index = otherSorted.firstIndex(where: { $0.other > period }) else {
            return otherSorted.first
        }

        return otherSorted[index]
    }

    /// Returns the immediately previous intersection period of the `self` shape
    /// in the intersection list that is strictly less than `period`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func previous(onSelf period: T1.Period) -> Intersection? {
        guard let index = selfSorted.lastIndex(where: { $0.`self` < period }) else {
            return selfSorted.last
        }

        return selfSorted[index]
    }

    /// Returns the immediately previous intersection period of the `other` shape
    /// in the intersection list that is strictly less than `period`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func previous(onOther period: T2.Period) -> Intersection? {
        guard let index = otherSorted.lastIndex(where: { $0.other < period }) else {
            return otherSorted.first
        }

        return otherSorted[index]
    }

    private func wrappedForward(_ intersection: Intersection) -> Intersection {
        return (
            self: intersection.`self` + selfShape.periodRange,
            other: intersection.other + otherShape.periodRange
        )
    }

    private func wrappedBack(_ intersection: Intersection) -> Intersection {
        return (
            self: intersection.`self` - selfShape.periodRange,
            other: intersection.other - otherShape.periodRange
        )
    }
}

extension IntersectionLookup where T1.Vector: Hashable {
    typealias State = GeometriaClipping.State<T1, T2>

    /// Returns the result of clamping simplexes from either the left-hand or
    /// right-hand side of the intersections defined by `start -> end`, based on
    /// the handedness of `start`.
    ///
    /// The result is the range of simplexes, clamped to be within
    /// `start.activePeriod..<end.activePeriod`, where `end.activePeriod` mirrors
    /// the handedness of `state`.
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

    /// Returns `true` if `lhs` precedes `rhs` when starting from `state`, on
    /// the shape associated with the handedness of the states.
    ///
    /// If any of the states is of a different handedness, `false` is returned,
    /// instead.
    func periodPrecedes(from start: State, _ lhs: State, _ rhs: State) -> Bool {
        switch (start, lhs, rhs) {
        case (.onLhs(let start, _), .onLhs(let lhs, _), .onLhs(let rhs, _)):
            return selfShape.periodPrecedes(from: start, lhs, rhs)

        case (.onRhs(_, let start), .onRhs(_, let lhs), .onRhs(_, let rhs)):
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

    /// Returns the immediately next intersection period of the shape associated
    /// with the handedness of the given state in the intersection list that is
    /// strictly greater than `state.activePeriod`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
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

    /// Returns the immediately previous intersection period of the shape associated
    /// with the handedness of the given state in the intersection list that is
    /// strictly lesser than `state.activePeriod`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
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
