/// Represents a 2D ray as a pair of double-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay2D = DirectionalRay2<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point vectors
/// describing where the ray starts and crosses before being projected to
/// infinity.
public typealias DirectionalRay2F = DirectionalRay2<Vector2F>

/// Typealias for `DirectionalRay<V>`, where `V` is constrained to
/// `Vector2Type & VectorFloatingPoint`.
public typealias DirectionalRay2<V: Vector2Type & VectorFloatingPoint> = DirectionalRay<V>

public extension DirectionalRay2 {
    /// Initializes a new Directional Ray with 2D vectors describing the start
    /// and secondary point the ray crosses before projecting towards infinity.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `Vector(x: x2 - x1, y: y2 - y1).length > 0`
    @_transparent
    init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        self.init(start: Vector(x: x1, y: y1), direction: Vector(x: x2 - x1, y: y2 - y1))
    }
    
    /// Initializes a new Directional Ray with a 2D vector for its position and
    /// another describing the direction of the ray relative to the position.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `Vector(x: dx, y: dy).length > 0`
    @_transparent
    init(x: Scalar, y: Scalar, dx: Scalar, dy: Scalar) {
        self.init(start: Vector(x: x, y: y), direction: Vector(x: dx, y: dy))
    }
}

public extension DirectionalRay2 where Vector: Vector2Real {
    /// Returns the angle of this directional ray, in radians
    @_transparent
    var angle: Vector.Scalar {
        return direction.angle
    }
}
