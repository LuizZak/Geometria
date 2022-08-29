/// Represents a 2D interval line as a point of double-precision floating-point
/// vector, a normalized direction vector, and a minimum/maximum span of the
/// line as scalars.
public typealias IntervalLine2D = IntervalLine2<Vector2D>

/// Represents a 2D interval line as a point of single-precision floating-point
/// vector, a normalized direction vector, and a minimum/maximum span of the
/// line as scalars.
public typealias IntervalLine2F = IntervalLine2<Vector2F>

/// Typealias for `IntervalLine<V>`, where `V` is constrained to ``Vector2FloatingPoint``.
public typealias IntervalLine2<V: Vector2FloatingPoint> = IntervalLine<V>

extension IntervalLine2: Line2Type {
    @_transparent
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        self.init(
            start: .init(x: x1, y: y1),
            end: .init(x: x2, y: y2)
        )
    }
}

extension IntervalLine2: Line2FloatingPoint where Vector: Vector2FloatingPoint {
    
}

extension IntervalLine2: Line2Real where Vector: Vector2Real {
    
}
