/// Represents a `VectorType` with support for division.
public protocol VectorDivisible: VectorMultiplicative where Scalar: DivisibleArithmetic {
    static func / (lhs: Self, rhs: Self) -> Self
    
    static func / (lhs: Self, rhs: Scalar) -> Self
    
    static func / (lhs: Scalar, rhs: Self) -> Self
    
    static func /= (lhs: inout Self, rhs: Self)
    
    static func /= (lhs: inout Self, rhs: Scalar)
}

public extension VectorDivisible {
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
}
