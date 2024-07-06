import Geometria

/// A 2-dimensional simplex composed of a line segment.
public struct LineSegment2Simplex<Vector: Vector2FloatingPoint>: Periodic2Simplex {
    /// The line segment associated with this simplex.
    public var lineSegment: LineSegment2<Vector>

    public var startPeriod: Period
    public var endPeriod: Period

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

    public func compute(at period: Period) -> Vector {
        let relativePeriod = (period - startPeriod) / (endPeriod - startPeriod)

        return lineSegment.projectedNormalizedMagnitude(relativePeriod)
    }
}

extension LineSegment2Simplex {
    @inlinable
    public var start: Vector { lineSegment.start }

    @inlinable
    public var end: Vector { lineSegment.end }
}
