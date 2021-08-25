/// Represents a double-precision floating-point 2D square.
public typealias Square2D = NSquare<Vector2D>

/// Represents a single-precision floating-point 2D square.
public typealias Square2F = NSquare<Vector2F>

/// Represents an integer 2D square.
public typealias Square2i = NSquare<Vector2i>

public extension NSquare where Vector: Vector2Type {
    @_transparent
    init(x: Scalar, y: Scalar, sideLength: Scalar) {
        self.init(origin: .init(x: x, y: y), sideLength: sideLength)
    }
}
