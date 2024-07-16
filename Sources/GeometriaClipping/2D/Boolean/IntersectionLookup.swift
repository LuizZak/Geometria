import Geometria

/// Retains information about intersections and the shapes that produced them to
/// be used by boolean parametric operators.
internal class IntersectionLookup<Vector: Vector2Real> {
    typealias Period = Vector.Scalar
    typealias Intersection = (lhs: Period, lhsIndex: Int, rhs: Period, rhsIndex: Int)
    typealias Simplex = Parametric2GeometrySimplex<Vector>
    typealias Contour = Parametric2Contour<Vector>

    private let lhsShapes: [Contour]
    private let lhsRange: Range<Period>
    private let rhsShapes: [Contour]
    private let rhsRange: Range<Period>
    private var intersectionsSorted: [[Intersection]]
    private let tolerance: Vector.Scalar
    private(set) var intersections: [Intersection]

    init(
        lhsShapes: [Contour],
        lhsRange: Range<Period>,
        rhsShapes: [Contour],
        rhsRange: Range<Period>,
        tolerance: Vector.Scalar
    ) {
        self.lhsShapes = lhsShapes
        self.lhsRange = lhsRange
        self.rhsShapes = rhsShapes
        self.rhsRange = rhsRange
        self.intersections = []
        self.intersectionsSorted =
            Array(
                repeating: [],
                count: lhsShapes.count + rhsShapes.count
            )
        self.tolerance = tolerance

        self.populate()
    }

    private func populate() {
        // TODO: Make assertions that shapes don't self-intersect across lhsShapes/rhsShapes

        for (lhsIndex, lhs) in lhsShapes.enumerated() {
            let lhsOnSorted = lhsIndex

            for (rhsIndex, rhs) in rhsShapes.enumerated() {
                let rhsOnSorted = lhsShapes.count + rhsIndex
                guard lhs.bounds.intersects(rhs.bounds) else {
                    continue
                }

                let intersections = lhs
                    .allIntersectionPeriods(rhs, tolerance: tolerance)
                    .flatMap { $0.periods }

                for intersection in intersections {
                    let inter = (intersection.`self`, lhsIndex, intersection.`other`, rhsIndex)
                    self.intersections.append(inter)

                    intersectionsSorted[lhsOnSorted]
                        .insertSorted(inter, by: { $0.lhs < $1.lhs })
                    intersectionsSorted[rhsOnSorted]
                        .insertSorted(inter, by: { $0.rhs < $1.rhs })
                }
            }
        }
    }

    func hasIntersections() -> Bool {
        !intersections.isEmpty
    }

    func hasIntersections(lhsIndex: Int) -> Bool {
        !intersectionsSorted[lhsIndex].isEmpty
    }

    func hasIntersections(rhsIndex: Int) -> Bool {
        !intersectionsSorted[lhsShapes.count + rhsIndex].isEmpty
    }
}

