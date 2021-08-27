/// Represents a 2D ray as a pair of double-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity.
public typealias Ray2D = Ray2<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point vectors
/// where the ray starts and crosses before being projected to infinity.
public typealias Ray2F = Ray2<Vector2F>

/// Represents a 2D line as a pair of integer vectors where the ray starts and
/// crosses before being projected to infinity.
public typealias Ray2i = Ray2<Vector2i>

/// Typealias for `Ray<V>`, where `V` is constrained to `Vector2Type`.
public typealias Ray2<V: Vector2Type> = Ray<V>

extension Ray2: Line2Type {
    
}

public extension Ray2 where Vector: VectorAdditive {
    /// Initializes a new Ray with a 2D vector for its position and another
    /// describing the direction of the ray relative to the position.
    @_transparent
    init(x: Scalar, y: Scalar, dx: Scalar, dy: Scalar) {
        start = Vector(x: x, y: y)
        b = start + Vector(x: dx, y: dy)
    }
}
