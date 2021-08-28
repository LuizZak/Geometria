/// Represents a 3D ray as a pair of double-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3D = DirectionalRay3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3F = DirectionalRay3<Vector3F>

/// Typealias for `DirectionalRay3<V>`, where `V` is constrained to
/// `Vector3Type & VectorNormalizable`.
public typealias DirectionalRay3<V: Vector3Type & VectorFloatingPoint> = DirectionalRay<V>

public extension DirectionalRay3 {
    /// Initializes a new Ray with a 3D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    init(x: Scalar, y: Scalar, z: Scalar, dx: Scalar, dy: Scalar, dz: Scalar) {
        self.init(start: Vector(x: x, y: y, z: z),
                  direction: Vector(x: dx, y: dy, z: dz))
    }
}