extension IntersectionLookup where Vector: Hashable {
    typealias State = GeometriaClipping.State<Period>

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
    ) -> [Simplex] {

        switch start {
        case .onLhs(let lhsPeriod, let lhsIndex, _, _):
            let lhsShape = lhsShapes[lhsIndex]

            // If start > end, clamp as two ranges that cross the origin instead
            if lhsPeriod > end.lhsPeriod {
                return lhsShape.clampedSimplexes(in: lhsPeriod..<lhsRange.upperBound)
                    + lhsShape.clampedSimplexes(in: lhsRange.lowerBound..<end.lhsPeriod)
            }

            return lhsShape.clampedSimplexes(in: lhsPeriod..<end.lhsPeriod)

        case .onRhs(_, _, let rhsPeriod, let rhsIndex):
            let rhsShape = rhsShapes[rhsIndex]

            // Ditto here
            if rhsPeriod > end.rhsPeriod {
                return rhsShape.clampedSimplexes(in: rhsPeriod..<rhsRange.upperBound)
                    + rhsShape.clampedSimplexes(in: rhsRange.lowerBound..<end.rhsPeriod)
            }

            return rhsShape.clampedSimplexes(in: rhsPeriod..<end.rhsPeriod)
        }
    }

    /// Returns a potential candidate start for intersection traversal, based on
    /// the available contours, and their intersections.
    ///
    /// Unless there are no intersections, the result is the first, outermost,
    /// clockwise contour within `lhsShapes`, with an intersection that is bringing
    /// it into `rhsShapes`.
    ///
    /// If there are no intersections, `nil` is returned, instead.
    func candidateStart() -> State? {
        for contourIndex in 0..<lhsShapes.count {
            let contour = lhsShapes[contourIndex]
            guard contour.winding == .clockwise else {
                continue
            }

            let intersections = self.intersectionsSorted[contourIndex]
            guard !intersections.isEmpty else {
                continue
            }

            let state = State.onLhs(
                .zero,
                lhsIndex: contourIndex,
                .zero,
                rhsIndex: contourIndex
            )
            if isInsideRhs(at: state) {
                return next(state)
            } else {
                return previousOrEqual(state)
            }
        }

        return nil
    }

    /// Returns `true` if the given state on `lhsShapes` computes to a point
    /// that is contained within `rhsShapes`.
    ///
    /// - note: Does not take contour's winding in consideration.
    func isInsideRhs(at state: State) -> Bool {
        let contour = lhsShapes[state.lhsIndex]

        return _innerIsInside(contour, period: state.lhsPeriod, rhsShapes)
    }

    /// Returns `true` if the given index in `lhsShapes` has a containment within
    /// `rhsShapes`.
    ///
    /// - note: Does not take contour's winding in consideration.
    func isInsideRhs(lhsIndex: Int) -> Bool {
        let contour = lhsShapes[lhsIndex]

        return isInside(contour, rhsShapes)
    }

    /// Returns `true` if `contour` is inside at least one item in `otherContours`.
    ///
    /// - note: Does not take contour's winding in consideration.
    func isInside(_ contour: Contour, _ otherContours: [Contour]) -> Bool {
        _innerIsInside(contour, period: contour.startPeriod, otherContours)
    }

    /// - note: Does not take contour's winding in consideration.
    private func _innerIsInside(_ contour: Contour, period: Period, _ otherContours: [Contour]) -> Bool {
        for rhs in otherContours.reversed() {
            if isShape(contour, period, inside: rhs) {
                return true
            }
        }

        return false
    }

    /* TODO: Maybe not needed, ok to remove?
    /// Returns `true` if the given period on `otherShape` computes to a point
    /// that is contained within `selfShape`.
    func isInsideLhs(at state: State) -> Bool {
        let index = state.rhsIndex
        let contour = rhsShapes[index]

        for lhs in lhsShapes {
            if isShape(contour, state.rhsPeriod, inside: lhs) {
                return true
            }
        }

        return false
    }
    */

    /// - note: Does not take contour's winding in consideration.
    private func isShape(
        _ shape: Contour,
        _ period: Period,
        inside other: Contour
    ) -> Bool {
        guard other.bounds.intersects(shape.bounds) else {
            return false
        }

        let point = shape.compute(at: period)

        return other.contains(point)
    }

    /// Returns `true` if a given shape is fully contained within another.
    ///
    /// - note: Does not take contour's winding in consideration.
    private func isShape(
        _ shape: Contour,
        fullyInside other: Contour
    ) -> Bool {
        guard other.bounds.contains(shape.bounds) else {
            return false
        }
        // Shapes that intersect cannot be contained within another
        guard shape.allIntersectionPeriods(other, tolerance: tolerance).isEmpty else {
            return false
        }

        let point = shape.compute(at: shape.startPeriod)

        return other.contains(point)
    }

    private func sortedIntersections(for state: State) -> [Intersection] {
        switch state {
        case .onLhs(_, let lhsIndex, _, _):
            return intersectionsSorted[lhsIndex]

        case .onRhs(_, _, _, let rhsIndex):
            return intersectionsSorted[lhsShapes.count + rhsIndex]
        }
    }

    /// Returns `true` if `lhs` precedes `rhs` when starting from `state`, on
    /// the shape associated with the handedness of the states.
    ///
    /// If any of the states is of a different handedness, `false` is returned,
    /// instead.
    func periodPrecedes(from start: State, _ lhs: State, _ rhs: State) -> Bool {
        switch (start, lhs, rhs) {
        case (.onLhs(let start, let index, _, _), .onLhs(let lhs, _, _, _), .onLhs(let rhs, _, _, _)):
            return lhsShapes[index].periodPrecedes(from: start, lhs, rhs)

        case (.onRhs(_, _, let start, let index), .onRhs(_, _, let lhs, _), .onRhs(_, _, let rhs, _)):
            return rhsShapes[index].periodPrecedes(from: start, lhs, rhs)

        default:
            return false
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
        case .onLhs:
            let lhsIntersections = sortedIntersections(for: state)

            guard
                let index = lhsIntersections.nextIndex(
                    after: state.asTuple,
                    by: { $0.lhs < $1.lhs }
                )
            else {
                return state
            }

            let next = lhsIntersections[index]
            return .init(isLhs: true, next)

        case .onRhs:
            let rhsIntersections = sortedIntersections(for: state)

            guard
                let index = rhsIntersections.nextIndex(
                    after: state.asTuple,
                    by: { $0.rhs < $1.rhs }
                )
            else {
                return state
            }

            let next = rhsIntersections[index]
            return .init(isLhs: false, next)
        }
    }

    /// Returns the immediately next intersection period of the shape associated
    /// with the handedness of the given state in the intersection list that is
    /// greater than or equal to `state.activePeriod`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func nextOrEqual(_ state: State) -> State {
        switch state {
        case .onLhs:
            let lhsIntersections = sortedIntersections(for: state)

            guard
                let index = lhsIntersections.nextIndex(
                    after: state.asTuple,
                    by: { $0.lhs <= $1.lhs }
                )
            else {
                return state
            }

            let next = lhsIntersections[index]
            return .init(isLhs: true, next)

        case .onRhs:
            let rhsIntersections = sortedIntersections(for: state)

            guard
                let index = rhsIntersections.nextIndex(
                    after: state.asTuple,
                    by: { $0.rhs <= $1.rhs }
                )
            else {
                return state
            }

            let next = rhsIntersections[index]
            return .init(isLhs: false, next)
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
        case .onLhs:
            let lhsIntersections = sortedIntersections(for: state)

            guard
                let index = lhsIntersections.previousIndex(
                    before: state.asTuple,
                    by: { $0.lhs < $1.lhs }
                )
            else {
                return state
            }

            let previous = lhsIntersections[index]
            return .init(isLhs: true, previous)

        case .onRhs:
            let rhsIntersections = sortedIntersections(for: state)

            guard
                let index = rhsIntersections.previousIndex(
                    before: state.asTuple,
                    by: { $0.rhs < $1.rhs }
                )
            else {
                return state
            }

            let previous = rhsIntersections[index]
            return .init(isLhs: false, previous)
        }
    }

    /// Returns the immediately previous intersection period of the shape associated
    /// with the handedness of the given state in the intersection list that is
    /// lesser than or equal to `state.activePeriod`.
    ///
    /// If this intersection lookup is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    func previousOrEqual(_ state: State) -> State {
        switch state {
        case .onLhs:
            let lhsIntersections = sortedIntersections(for: state)

            guard
                let index = lhsIntersections.previousIndex(
                    before: state.asTuple,
                    by: { $0.lhs <= $1.lhs }
                )
            else {
                return state
            }

            let previous = lhsIntersections[index]
            return .init(isLhs: true, previous)

        case .onRhs:
            let rhsIntersections = sortedIntersections(for: state)

            guard
                let index = rhsIntersections.previousIndex(
                    before: state.asTuple,
                    by: { $0.rhs <= $1.rhs }
                )
            else {
                return state
            }

            let previous = rhsIntersections[index]
            return .init(isLhs: false, previous)
        }
    }
}

