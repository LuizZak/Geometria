/// Represents a 2D line as a pair of double-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line2D = Line2<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line2F = Line2<Vector2F>

/// Represents a 2D line as a pair of integer vectors which the infinite line
/// crosses.
public typealias Line2i = Line2<Vector2i>

/// Typealias for `Line<V>`, where `V` is constrained to `Vector2Type`.
public typealias Line2<V: Vector2Type> = Line<V>

extension Line2: Line2Type {
    @_transparent
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        a = Vector(x: x1, y: y1)
        b = Vector(x: x2, y: y2)
    }
}
