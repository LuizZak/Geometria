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
        let start = self.start
        let end = self.end

        if
            start.y.isApproximatelyEqualFast(to: end.y, tolerance: tolerance)
            && start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance)
        {
            // s  •--e->
            if start.x < point.x && end.x > point.x {
                let center = self.compute(at: (self.startPeriod + self.endPeriod) / 2)

                // s  •--e->  and  s----c-•--e->
                //  \_c_/
                if center.y >= start.y {
                    return true
                }
                //   _c_
                //  /   \
                // s  •--e->
                if center.y < start.y {
                    return false
                }
            }
            // e  •--s->
            if start.x > point.x {
                let center = self.compute(at: (self.startPeriod + self.endPeriod) / 2)

                // e  •--s->  and  e----c-•--s->
                //  \_c_/
                if center.y >= start.y {
                    return true
                }
                //   _c_
                //  /   \
                // e  •--s->
                if center.y < start.y {
                    return false
                }
            }
        } else if start.y < end.y {
            //  •-s-->
            //     (
            //      e
            if start.x > point.x && start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //   s
            //    (
            //  •--e->
            if end.x > point.x && end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        } else if start.y > end.y {
            //  •--e->
            //    (
            //   s
            if end.x > point.x && end.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return true
            }

            //      e
            //     (
            //  •-s--->
            if start.x > point.x && start.y.isApproximatelyEqualFast(to: point.y, tolerance: tolerance) {
                return false
            }
        }

        let ray = Ray2(start: point, b: point + .init(x: 1, y: 0))

        switch circleArc.intersection(with: ray) {
        case .singlePoint:
            return true
        case .twoPoint, .noIntersection:
            return false
        }
    }

    @inlinable
    public func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool {
        circleArc.distanceSquared(to: vector) < toleranceSquared
    }

    @inlinable
    public func closestPeriod(to vector: Vector) -> (Period, distanceSquared: Scalar) {
        let projected = circleArc.project(vector)
        let angle = center.angle(to: projected)
        let angleSweep = circleArc.asAngleSweep

        let ratio = angleSweep.ratioOfAngle(angle)

        let period = startPeriod + ratio * (endPeriod - startPeriod)

        return (period, projected.distanceSquared(to: vector))
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

extension CircleArc2Simplex {
    /// Returns an array of `CircleArc2Simplex` instances that span the given arc
    /// with a given period, with the least number of arcs that are have a sweep
    /// angle of at most `maxAbsoluteSweepAngle`.
    public static func splittingArcSegments(
        _ arc: CircleArc2<Vector>,
        startPeriod: Period,
        endPeriod: Period,
        maxAbsoluteSweepAngle: Scalar
    ) -> [Self] {
        var result: [Self] = []

        let startAngle = arc.sweepAngle.radians
        var totalAngle: Scalar = .zero

        let sign: Scalar = startAngle > .zero ? 1 : -1

        var remaining = startAngle.magnitude
        let step = maxAbsoluteSweepAngle.magnitude

        let periodRange = endPeriod - startPeriod

        while remaining > .zero {
            defer { remaining -= step }

            let sweep: Scalar
            if remaining < step {
                sweep = remaining * sign
            } else {
                sweep = step * sign
            }

            defer { totalAngle += sweep }

            let sPeriod: Period = startPeriod + periodRange * (totalAngle / startAngle)
            let ePeriod: Period = startPeriod + periodRange * ((totalAngle + sweep) / startAngle)

            let simplex = Self(
                center: arc.center,
                radius: arc.radius,
                startAngle: .init(radians: arc.startAngle.radians + totalAngle),
                sweepAngle: .init(radians: sweep),
                startPeriod: sPeriod,
                endPeriod: ePeriod
            )

            result.append(simplex)
        }

        return result
    }
}