private extension State {
    var asTuple: (lhs: Period, lhsIndex: Int, rhs: Period, rhsIndex: Int) {
        return (lhsPeriod, lhsIndex, rhsPeriod, rhsIndex)
    }

    init(isLhs: Bool, _ tuple: (lhs: Period, lhsIndex: Int, rhs: Period, rhsIndex: Int)) {
        if isLhs {
            self = .onLhs(tuple.lhs, lhsIndex: tuple.lhsIndex, tuple.rhs, rhsIndex: tuple.rhsIndex)
        } else {
            self = .onRhs(tuple.lhs, lhsIndex: tuple.lhsIndex, tuple.rhs, rhsIndex: tuple.rhsIndex)
        }
    }
}

private extension Array {
    /// - note: Assumes `self` is already sorted according to the provided
    /// `areInIncreasingOrder`, or is empty.
    mutating func insertSorted(
        _ element: Element,
        by areInIncreasingOrder: (Element, Element) -> Bool
    ) {
        for index in startIndex..<endIndex {
            if areInIncreasingOrder(element, self[index]) {
                insert(element, at: index)
                return
            }
        }

        self.append(element)
    }
}

private extension Collection {
    /// Returns the immediately next element within `self` that is strictly greater
    /// than the element `start` by a provided sorting closure.
    ///
    /// If this element list is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    /// - note: Assumes `self` is sorted.
    func nextIndex(
        after start: Element,
        by areInIncreasingOrder: (Element, Element) -> Bool
    ) -> Index? {
        guard !isEmpty else {
            return nil
        }
        guard let index = firstIndex(where: { areInIncreasingOrder(start, $0) }) else {
            return startIndex
        }

        return index
    }
}

private extension BidirectionalCollection {
    /// Returns the immediately previous element within `self` that is strictly
    /// less than the element `start` by a provided sorting closure.
    ///
    /// If this element list is empty, `nil` is returned, instead.
    ///
    /// - note: Wraps around the list if no suitable candidate is found.
    /// - note: Assumes `self` is sorted.
    func previousIndex(
        before start: Element,
        by areInIncreasingOrder: (Element, Element) -> Bool
    ) -> Index? {
        guard !isEmpty else {
            return nil
        }
        guard let index = lastIndex(where: { areInIncreasingOrder($0, start) }) else {
            return self.index(before: endIndex)
        }

        return index
    }
}
