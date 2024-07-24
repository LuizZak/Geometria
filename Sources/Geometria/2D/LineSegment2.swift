/// Represents a 2D line segment as a pair of double-precision floating-point
/// start and end vectors.
public typealias LineSegment2D = LineSegment2<Vector2D>

/// Represents a 2D line segment as a pair of single-precision floating-point
/// start and end vectors.
public typealias LineSegment2F = LineSegment2<Vector2F>

/// Represents a 2D line segment as a pair of integer start and end vectors.
public typealias LineSegment2i = LineSegment2<Vector2i>

/// Typealias for `LineSegment<V>`, where `V` is constrained to ``Vector2Type``.
public typealias LineSegment2<V: Vector2Type> = LineSegment<V>

extension LineSegment2: Line2Type {
    @_transparent
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector(x: x1, y: y1)
        end = Vector(x: x2, y: y2)
    }
}

extension LineSegment2: Line2Multiplicative where Vector: Vector2Multiplicative { }
extension LineSegment2: LineSigned & Line2Signed where Vector: Vector2Signed { }
extension LineSegment2: Line2FloatingPoint where Vector: Vector2FloatingPoint { }
extension LineSegment2: Line2Real where Vector: Vector2Real { }
