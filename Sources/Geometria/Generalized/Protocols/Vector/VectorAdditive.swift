/// Represents a `VectorType` with addition and subtraction arithmetic
/// operators available.
public protocol VectorAdditive: VectorType, AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// Gets the number of scalars within this vector that has a non-zero value.
    var nonZeroScalarCount: Int { get }

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

public extension VectorAdditive {
    @inlinable
    var nonZeroScalarCount: Int {
        var c = 0
        var index = 0
        while index < scalarCount {
            defer { index += 1 }
            if self[index] != .zero {
                c += 1
            }
        }

        return c
    }

    @inlinable
    init() {
        self.init(repeating: .zero)
    }

    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Scalar) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs - rhs
    }
}
