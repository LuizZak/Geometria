/// Represents a 3D ray as a pair of double-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias Ray3D = Ray3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias Ray3F = Ray3<Vector3F>

/// Represents a 3D line as a pair of integer vectors describing where the ray
/// starts and crosses before being projected to infinity.
public typealias Ray3i = Ray3<Vector3i>

/// Typealias for `Ray<V>`, where `V` is constrained to ``Vector3Type``.
public typealias Ray3<V: Vector3Type> = Ray<V>

extension Ray3: Line3Type where Vector: VectorAdditive {
    public typealias SubLine2 = Ray2<Vector.SubVector2>
    
    /// Initializes a new Ray with two 3D vectors representing the starting
    /// point of the ray and a secondary point the ray crosses before projecting
    /// towards infinity.
    @_transparent
    public init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        start = Vector(x: x1, y: y1, z: z1)
        b = Vector(x: x2, y: y2, z: z2)
    }
    
    /// Initializes a new Ray with a 3D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    public init(x: Scalar, y: Scalar, z: Scalar, dx: Scalar, dy: Scalar, dz: Scalar) {
        start = Vector(x: x, y: y, z: z)
        b = start + Vector(x: dx, y: dy, z: dz)
    }
    
    /// Creates a 2D line of the same underlying type as this line.
    @_transparent
    public static func make2DLine(_ a: Vector.SubVector2, _ b: Vector.SubVector2) -> SubLine2 {
        SubLine2(start: a, b: b)
    }
}

extension Ray3: Line3FloatingPoint where Vector: Vector3Type & VectorFloatingPoint, Vector.SubVector2: Vector2FloatingPoint {
    
}
