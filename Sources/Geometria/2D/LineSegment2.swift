/// Represents a 2D line segment as a pair of double-precision floating-point
/// start and end vectors.
public typealias LineSegment2D = LineSegment<Vector2D>

/// Represents a 2D line segment as a pair of single-precision floating-point
/// start and end vectors.
public typealias LineSegment2F = LineSegment<Vector2F>

/// Represents a 2D line segment as a pair of integer start and end vectors.
public typealias LineSegment2i = LineSegment<Vector2i>

public extension LineSegment where Vector: Vector2Type {
    @_transparent
    init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector(x: x1, y: y1)
        end = Vector(x: x2, y: y2)
    }
}

public extension LineSegment where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    @_transparent
    var angle: Scalar {
        return (end - start).angle
    }
}
