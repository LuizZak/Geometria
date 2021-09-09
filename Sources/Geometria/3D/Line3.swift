/// Represents a 3D line as a pair of double-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line3D = Line3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line3F = Line3<Vector3F>

/// Represents a 3D line as a pair of integer vectors which the infinite line
/// crosses.
public typealias Line3i = Line3<Vector3i>

/// Typealias for `Line<V>`, where `V` is constrained to `Vector3Type`.
public typealias Line3<V: Vector3Type> = Line<V>

extension Line3: Line3Type {
    public typealias SubLine2 = Line2<Vector.SubVector2>
    
    @_transparent
    public init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        a = Vector(x: x1, y: y1, z: z1)
        b = Vector(x: x2, y: y2, z: z2)
    }
    
    /// Creates a 2D line of the same underlying type as this line.
    @_transparent
    public func make2DLine(_ a: Vector.SubVector2, _ b: Vector.SubVector2) -> SubLine2 {
        SubLine2(a: a, b: b)
    }
}

extension Line3: Line3FloatingPoint where Vector: Vector3Type & VectorFloatingPoint, Vector.SubVector2: Vector2FloatingPoint {
    
}
