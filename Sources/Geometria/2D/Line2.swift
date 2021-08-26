/// Represents a 2D line as a pair of double-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line2D = Line<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point vectors
/// which the infinite line crosses.
public typealias Line2F = Line<Vector2F>

/// Represents a 2D line as a pair of integer vectors which the infinite line
/// crosses.
public typealias Line2i = Line<Vector2i>

public extension Line where Vector: Vector2Type {
    @_transparent
    init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        a = Vector(x: x1, y: y1)
        b = Vector(x: x2, y: y2)
    }
}

public extension Line where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    @_transparent
    var angle: Scalar {
        return (b - a).angle
    }
}
