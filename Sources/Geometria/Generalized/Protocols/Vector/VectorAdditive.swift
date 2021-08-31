/// Represents a `VectorType` with addition and subtraction arithmetic
/// operators available.
public protocol VectorAdditive: VectorType, AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// Initializes a zero-valued `VectorType`
    ///
    /// ```swift
    /// print(Vector2D()) // Prints "(x: 0.0, y: 0.0)"
    /// print(Vector2i()) // Prints "(x: 0, y: 0)"
    /// ```
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
