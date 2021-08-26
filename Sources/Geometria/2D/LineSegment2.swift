/// Represents a 2D line segment as a pair of double-precision floating-point
/// start and end vectors.
public typealias LineSegment2D = LineSegment<Vector2D>

/// Represents a 2D line segment as a pair of single-precision floating-point
/// start and end vectors.
public typealias LineSegment2F = LineSegment<Vector2F>

/// Represents a 2D line segment as a pair of integer start and end vectors.
public typealias LineSegment2i = LineSegment<Vector2i>

extension LineSegment: Line2Type where Vector: Vector2Type {
    @_transparent
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector(x: x1, y: y1)
        end = Vector(x: x2, y: y2)
    }
}
