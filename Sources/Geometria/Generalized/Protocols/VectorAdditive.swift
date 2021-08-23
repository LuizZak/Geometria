/// Represents a `VectorType` with addition and subtraction arithmetic
/// operators available.
public protocol VectorAdditive: VectorType, Equatable where Scalar: AdditiveArithmetic {
    /// A zero-value `VectorType` value where each component corresponds to its
    /// representation of `0`.
    static var zero: Self { get }
    
    /// Initializes a zero-valued `VectorType`
    init()
    
    static func + (lhs: Self, rhs: Self) -> Self
    
    static func - (lhs: Self, rhs: Self) -> Self
    
    static func + (lhs: Self, rhs: Scalar) -> Self
    
    static func - (lhs: Self, rhs: Scalar) -> Self
    
    static func += (lhs: inout Self, rhs: Self)
    
    static func -= (lhs: inout Self, rhs: Self)
    
    static func += (lhs: inout Self, rhs: Scalar)
    
    static func -= (lhs: inout Self, rhs: Scalar)
}
