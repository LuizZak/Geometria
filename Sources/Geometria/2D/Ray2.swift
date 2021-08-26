/// Represents a 2D ray as a pair of double-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity.
public typealias Ray2D = Ray<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity
public typealias Ray2F = Ray<Vector2F>

/// Represents a 2D line as a pair of integer vectors where the ray starts and
/// crosses before being projected to infinity
public typealias Ray2i = Ray<Vector2i>

public extension Ray where Vector: Vector2Type & VectorAdditive {
    /// Initializes a new Ray with a 2D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    init(x: Scalar, y: Scalar, dx: Scalar, dy: Scalar) {
        start = Vector(x: x, y: y)
        b = start + Vector(x: dx, y: dy)
    }
}

public extension Ray where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    @_transparent
    var angle: Scalar {
        return (b - start).angle
    }
}
