public protocol VectorComparable: VectorType where Scalar: Comparable {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    static func > (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    static func >= (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    static func < (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    static func <= (lhs: Self, rhs: Self) -> Bool
}
