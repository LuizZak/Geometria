/// Protocol for 2D real vector types.
public protocol Vector2Real: Vector2FloatingPoint & VectorReal {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2Type`.
    var angle: Scalar { get }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    func rotated(by angleInRadians: Scalar) -> Self
    
    /// Rotates this vector around the origin by a given angle in radians
    mutating func rotate(by angleInRadians: Scalar)
    
    /// Rotates this vector around a given pivot by a given angle in radians
    func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self
    
    /// Rotates a given vector around the origin by an angle in radians
    static func rotate(_ vec: Self, by angleInRadians: Scalar) -> Self
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix2x3<Scalar>) -> Self
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix2x3<Scalar>)
}
