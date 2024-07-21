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
    func ratioForPeriod(_ period: Period) -> Period {
        (period - startPeriod) / (endPeriod - startPeriod)
    }

    /// Returns `startPeriod + (endPeriod - startPeriod) * ratio`.
    ///
    /// - note: The result is unclamped.
    func period(onRatio ratio: Period) -> Period {
        startPeriod + (endPeriod - startPeriod) * ratio
    }

    public func compute(at period: Period) -> Vector {
        let ratio = ratioForPeriod(period)

        return lineSegment.projectedNormalizedMagnitude(ratio)
    }

    public func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool {
        lineSegment.distanceSquared(to: vector) < toleranceSquared
    }

    /// Clamps this simplex so its contained geometry is only present within a
    /// given period range.
    ///
    /// If the geometry is not available on the given range, `nil` is returned,
    /// instead.
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

    public func reversed() -> Self {
        return .init(
            lineSegment: .init(start: lineSegment.end, end: lineSegment.start),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }
}
