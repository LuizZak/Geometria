import Geometria

/// Represents a contour, or a non-intersecting segment of a parametric geometry,
/// which has its own set of simplexes, and has a winding value specifying how
/// its simplexes wind in relation to its parent geometry.
public struct Parametric2Contour<Vector: Vector2Real> {
    public typealias Scalar = Vector.Scalar
    public typealias Period = Vector.Scalar

    /// The simplex type produced by this parametric geometry.
    public typealias Simplex = Parametric2GeometrySimplex<Vector>

    public var simplexes: [Simplex] {
        didSet { bounds = simplexes.bounds() }
    }

    /// The winding of this contour.
    ///
    /// Contour winding is relevant to overlapping and boolean operations, where
    /// two contours that have the same winding are additively combined, while
    /// contours of different windings are subtracted.
    ///
    /// Two contours can only occupy the same space if they are of opposite windings;
    /// this works also to nest multiple contours of alternating windings one
    /// inside the other.
    public var winding: Winding

    /// The inclusive lower bound period within this geometry.
    public var startPeriod: Period

    /// The exclusive upper bound period within this geometry. Must be greater
    /// than `startPeriod`.
    ///
    /// This value is not part of the addressable period range.
    public var endPeriod: Period

    /// Returns the bounds for this parametric contour.
    private(set) public var bounds: AABB<Vector>

    var periodRange: Period {
        endPeriod - startPeriod
    }

    /// Initializes a new compound parametric with a given list of simplexes, using
    /// the start period of the first simplex and the end period of the last
    /// simplex as the start and end periods for the geometry.
    public init(simplexes: [Simplex]) {
        self.init(
            simplexes: simplexes,
            winding: Self.computeWinding(simplexes)
        )
    }

    /// Initializes a new compound parametric with a given list of simplexes, using
    /// the start period of the first simplex and the end period of the last
    /// simplex as the start and end periods for the geometry.
    public init(simplexes: [Simplex], winding: Winding) {
        self.init(
            simplexes: simplexes,
            winding: winding,
            startPeriod: simplexes.first?.startPeriod ?? .zero,
            endPeriod: simplexes.last?.endPeriod ?? 1
        )
    }

    /// Initializes a new compound parametric with a given list of simplexes, first
    /// normalizing their period intervals so they lie in the range
    /// `(0, 1]`.
    public init(
        normalizing simplexes: [Simplex]
    ) {
        self.init(
            normalizing: simplexes,
            startPeriod: .zero,
            endPeriod: 1
        )
    }

    /// Initializes a new compound parametric with a given list of simplexes, first
    /// normalizing their period intervals so they lie in the range
    /// `(startPeriod, endPeriod]`.
    public init(
        normalizing simplexes: [Simplex],
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            simplexes: simplexes.normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            ),
            winding: Self.computeWinding(simplexes),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Initializes a new compound parametric with a given list of simplexes and
    /// a pre-defined start/end period range.
    ///
    /// - note: The period of the contained simplexes is not modified and is
    /// assumed to match the range `(startPeriod, endPeriod]`.
    public init(simplexes: [Simplex], winding: Winding, startPeriod: Period, endPeriod: Period) {
        self.simplexes = simplexes
        self.winding = winding
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
        self.bounds = simplexes.bounds()
    }

    /// Performs a point-containment check against this parametric contour.
    public func contains(_ point: Vector) -> Bool {
        // Construct a line segment that starts at the queried point and ends at
        // a point known to be outside the contour, then count the number of
        // unique point-intersections along the way; if the intersection count
        // is divisible by two, then the point is not contained within the
        // contour.

        let simplexes = allSimplexes()

        let bounds = self.bounds
        if !bounds.contains(point) {
            return false
        }

        let lineSegment = LineSegment2<Vector>(
            start: point,
            end: .init(x: bounds.right + 10, y: point.y)
        )
        let lineSimplex = Parametric2GeometrySimplex.lineSegment2(
            .init(lineSegment: lineSegment, startPeriod: .zero, endPeriod: 1)
        )

        var points: [Vector] = []
        for simplex in simplexes {
            let intersections = simplex.intersectionPeriods(with: lineSimplex)

            for intersection in intersections {
                let point = simplex.compute(at: intersection.`self`)

                if !points.contains(point) {
                    points.append(point)
                }
            }
        }

        return points.count % 2 == 1
    }

    /// Computes the point on this parametric geometry matching a given period.
    public func compute(at period: Period) -> Vector {
        let normalized = normalizedPeriod(period)

        for simplex in allSimplexes() {
            guard simplex.periodRange.contains(normalized) else {
                continue
            }

            return simplex.compute(at: normalized)
        }

        return Vector.zero
    }

    /// Performs a point-surface check against this parametric geometry, up to a
    /// given squared tolerance value.
    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        for simplex in simplexes {
            if simplex.isOnSurface(point, toleranceSquared: toleranceSquared) {
                return true
            }
        }

