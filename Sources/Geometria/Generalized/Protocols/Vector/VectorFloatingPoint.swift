/// Protocol for vector types where the components are floating-point numbers
public protocol VectorFloatingPoint: VectorDivisible where Scalar: FloatingPoint {
    /// Returns the Euclidean norm (square root of the squared length), or
    /// _magnitude_, of this `VectorFloatingPoint`.
    var length: Scalar { get }
    
    /// Normalizes this `Vector`.
    ///
    /// Returns `Vector.zero`, if the vector has `length == 0`.
    mutating func normalize()
    
    /// Returns a normalized version of this `Vector`.
    ///
    /// Returns `Vector.zero` if the vector has `length == 0`.
    func normalized() -> Self
    
    /// Returns the distance between this `VectorFloatingPoint` and another
    /// `VectorFloatingPoint`.
    func distance(to vec: Self) -> Scalar
    
    /// Returns the result of adding the product of the two given vectors to this
    /// vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: One of the vectors to multiply before adding to this vector.
    ///   - rhs: The other vector to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    func addingProduct(_ a: Self, _ b: Self) -> Self
    
    /// Returns the result of adding the product of the given scalar and vector
    /// to this vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: A scalar to multiply before adding to this vector.
    ///   - rhs: A vector to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    func addingProduct(_ a: Scalar, _ b: Self) -> Self
    
    /// Returns the result of adding the product of the given vector and scalar
    /// to this vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: A vector to multiply before adding to this vector.
    ///   - rhs: A scalar to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    func addingProduct(_ a: Self, _ b: Scalar) -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule`.
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    func rounded() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    func ceil() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    func floor() -> Self
    
    static func % (lhs: Self, rhs: Self) -> Self
    
    static func % (lhs: Self, rhs: Scalar) -> Self
}

public extension VectorFloatingPoint {
    /// Returns the Euclidean norm (square root of the squared length), or
    /// _magnitude_, of this `VectorFloatingPoint`.
    @_transparent
    var length: Scalar {
        lengthSquared.squareRoot()
    }
    
    /// Normalizes this `Vector`.
    ///
    /// Returns `Vector.zero`, if the vector has `length == 0`.
    @_transparent
    mutating func normalize() {
        self = normalized()
    }
    
    /// Returns a normalized version of this vector.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    func normalized() -> Self {
        let l = length
        if l <= 0 {
            return .zero
        }
        
        return self / l
    }
    
    /// Returns the distance between this `VectorFloatingPoint` and another
    /// `VectorFloatingPoint`.
    @inlinable
    func distance(to vec: Self) -> Scalar {
        (vec - self).length
    }
}

/// Rounds the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
///
/// Equivalent to calling C's round() function on each component.
@inlinable
public func round<V: VectorFloatingPoint>(_ x: V) -> V {
    x.rounded(.toNearestOrAwayFromZero)
}

/// Rounds up the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.up`.
///
/// Equivalent to calling C's ceil() function on each component.
@inlinable
public func ceil<V: VectorFloatingPoint>(_ x: V) -> V {
    x.rounded(.up)
}

/// Rounds down the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.down`.
///
/// Equivalent to calling C's floor() function on each component.
@inlinable
public func floor<V: VectorFloatingPoint>(_ x: V) -> V {
    x.rounded(.down)
}
