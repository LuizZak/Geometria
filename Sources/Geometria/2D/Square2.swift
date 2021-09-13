/// Represents a double-precision floating-point 2D square.
public typealias Square2D = Square2<Vector2D>

/// Represents a single-precision floating-point 2D square.
public typealias Square2F = Square2<Vector2F>

/// Represents an integer 2D square.
public typealias Square2i = Square2<Vector2i>

/// Typealias for `NSquare<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Square2<V: Vector2Type> = NSquare<V>

public extension Square2 {
    @_transparent
    init(x: Scalar, y: Scalar, sideLength: Scalar) {
        self.init(location: .init(x: x, y: y), sideLength: sideLength)
    }
}
