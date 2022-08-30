/// Represents an N-dimensional [geometric ray] line which has a starting point
/// and crosses a secondary point before projecting to infinity.
///
/// [geometric ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
public struct Ray<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The starting position of this ray
    public var start: Vector
    
    /// A secondary point a line tracing from `start` passes through before
    /// being projected to infinity in a straight line.
    public var b: Vector

    @inlinable
    public var category: LineCategory { .ray }
    
    @_transparent
    public init(start: Vector, b: Vector) {
        self.start = start
        self.b = b
    }
}

extension Ray: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ray: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ray: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ray: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Ray {
    /// Returns a `Line` representation of this ray, where `line.a` matches
    /// `self.start` and `line.b` matches `self.b`.
    @_transparent
    var asLine: Line<Vector> {
        Line(a: start, b: b)
    }
}

extension Ray: LineType {
    @_transparent
    public var a: Vector {
        start
    }
}

extension Ray: LineAdditive where Vector: VectorAdditive {
    @_transparent
    public func offsetBy(_ vector: Vector) -> Self {
        Self(start: start + vector, b: b + vector)
    }
}

extension Ray: LineMultiplicative where Vector: VectorMultiplicative {
    @_transparent
    public func withPointsScaledBy(_ factor: Vector) -> Self {
        Self(start: start * factor, b: b * factor)
    }
    
    @_transparent
    public func withPointsScaledBy(_ factor: Vector, around center: Vector) -> Self {
        let newStart: Vector = (start - center) * factor + center
        let newB: Vector = (b - center) * factor + center
        
        return Self(start: newStart, b: newB)
    }
}

extension Ray: LineDivisible where Vector: VectorDivisible {
    
}

extension Ray: LineFloatingPoint & PointProjectableType & SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    /// Returns a `DirectionalRay` representation of this ray, where `ray.start`
    /// matches `self.start` and `ray.direction` matches
    /// `(self.b - self.start).normalized()`.
    ///
    /// - precondition: `(self.b - self.start).length > 0`
    @_transparent
    public var asDirectionalRay: DirectionalRay<Vector> {
        DirectionalRay(start: start, direction: b - start)
    }

    /// Returns a ``IntervalLine`` representation of this ray, where the
    /// result's ``IntervalLine/a`` matches ``a`` and ``IntervalLine/b`` matches
    /// ``b``, with minimum and maximum magnitudes matching
    /// (`Scalar.zero` - `+Scalar.infinity`)
    ///
    /// - precondition: `(self.b - self.start).length > 0`
    @_transparent
    public var asIntervalLine: IntervalLine<Vector> {
        IntervalLine(
            pointOnLine: start,
            direction: b - start,
            minimumMagnitude: .zero,
            maximumMagnitude: .infinity
        )
    }
    
    /// Returns `true` for all positive projected scalars (ray)
    @_transparent
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        scalar >= 0
    }
    
    /// Returns a projected normalized magnitude that is guaranteed to be
    /// contained in this line.
    ///
    /// For ``Ray``, this is a clamped inclusive (0-∞ range.
    @_transparent
    public func clampProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector.Scalar {
        max(0, scalar)
    }

    @inlinable
    public func clampedAsIntervalLine(
        minimumNormalizedMagnitude minimum: Magnitude,
        maximumNormalizedMagnitude maximum: Magnitude
    ) -> IntervalLine<Vector> {
        
        switch (minimum.isFinite, maximum.isFinite) {
        case (false, false):
            return asIntervalLine

        case (true, true), (true, false), (false, true):
            let clampedStart = clampProjectedNormalizedMagnitude(minimum)
            let clampedEnd = clampProjectedNormalizedMagnitude(maximum)

            return IntervalLine(
                pointOnLine: a,
                direction: normalizedLineSlope,
                minimumMagnitude: clampedStart,
                maximumMagnitude: clampedEnd
            )
        }
    }
}

extension Ray: LineReal where Vector: VectorReal {
    
}
