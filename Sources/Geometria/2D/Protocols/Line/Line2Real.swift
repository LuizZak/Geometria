/// Protocol for 2D line types where the vectors are real vectors.
public protocol Line2Real: Line2FloatingPoint where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    var angle: Vector.Scalar { get }
}

public extension Line2Real {
    /// Returns the angle of this line, in radians
    @_transparent
    var angle: Vector.Scalar {
        (b - a).angle
    }
}
