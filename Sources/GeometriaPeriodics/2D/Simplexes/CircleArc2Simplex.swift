import Geometria

/// A 2-dimensional simplex composed of a circular arc segment.
public struct CircleArc2Simplex<Vector: Vector2Real>: Periodic2Simplex {
    /// The circular arc segment associated with this simplex.
    public var circleArc: CircleArc2<Vector>

    public var startPeriod: Period
    public var endPeriod: Period

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

    public func compute(at period: Period) -> Vector {
        let relativePeriod = (period - startPeriod) / (endPeriod - startPeriod)

        let magnitude = circleArc.sweepAngle.radians * relativePeriod

        return circleArc.pointOnAngle(
            circleArc.startAngle + magnitude
        )
    }
}

extension CircleArc2Simplex {
    /// Converts the circular arc represented by this circular arc simplex into
    /// its full circular representation.
    @inlinable
    public var asCircle2: Circle2<Vector> {
        circleArc.asCircle2
    }

    @inlinable
    public var start: Vector { circleArc.startPoint }

    @inlinable
    public var end: Vector { circleArc.endPoint }
}
