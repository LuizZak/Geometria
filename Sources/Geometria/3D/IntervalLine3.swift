/// Represents a 3D interval line as a point of double-precision floating-point
/// vector, a normalized direction vector, and a minimum/maximum span of the
/// line as scalars.
public typealias IntervalLine3D = IntervalLine3<Vector3D>

/// Represents a 3D interval line as a point of single-precision floating-point
/// vector, a normalized direction vector, and a minimum/maximum span of the
/// line as scalars.
public typealias IntervalLine3F = IntervalLine3<Vector3F>

/// Typealias for `IntervalLine<V>`, where `V` is constrained to ``Vector3FloatingPoint``.
public typealias IntervalLine3<V: Vector3FloatingPoint> = IntervalLine<V>

extension IntervalLine3: Line3Type {
    public typealias SubLine2 = IntervalLine2<Vector.SubVector2>
    
    @_transparent
    public init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        self.init(
            start: .init(x: x1, y: y1, z: z1),
            end: .init(x: x2, y: y2, z: z2)
        )
    }
    
    /// Creates a 2D line of the same underlying type as this line.
    @_transparent
    public func make2DLine(_ a: Vector.SubVector2, _ b: Vector.SubVector2) -> SubLine2 {
        SubLine2(start: a, end: b)
    }
}

extension IntervalLine3: Line3FloatingPoint where Vector: Vector3Type & VectorFloatingPoint, Vector.SubVector2: Vector2FloatingPoint {
    
}
