public extension Line where Vector: Vector2Type {
    @inlinable
    init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector(x: x1, y: y1)
        end = Vector(x: x2, y: y2)
    }
}

extension Line where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    @inlinable
    public var angle: Scalar {
        return (end - start).angle
    }
}

