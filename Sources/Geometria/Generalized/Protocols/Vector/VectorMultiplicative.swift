/// Protocol for Vectors that support multiplication
public protocol VectorMultiplicative: VectorAdditive where Scalar: Numeric {
    /// A unit-value `VectorType` value where each component corresponds to its
    /// representation of `1`.
    static var one: Self { get }
    
    /// Returns the length squared of this `VectorType`.
    ///
    /// Performs the computation `x0 * x0 + x1 * x1 + ... + xN * xN` for any
    /// N-dimensional vector type, and is equivalent to the squared distance to
    /// the origin of the vector space, or the ``dot(_:)`` product of the vector
    /// by itself.
    var lengthSquared: Scalar { get }
    
    /// Returns the squared distance between this `VectorType` and another
    /// `VectorType`.
    ///
    /// Equivalent to `(vec - self).distanceSquared`.
    func distanceSquared(to vec: Self) -> Scalar
    
    /// Calculates the [dot product](http://en.wikipedia.org/wiki/Dot_product)
    /// between this vector and another.
    ///
    /// Performs the computation `x1 * y1 + x2 * y2 + ... + xN + yN` for any
    /// N-dimensional vector type.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: 3.0, y: -2.0)
    /// let v2 = Vector2D(x: 2.5, y: 7.0)
    ///
    /// print(v1.dot(v2)) // Prints "-6.5"
    /// ```
    func dot(_ other: Self) -> Scalar
    
    /// Performs a linear interpolation between two vectors.
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
    
    static func * (lhs: Scalar, rhs: Self) -> Self
    
    static func *= (lhs: inout Self, rhs: Self)
    
    static func *= (lhs: inout Self, rhs: Scalar)
}

public extension VectorMultiplicative {
    /// Returns the length squared of this `VectorType`
    @_transparent
    var lengthSquared: Scalar {
        self.dot(self)
    }
    
    /// Returns the squared distance between this `VectorType` and another
    /// `VectorType`.
    ///
    /// Equivalent to `(vec - self).distanceSquared`.
    @_transparent
    func distanceSquared(to vec: Self) -> Scalar {
        (self - vec).lengthSquared
    }
    
    /// Performs a linear interpolation between two points.
    ///
    /// Passing `amount` a value of 0 will cause `start` to be returned; a value
    /// of 1 will cause `end` to be returned.
    ///
    /// - Parameter start: Start point.
    /// - Parameter end: End point.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    @_transparent
    static func lerp(start: Self, end: Self, amount: Scalar) -> Self {
        ((start * (1 - amount)) as Self) + (end * amount as Self)
    }
}
