/// A line that is described by two 2-dimensional vectors.
public protocol Line2Type: LineType where Vector: Vector2Type {
    
}

public extension Line2Type where Vector: Vector2Real {
    /// Returns the angle of this line, in radians
    @_transparent
    var angle: Vector.Scalar {
        return (b - a).angle
    }
}
