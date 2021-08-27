/// Represents a `VectorType` with addition and subtraction arithmetic
/// operators available.
public protocol VectorAdditive: VectorType, AdditiveArithmetic where Scalar: AdditiveArithmetic {
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
