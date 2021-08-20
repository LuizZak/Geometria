/// Protocol for Vectors that support multiplication
public protocol VectorMultiplicative: VectorAdditive where Scalar: Numeric {
    /// A unit-value `VectorType` value where each component corresponds to its
    /// representation of `1`.
    static var unit: Self { get }
    
    /// Returns the length squared of this `VectorType`
    @inlinable
    var lengthSquared: Scalar { get }
    
    /// Returns the distance squared between this `VectorType` and another `VectorType`
    @inlinable
    func distanceSquared(to vec: Self) -> Scalar
    
    /// Calculates the dot product between this and another provided `VectorType`
    @inlinable
    func dot(_ other: Self) -> Scalar
    
    /// Returns the vector that lies within this and another vector's ratio line
    /// projected at a specified ratio along the line created by the vectors.
    ///
    /// A vector on ratio of 0 is the same as this vector's position, and 1 is the
    /// same as the other vector's position.
    ///
    /// Values beyond 0 - 1 range project the point across the limits of the line.
    ///
    /// - Parameters:
    ///   - ratio: A ratio (usually 0 through 1) between this and the second vector.
    ///   - other: The second vector to form the line that will have the point
    /// projected onto.
    /// - Returns: A vector that lies within the line created by the two vectors.
    @inlinable
    func ratio(_ ratio: Scalar, to other: Self) -> Self
    
    /// Performs a linear interpolation between two points.
    ///
    /// Passing `amount` a value of 0 will cause `start` to be returned; a value
    /// of 1 will cause `end` to be returned.
    ///
    /// - Parameter start: Start point.
    /// - Parameter end: End point.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    static func lerp(start: Self, end: Self, amount: Scalar) -> Self
    
    static func * (lhs: Self, rhs: Self) -> Self
    
    static func * (lhs: Self, rhs: Scalar) -> Self
    
    static func *= (lhs: inout Self, rhs: Self)
    
    static func *= (lhs: inout Self, rhs: Scalar)
}

public protocol Vector2Multiplicative: Vector2Type, VectorMultiplicative {
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    func cross(_ other: Self) -> Scalar
}
