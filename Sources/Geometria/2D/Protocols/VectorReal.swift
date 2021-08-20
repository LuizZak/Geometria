import RealModule

/// Protocol for vector types where the components are real numbers.
public protocol VectorReal: VectorMultiplicative where Scalar: Real {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `VectorReal`
    var length: Scalar { get }
    
    /// Returns the distance between this `VectorReal` and another `VectorReal`
    func distance(to vec: Self) -> Scalar
}

/// Protocol for 2D real vector types.
public protocol Vector2Real: VectorReal & Vector2Type {
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
    static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix2<Scalar>)
}