        return false
    }

    /// Fetches all simplexes that form this 2-dimensional parametric geometry,
    /// ordered by their relative period within the geometry.
    public func allSimplexes() -> [Simplex] {
        simplexes
    }

    /// Fetches all simplexes that overlap a given half-open range within this
    /// 2-dimensional parametric geometry, ordered by their relative period within
    /// the geometry.
    public func allSimplexes(overlapping range: Range<Period>) -> [Simplex] {
        allSimplexes().filter { simplex in
            range.overlaps(simplex.periodRange)
        }
    }

    /// Fetches all simplexes, clamped to be within a given given half-open range
    /// within this 2-dimensional parametric geometry, ordered by their relative
    /// period within the geometry.
    ///
    /// The clamping process preserves relative positioning of points within the
    /// simplexes so that computing a point based on a period results in the
    /// same point being produced as if the simplexes where not clamped, if the
    /// point is contained within `range`.
    ///
    /// If no simplex is contained within the given range, an empty array is
    /// returned, instead.
    public func clampedSimplexes(in range: Range<Period>) -> [Simplex] {
        allSimplexes().compactMap { simplex in
            simplex.clamped(in: range)
        }
    }

    /// Returns all unique intersection periods between `self` and `other`.
    /// The resulting array of periods is guaranteed to not contain the same
    /// period value twice for all `tuple.self` and for all `tuple.other`,
    /// separately.
    ///
    /// The intersections are sorted by their occurrence within `self`, and
    /// intersection pairs do not overlap with each other with respect to the
    /// `intersection.self` side of each intersection.
    ///
    /// If two intersections have a difference smaller than `tolerance`, the
    /// two intersections are elided from the result. Passing `.infinity` to
    /// `tolerance` disables this behavior.
    public func allIntersectionPeriods(
        _ other: Self,
        tolerance: Scalar
    ) -> [ParametricClip2Intersection<Period>] {

        self.allSimplexes().allIntersectionPeriods(
            with: other.allSimplexes(),
            tolerance: tolerance,
            normalizedCenterSelf: self.normalizedCenter(_:_:),
            otherContainsSelf: { other.contains(self.compute(at: $0)) },
            normalizedCenterOther: other.normalizedCenter(_:_:),
            selfContainsOther: { self.contains(other.compute(at: $0)) }
        )
    }

    /// Returns the reverse of this parametric geometry by inverting the order
    /// and direction of each of its simplexes, while maintaining `self.startPeriod`
    /// and `self.endPeriod`.
    public func reversed() -> Self {
        let simplexes = self.simplexes
            .map({ $0.reversed() })
            .reversed()

        return .init(
            normalizing: Array(simplexes),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    public enum Winding {
        case clockwise
        case counterClockwise
    }
}

extension Parametric2Contour {
    func normalizedPeriod(_ period: Period) -> Period {
        if period >= startPeriod && period < endPeriod {
            return period
        }

        return startPeriod + period.truncatingRemainder(dividingBy: periodRange)
    }

    /// Returns the mid-period between two input periods within this parametric
    /// geometry.
    func normalizedCenter(_ left: Period, _ right: Period) -> Period {
        if left > right {
            // Handle the case the range is actually:
            // ↪|------right     left--|↩
            //
            // By wrapping the 'right' element at the end of 'left', and
            // then normalizing:
            //  |                left--|------right
            //  |                      | .          ! before normalization
            //  | .                    | < result   ✓ after normalization
            return normalizedPeriod(
                ((endPeriod - left) + right) / 2
            )
        } else {
            // Handle the more regular case:
            //  |   left-------right   |
            //  |          .           | < result
            return normalizedPeriod((left + right) / 2)
        }
    }

    /// Returns `true` if the given periods have a precedence of `lhs < rhs`.
    ///
    /// Periods are first normalized to be within `startPeriod` and `endPeriod`
    /// before the comparison.
    public func periodPrecedes(
        _ lhs: Period,
        _ rhs: Period
    ) -> Bool {
        let lhsNormalized = normalizedPeriod(lhs)
        let rhsNormalized = normalizedPeriod(rhs)

        return lhsNormalized < rhsNormalized
    }

    /// Returns `true` if the given periods have a precedence of `start < lhs < rhs`.
    ///
    /// Periods are first normalized to be within `startPeriod` and `endPeriod`
    /// before the comparison.
    public func periodPrecedes(
        from start: Period,
        _ lhs: Period,
        _ rhs: Period
    ) -> Bool {
        let startNormalized = normalizedPeriod(start)
        let lhsNormalized = normalizedPeriod(lhs)
        let rhsNormalized = normalizedPeriod(rhs)

        return startNormalized < lhsNormalized && lhsNormalized < rhsNormalized
    }
}

extension Collection {
    /// Renormalizes the contours within this collection such that the periods
    /// of the contours have a given start/end period range.
    @inlinable
    func normalized<Vector>(
        startPeriod: Vector.Scalar,
        endPeriod: Vector.Scalar
    ) -> [Element] where Element == Parametric2Contour<Vector> {
        return map {
            .init(normalizing: $0.allSimplexes(),
            startPeriod: startPeriod,
            endPeriod: endPeriod)
        }
    }
}

private extension Parametric2Contour {
    static func computeWinding(_ simplexes: [Simplex]) -> Winding {
        //.clockwise
        let points = simplexes.map(\.start)
        let polygon = LinePolygon2(vertices: points)
        let polygonWinding = polygon.winding()

        if polygonWinding < 0 {
            return .counterClockwise
        } else {
            return .clockwise
        }
    }
}
