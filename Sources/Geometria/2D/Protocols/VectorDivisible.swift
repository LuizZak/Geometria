/// Represents a `VectorType` with support for division.
public protocol VectorDivisible: VectorMultiplicative where Scalar: DivisibleArithmetic {
    static func / (lhs: Self, rhs: Self) -> Self
    
    static func / (lhs: Self, rhs: Scalar) -> Self
    
    static func /= (lhs: inout Self, rhs: Self)
    
    static func /= (lhs: inout Self, rhs: Scalar)
}

public extension Collection {
    /// Averages this collection of vectors into one `VectorDivisible` point as
    /// the mean location of each vector.
    ///
    /// Returns `VectorDivisible.zero`, if the collection is empty.
    @inlinable
    func averageVector<V: VectorDivisible>() -> V where Element == V, V.Scalar: FloatingPoint {
        if isEmpty {
            return .zero
        }
        
        return reduce(into: .zero) { $0 += $1 } / V.Scalar(count)
    }
}
