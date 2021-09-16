/// Represents a `VectorType` with support for division.
public protocol VectorDivisible: VectorMultiplicative where Scalar: DivisibleArithmetic {
    static func / (lhs: Self, rhs: Self) -> Self
    
    static func / (lhs: Self, rhs: Scalar) -> Self
    
    static func / (lhs: Scalar, rhs: Self) -> Self
    
    static func /= (lhs: inout Self, rhs: Self)
    
    static func /= (lhs: inout Self, rhs: Scalar)
}

public extension Collection {
    /// Averages this collection of vectors into one `VectorDivisible` point as
    /// the mean location of each vector.
    ///
    /// Returns `VectorDivisible.zero`, if the collection is empty.
    ///
    /// ```swift
    /// let vectors = [
    ///     Vector2D(x: 3.0, y: 4.3),
    ///     Vector2D(x: -2.0, y: 2.3),
    ///     Vector2D(x: 2.0, y: 6.9)
    /// ]
    ///
    /// print(vectors.averageVector()) // Prints "(x: 1.0, y: 4.5)"
    /// ```
    @inlinable
    func averageVector<V: VectorDivisible>() -> V where Element == V, V.Scalar: FloatingPoint {
        if isEmpty {
            return .zero
        }
        
        let accum: V = reduce(into: .zero) { $0 += $1 }
        
        return accum / V.Scalar(count)
    }
}
