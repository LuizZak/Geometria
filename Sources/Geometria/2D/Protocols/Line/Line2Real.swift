/// A line that is described by two 2-dimensional real vectors.
public protocol Line2Real: Line2Type where Vector: Vector2Real {
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
