/// Represents a 3D ray as a pair of double-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3D = DirectionalRay3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3F = DirectionalRay3<Vector3F>

/// Typealias for `DirectionalRay3<V>`, where `V` is constrained to
/// `Vector3Type & VectorFloatingPoint`.
public typealias DirectionalRay3<V: Vector3Type & VectorFloatingPoint> = DirectionalRay<V>

public extension DirectionalRay3 {
    /// Initializes a new Directional Ray with 3D vectors describing the start
    /// and secondary point the ray crosses before projecting towards infinity.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `Vector(x: x2 - x1, y: y2 - y1, z: z2 - z1).length > 0`
    @_transparent
    init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        let start = Vector(x: x1, y: y1, z: z1)
        let direction = Vector(x: x2, y: y2, z: z2) - start
        
        self.init(start: start, direction: direction)
    }
    
    /// Initializes a new Ray with a 3D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    init(x: Scalar, y: Scalar, z: Scalar, dx: Scalar, dy: Scalar, dz: Scalar) {
        self.init(start: Vector(x: x, y: y, z: z),
                  direction: Vector(x: dx, y: dy, z: dz))
    }
}
