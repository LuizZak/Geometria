import Geometria
import Numerics

/// Represents a contour, or a non-intersecting segment of a parametric geometry,
/// which has its own set of simplexes, and has a winding value specifying how
/// its simplexes wind in relation to its parent geometry.
public struct Parametric2Contour<Vector: Vector2Real>: BoundableType, CustomStringConvertible {
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

    @inlinable
    var periodRange: Period {
        endPeriod - startPeriod
    }

    public var description: String {
        "\(type(of: self))(simplexes: \(simplexes), winding: \(winding), startPeriod: \(startPeriod), endPeriod: \(endPeriod))"
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
    public init(
        simplexes: [Simplex],
        winding: Winding,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.simplexes = simplexes
        self.winding = winding
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
        self.bounds = simplexes.bounds()
    }

    /// Performs a point-containment check against this parametric contour.
    @inlinable
    public func contains(_ point: Vector) -> Bool {
        // Construct a line segment that starts at the queried point and ends at
        // a point known to be outside the contour, then count the number of
        // unique point-intersections along the way; if the intersection count
        // is divisible by two, then the point is not contained within the
        // contour.

        let bounds = self.bounds
        if !bounds.contains(point) {
            return false
        }

        var intersections = 0
        for simplex in allSimplexes() {
            if simplex.intersectsHorizontalLine(start: point, tolerance: .exp10(-13)) {
                intersections += 1
            }
        }

        return intersections % 2 == 1
    }

    /// Computes the point on this parametric geometry matching a given period.
    @inlinable
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

    /// Performs a point-point check against this parametric geometry, up to a
    /// given squared tolerance value.
    @inlinable
    public func isOnVertex(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        for simplex in simplexes {
            if simplex.start.distanceSquared(to: point) <= toleranceSquared {
                return true
            }
            if simplex.end.distanceSquared(to: point) <= toleranceSquared {
                return true
            }
        }

        return false
    }

    /// Performs a point-surface check against this parametric geometry, up to a
    /// given squared tolerance value.
    @inlinable
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
    @inlinable
    public func allSimplexes() -> [Simplex] {
        simplexes
    }

    /// Fetches all simplexes that overlap a given half-open range within this
    /// 2-dimensional parametric geometry, ordered by their relative period within
    /// the geometry.
    @inlinable
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
    @inlinable
    public func clampedSimplexes(in range: Range<Period>) -> [Simplex] {
        allSimplexes().compactMap { simplex in
            simplex.clamped(in: range)
        }
    }

    /// Returns the reverse of this parametric geometry by inverting the order
    /// and direction of each of its simplexes, while maintaining `self.startPeriod`
    /// and `self.endPeriod`.
    @inlinable
    public func reversed() -> Self {
        let simplexes = self.simplexes
            .map({ $0.reversed(globalStartPeriod: startPeriod, globalEndPeriod: endPeriod) })
            .reversed()

        return .init(
            simplexes: Array(simplexes),
            winding: winding.inverse,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Splits this contour at a period, ensuring that a simplex split happens
    /// at that period.
    ///
    /// If the given period is the start of a period, +/- tolerance, no change
    /// is made.
    @inlinable
    public mutating func split(at period: Period, tolerance: Scalar) {
        let period = normalizedPeriod(period)

        guard let simplexIndex = simplexes.firstIndex(where: { $0.periodRange.contains(period) }) else {
            return
        }

        let simplex = simplexes[simplexIndex]
        if period.isApproximatelyEqualFast(to: simplex.startPeriod, tolerance: tolerance) || period.isApproximatelyEqualFast(to: simplex.endPeriod, tolerance: tolerance) {
            return
        }

        let (left, right) = simplex.split(at: period)

        simplexes[simplexIndex...simplexIndex] = [left, right]
    }

    public enum Winding {
        case clockwise
        case counterClockwise

        /// Returns the inverse winding value of `self`.
        public var inverse: Self {
            switch self {
            case .clockwise:
                return .counterClockwise

            case .counterClockwise:
                return .clockwise
            }
        }

        /// A numerical value associated with this winding.
        ///
        /// Clockwise windings have value `1`, and counter-clockwise `-1`.
        public var value: Int {
            switch self {
            case .clockwise:
                return 1

            case .counterClockwise:
                return -1
            }
        }
    }
}

extension Parametric2Contour {
    @inlinable
    func normalizedPeriod(_ period: Period) -> Period {
        if period >= startPeriod && period < endPeriod {
            return period
        }

        return startPeriod + period.truncatingRemainder(dividingBy: periodRange)
    }

    /// Returns the mid-period between two input periods within this parametric
    /// geometry.
    @inlinable
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
    @inlinable
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
    @inlinable
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
            .init(
                normalizing: $0.allSimplexes(),
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
        }
    }
}

private extension Parametric2Contour {
    static func computeWinding(_ simplexes: [Simplex]) -> Winding {
        // Compute a polygon out of each simplex, and use that to compute the
        // winding number
        var points: [Vector] = []

        for simplex in simplexes {
            switch simplex {
            case .lineSegment2(let simplex):
                points.append(simplex.start)

            case .circleArc2(let simplex):
                let arc = simplex.circleArc

                points.append(simplex.start)

                // For low-simplex count contours, ensure that the low count of
                // vertices due to usage of circular arcs doesn't lead to an
                // incorrect winding number
                //
                // It is simply enough to compute some extra points along the
                // arc, respecting the sign of its sweep angle
                if simplexes.count < 2 {
                    points.append(arc.pointOnAngle(arc.startAngle + arc.sweepAngle / 4))
                }
                if simplexes.count < 3 {
                    points.append(arc.pointOnAngle(arc.startAngle + arc.sweepAngle / 2))
                }
            }
        }

        let polygon = LinePolygon2(vertices: points)
        let polygonWinding = polygon.winding()

        if polygonWinding < 0 {
            return .counterClockwise
        } else {
            return .clockwise
        }
    }
}
