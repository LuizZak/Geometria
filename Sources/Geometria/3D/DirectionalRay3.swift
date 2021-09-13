/// Represents a 3D ray as a pair of double-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3D = DirectionalRay3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay3F = DirectionalRay3<Vector3F>

/// Typealias for `DirectionalRay3<V>`, where `V` is constrained to
/// ``Vector3FloatingPoint``.
public typealias DirectionalRay3<V: Vector3FloatingPoint> = DirectionalRay<V>

extension DirectionalRay3: Line3Type where Vector.SubVector2: Vector2FloatingPoint {
    public typealias SubLine2 = DirectionalRay2<Vector.SubVector2>
    
    /// Initializes a new Directional Ray with 3D vectors describing the start
    /// and secondary point the ray crosses before projecting towards infinity.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `Vector(x: x2 - x1, y: y2 - y1, z: z2 - z1).length > 0`
    @_transparent
    public init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        let start = Vector(x: x1, y: y1, z: z1)
        let direction = Vector(x: x2, y: y2, z: z2) - start
        
        self.init(start: start, direction: direction)
    }
    
    /// Initializes a new Ray with a 3D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    public init(x: Scalar, y: Scalar, z: Scalar, dx: Scalar, dy: Scalar, dz: Scalar) {
        self.init(start: Vector(x: x, y: y, z: z),
                  direction: Vector(x: dx, y: dy, z: dz))
    }
    
    /// Creates a 2D line of the same underlying type as this line.
    public static func make2DLine(_ a: SubLine2.Vector, _ b: SubLine2.Vector) -> SubLine2 {
        SubLine2(a: a, b: b)
    }
}

extension DirectionalRay3: Line3FloatingPoint where Vector: Vector3Type & VectorFloatingPoint, Vector.SubVector2: Vector2FloatingPoint {
    
}
