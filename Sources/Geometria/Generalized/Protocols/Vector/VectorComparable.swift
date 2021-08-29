public protocol VectorComparable: VectorType where Scalar: Comparable {
    /// Returns the component of this vector that has the greatest value.
    var maximalComponent: Scalar { get }
    
    /// Returns the component of this vector that has the least value.
    var minimalComponent: Scalar { get }
    
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

/// Returns the pointwise minimal Vector where each component is the minimal
/// scalar value at each index for both vectors.
@inlinable
public func min<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    return V.pointwiseMin(lhs, rhs)
}

/// Returns the pointwise maximal Vector where each component is the maximal
/// scalar value at each index for both vectors.
@inlinable
public func max<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    return V.pointwiseMax(lhs, rhs)
}
