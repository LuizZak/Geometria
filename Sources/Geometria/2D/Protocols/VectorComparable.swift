public protocol VectorComparable: VectorType {
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    @inlinable
    static func > (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    @inlinable
    static func >= (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    @inlinable
    static func < (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    @inlinable
    static func <= (lhs: Self, rhs: Self) -> Bool
}
