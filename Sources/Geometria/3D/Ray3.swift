/// Represents a 3D ray as a pair of double-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity.
public typealias Ray3D = Ray<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity
public typealias Ray3F = Ray<Vector3F>

/// Represents a 3D line as a pair of integer vectors where the ray starts and
/// crosses before being projected to infinity
public typealias Ray3i = Ray<Vector3i>

public extension Ray where Vector: Vector3Type & VectorAdditive {
    /// Initializes a new Ray with a 3D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    init(x: Scalar, y: Scalar, z: Scalar, dx: Scalar, dy: Scalar, dz: Scalar) {
        start = Vector(x: x, y: y, z: z)
        b = start + Vector(x: dx, y: dy, z: dz)
    }
}
