/// Represents a 2D rounded rectangle with double-precision floating-point bounds
/// and X and Y radius.
public typealias RoundRectangle2D = RoundRectangle2<Vector2D>

/// Represents a 2D rounded rectangle with single-precision floating-point bounds
/// and X and Y radius.
public typealias RoundRectangle2F = RoundRectangle2<Vector2F>

/// Represents a 2D rounded rectangle with integer bounds and X and Y radius.
public typealias RoundRectangle2i = RoundRectangle2<Vector2i>

/// Represents a 2D rounded rectangle with rectangular bounds and X and Y radius.
public typealias RoundRectangle2<Vector: Vector2Type> = RoundNRectangle<Vector>

extension RoundRectangle2 {
    @_transparent
    public init(rectangle: NRectangle<Vector>, radiusX: Scalar, radiusY: Scalar) {
        self.rectangle = rectangle
        self.radius = Vector(x: radiusX, y: radiusY)
    }
}
