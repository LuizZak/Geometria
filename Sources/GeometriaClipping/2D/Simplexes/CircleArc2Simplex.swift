import Geometria
import Numerics

/// A 2-dimensional simplex composed of a circular arc segment.
public struct CircleArc2Simplex<Vector: Vector2Real>: Parametric2Simplex, Equatable {
    public typealias Scalar = Vector.Scalar

    /// The circular arc segment associated with this simplex.
    public var circleArc: CircleArc2<Vector>

    public var startPeriod: Period
    public var endPeriod: Period

    /// Convenience for `circleArc.center`.
    @inlinable
    public var center: Vector {
        get { circleArc.center }
        set { circleArc.center = newValue }
    }

    /// Convenience for `circleArc.radius`.
    @inlinable
    public var radius: Scalar {
        get { circleArc.radius }
        set { circleArc.radius = newValue }
    }

    /// Convenience for `circleArc.startAngle`.
    @inlinable
    public var startAngle: Angle<Scalar> {
        get { circleArc.startAngle }
        set { circleArc.startAngle = newValue }
    }

    /// Convenience for `circleArc.sweepAngle`.
    @inlinable
    public var sweepAngle: Angle<Scalar> {
        get { circleArc.sweepAngle }
        set { circleArc.sweepAngle = newValue }
    }

    /// Convenience for `circleArc.stopAngle`.
    @inlinable
    public var stopAngle: Angle<Scalar> {
        get { circleArc.stopAngle }
    }

    /// Converts the circular arc represented by this circular arc simplex into
    /// its full circular representation.
    @inlinable
    public var asCircle2: Circle2<Vector> {
        circleArc.asCircle2
    }

    @inlinable
    var lengthSquared: Scalar {
        circleArc.arcLength * circleArc.arcLength
    }

    @inlinable
    public var start: Vector { circleArc.startPoint }

    @inlinable
    public var end: Vector { circleArc.endPoint }

    @inlinable
    public var bounds: AABB2<Vector> {
        circleArc.bounds()
    }

    /// Initializes a new circular arc segment simplex value with a given circular
    /// arc segment's parameters.
    public init(
        center: Vector,
        radius: Scalar,
        startAngle: Angle<Scalar>,
        sweepAngle: Angle<Scalar>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            circleArc: .init(
                center: center,
                radius: radius,
                startAngle: startAngle,
                sweepAngle: sweepAngle
            ),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Initializes a new circular arc segment simplex value with a given circular
    /// arc segment.
    public init(
        circleArc: CircleArc2<Vector>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.circleArc = circleArc
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

        let magnitude = circleArc.sweepAngle.radians * ratio

        return circleArc.pointOnAngle(
            circleArc.startAngle + magnitude
        )
    }

    @inlinable
    public func intersectsHorizontalLine(start point: Vector, tolerance: Scalar) -> Bool {
        if self.start.y < self.end.y {
            //  •-s-->
            //     (
            //      e
            if self.start.x > point.x && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //   s
            //    (
            //  •--e->
            if self.end.x > point.x && self.end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        } else if self.start.y > end.y {
            //  •--e->
            //    (
            //   s
            if self.end.x > point.x && self.end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //      e
            //     (
            //  •-s--->
            if self.start.x > point.x && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        } else if
            self.start.y.isApproximatelyEqualFast(to: self.end.y, tolerance: tolerance)
            && self.start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance)
        {
            // s--•--e->
            if self.start.x < point.x && self.end.x > point.x {
                return true
            }
        }

        let ray = Ray2(start: point, b: point + .init(x: 1, y: 0))
        let hasIntersections = circleArc.intersections(with: ray).intersections.count % 2 == 1
        return hasIntersections
    }

    @inlinable
    public func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool {
        circleArc.distanceSquared(to: vector) < toleranceSquared
    }

    @inlinable
    public func closestPeriod(to vector: Vector) -> Period {
        let angle = center.angle(to: vector)
        let angleSweep = circleArc.asAngleSweep
        let clampedAngle = angleSweep.clamped(angle)

        let ratio = angleSweep.ratioOfAngle(clampedAngle)

        return startPeriod + ratio * (endPeriod - startPeriod)
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
            circleArc: .init(
                center: circleArc.center,
                radius: circleArc.radius,
                startAngle: circleArc.startAngle + circleArc.sweepAngle * ratioStart,
                sweepAngle: circleArc.sweepAngle * (ratioEnd - ratioStart)
            ),
            startPeriod: max(startPeriod, range.lowerBound),
            endPeriod: min(endPeriod, range.upperBound)
        )
    }

    @inlinable
    public func reversed() -> Self {
        return .init(
            circleArc: .init(
                center: circleArc.center,
                radius: circleArc.radius,
                startAngle: circleArc.stopAngle,
                sweepAngle: -circleArc.sweepAngle
            ),
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

        let midAngle = startAngle + sweepAngle * ratio

        return (
            .init(
                center: center,
                radius: radius,
                startAngle: startAngle,
                sweepAngle: sweepAngle * ratio,
                startPeriod: startPeriod,
                endPeriod: period
            ),
            .init(
                center: center,
                radius: radius,
                startAngle: midAngle,
                sweepAngle: sweepAngle * (1 - ratio),
                startPeriod: period,
                endPeriod: endPeriod
            )
        )
    }
}
