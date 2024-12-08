import Geometria

/// A 2-dimensional simplex composed of a line segment.
public struct LineSegment2Simplex<Vector: Vector2FloatingPoint>: Parametric2Simplex, Equatable {
    public typealias Scalar = Vector.Scalar

    /// The line segment associated with this simplex.
    public var lineSegment: LineSegment2<Vector>

    public var startPeriod: Period
    public var endPeriod: Period

    /// Convenience for `lineSegment.start`.
    @inlinable
    public var start: Vector {
        get { lineSegment.start }
        set { lineSegment.start = newValue }
    }

    /// Convenience for `lineSegment.end`.
    @inlinable
    public var end: Vector {
        get { lineSegment.end }
        set { lineSegment.end = newValue }
    }

    @inlinable
    var lengthSquared: Vector.Scalar {
        lineSegment.lengthSquared
    }

    @inlinable
    public var bounds: AABB2<Vector> {
        lineSegment.bounds
    }

    /// Initializes a new line segment simplex value with a line segment that spans
    /// the given start/end points.
    public init(
        start: Vector,
        end: Vector,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            lineSegment: .init(
                start: start,
                end: end
            ),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Initializes a new line segment simplex value with a given line segment.
    public init(
        lineSegment: LineSegment2<Vector>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.lineSegment = lineSegment
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    /// Returns `(period - startPeriod) / (endPeriod - startPeriod)`.
    ///
    /// - note: The result is unclamped.
    @inlinable
    func ratioForPeriod(_ period: Period) -> Period {
        (period - startPeriod) / (endPeriod - startPeriod)
    }

    /// Returns `startPeriod + (endPeriod - startPeriod) * ratio`.
    ///
    /// - note: The result is unclamped.
    @inlinable
    func period(onRatio ratio: Period) -> Period {
        startPeriod + (endPeriod - startPeriod) * ratio
    }

    @inlinable
    public func compute(at period: Period) -> Vector {
        let ratio = ratioForPeriod(period)

        return lineSegment.projectedNormalizedMagnitude(ratio)
    }

    @inlinable
    public func intersectsHorizontalLine(start point: Vector, tolerance: Scalar) -> Bool {
        if
            self.start.y.isApproximatelyEqualFast(to: self.end.y, tolerance: tolerance)
            && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance)
        {
            // s--•--e->
            if self.start.x < point.x && self.end.x > point.x {
                return true
            }
            // •--s---e-> or •--e---s->
            if self.start.x > point.x && self.end.x > point.x {
                return false
            }
        } else if self.start.y < self.end.y {
            //  •-s-->
            //     \
            //      e
            if self.start.x > point.x && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //   s
            //    \
            //  •--e->
            if self.end.x > point.x && self.end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        } else if self.start.y > end.y {
            //  •--e->
            //    /
            //   s
            if self.end.x > point.x && self.end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //      e
            //     /
            //  •-s--->
            if self.start.x > point.x && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        }

        let ray = Ray2(start: point, b: point + .init(x: 1, y: 0))
        return lineSegment.intersection(with: ray) != nil
    }

    @inlinable
    public func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool {
        lineSegment.distanceSquared(to: vector) < toleranceSquared
    }

    @inlinable
    public func closestPeriod(to vector: Vector) -> (Period, distanceSquared: Scalar) {
        let scalar = lineSegment.projectAsScalar(vector)
        let clamped = lineSegment.clampProjectedNormalizedMagnitude(scalar)
        let projected = lineSegment.projectedNormalizedMagnitude(clamped)

        let period = startPeriod + clamped * (endPeriod - startPeriod)

        return (period, projected.distanceSquared(to: vector))
    }

    /// Returns the period at which the x component of the coordinate system is
    /// the smallest within this simplex.
    @inlinable
    public func leftmostPeriod() -> Period {
        if start.x == end.y {
            return start.y < end.y ? endPeriod : startPeriod
        }

        return start.x < end.y ? startPeriod : endPeriod
    }

    /// Clamps this simplex so its contained geometry is only present within a
    /// given period range.
    ///
    /// If the geometry is not available on the given range, `nil` is returned,
    /// instead.
    @inlinable
    public func clamped(in range: Range<Period>) -> Self? {
        if startPeriod >= range.upperBound || endPeriod <= range.lowerBound {
            return nil
        }

        let ratioStart = max(ratioForPeriod(range.lowerBound), .zero)
        let ratioEnd = min(ratioForPeriod(range.upperBound), 1)

        return .init(
            lineSegment: .init(
                start: lineSegment.projectedNormalizedMagnitude(ratioStart),
                end: lineSegment.projectedNormalizedMagnitude(ratioEnd)
            ),
            startPeriod: max(startPeriod, range.lowerBound),
            endPeriod: min(endPeriod, range.upperBound)
        )
    }

    @inlinable
    public func reversed() -> Self {
        return .init(
            lineSegment: .init(start: lineSegment.end, end: lineSegment.start),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Splits this simplex at a given period, returning two simplexes that join
    /// to form the same range of periods/strokes that this simplex spans.
    ///
    /// - precondition: `period` is a valid period contained within `startPeriod..<endPeriod`.
    @inlinable
    public func split(at period: Period) -> (Self, Self) {
        precondition(periodRange.contains(period))
        let ratio = ratioForPeriod(period)

        let midPoint = lineSegment.projectedNormalizedMagnitude(ratio)

        return (
            .init(
                start: lineSegment.start,
                end: midPoint,
                startPeriod: startPeriod,
                endPeriod: period
            ),
            .init(
                start: midPoint,
                end: lineSegment.end,
                startPeriod: period,
                endPeriod: endPeriod
            )
        )
    }

    @inlinable
    public func coincidenceRelationship(with other: Self, tolerance: Scalar) -> SimplexCoincidenceRelationship<Period> {
        if other == self {
            return .sameSpan
        }

        func areClose(_ v1: Vector, _ v2: Vector) -> Bool {
            let diff = (v1 - v2)

            return diff.absolute.maximalComponent.magnitude < tolerance
        }

        let lhsStartCoincident: Bool
        let lhsEndCoincident: Bool

        var lhsStart: Scalar
        var lhsEnd: Scalar
        var rhsStart: Scalar
        var rhsEnd: Scalar

        let lhsContains: (_ scalar: Scalar) -> Bool
        let rhsContains: (_ scalar: Scalar) -> Bool
        let lhsPeriod: (_ scalar: Scalar) -> Period
        let rhsPeriod: (_ scalar: Scalar) -> Period

        let lhsLine = LineSegment2(start: self.start, end: self.end)
        let rhsLine = LineSegment2(start: other.start, end: other.end)

        // lhs:  •----•
        // rhs:  •----•
        lhsStartCoincident = areClose(lhsLine.start, rhsLine.start) || areClose(lhsLine.start, rhsLine.end)
        lhsEndCoincident = areClose(lhsLine.end, rhsLine.start) || areClose(lhsLine.end, rhsLine.end)

        if
            lhsStartCoincident && lhsEndCoincident
        {
            return .sameSpan
        }

        if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
            lhsStart = rhsLine.projectAsScalar(lhsLine.start)
            lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
            rhsStart = lhsLine.projectAsScalar(rhsLine.start)
            rhsEnd = lhsLine.projectAsScalar(rhsLine.end)

            lhsContains = { scalar in
                lhsLine.containsProjectedNormalizedMagnitude(scalar)
            }
            rhsContains = { scalar in
                rhsLine.containsProjectedNormalizedMagnitude(scalar)
            }

            // Ensure start < end so checks are easier to make
            if lhsStart > lhsEnd {
                swap(&lhsStart, &lhsEnd)
            }
            if rhsStart > rhsEnd {
                swap(&rhsStart, &rhsEnd)
            }
        } else {
            return .notCoincident
        }

        lhsPeriod = { scalar in
            self.startPeriod + (self.endPeriod - self.startPeriod) * scalar
        }
        rhsPeriod = { scalar in
            other.startPeriod + (other.endPeriod - other.startPeriod) * scalar
        }

        // lhs:  •------•
        // rhs:   •----•
        if lhsContains(rhsStart) && lhsContains(rhsEnd) {
            return .lhsContainsRhs(
                lhsStart: lhsPeriod(rhsStart), lhsEnd: lhsPeriod(rhsEnd)
            )
        }

        // lhs:   •----•
        // rhs:  •------•
        if rhsContains(lhsStart) && rhsContains(lhsEnd) {
            return .rhsContainsLhs(
                rhsStart: rhsPeriod(lhsStart), rhsEnd: rhsPeriod(lhsEnd)
            )
        }

        // lhs:  •----•
        // rhs:    •----•
        if lhsContains(rhsStart) && rhsContains(lhsEnd) {
            return .rhsContainsLhsEnd(
                lhsEnd: lhsPeriod(rhsStart), rhsStart: rhsPeriod(lhsEnd)
            )
        }

        // lhs:    •----•
        // rhs:  •----•
        if rhsContains(lhsStart) && lhsContains(rhsEnd) {
            return .rhsContainsLhsStart(
                rhsStart: rhsPeriod(lhsStart), lhsEnd: lhsPeriod(rhsEnd)
            )
        }

        // lhs:  •------•
        // rhs:  •----•
        if lhsStartCoincident && lhsContains(rhsEnd) {
            return .rhsPrefixesLhs(
                lhsEnd: lhsPeriod(rhsEnd)
            )
        }

        // lhs:  •----•
        // rhs:  •------•
        if lhsStartCoincident && rhsContains(lhsEnd) {
            return .lhsPrefixesRhs(
                rhsEnd: rhsPeriod(lhsEnd)
            )
        }

        // lhs:  •------•
        // rhs:    •----•
        if lhsEndCoincident && lhsContains(rhsStart) {
            return .rhsSuffixesLhs(
                lhsStart: lhsPeriod(rhsStart)
            )
        }

        // lhs:    •----•
        // rhs:  •------•
        if lhsEndCoincident && rhsContains(lhsEnd) {
            return .lhsSuffixesRhs(
                rhsStart: rhsPeriod(lhsEnd)
            )
        }

        return .notCoincident
    }
}
