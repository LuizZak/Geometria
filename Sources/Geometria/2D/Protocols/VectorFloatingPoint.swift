/// Protocol for vector types where the components are floating-point numbers
public protocol VectorFloatingPoint: VectorDivisible where Scalar: FloatingPoint {
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule`.
    @inlinable
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @inlinable
    func rounded() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @inlinable
    func ceil() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @inlinable
    func floor() -> Self
    
    @inlinable
    static func % (lhs: Self, rhs: Self) -> Self
    
    @inlinable
    static func % (lhs: Self, rhs: Scalar) -> Self
}
