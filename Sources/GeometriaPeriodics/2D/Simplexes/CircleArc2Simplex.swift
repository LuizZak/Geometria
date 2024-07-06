import Geometria

/// A 2-dimensional simplex composed of a circular arc segment.
public struct CircleArc2Simplex<Period: PeriodType, Vector: Vector2Real>: Periodic2Simplex {
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
}

extension CircleArc2Simplex {
    @inlinable
    public var start: Vector { circleArc.startPoint }

    @inlinable
    public var end: Vector { circleArc.endPoint }
}
