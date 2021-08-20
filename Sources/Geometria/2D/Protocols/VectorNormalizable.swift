/// Protocol for Vector types that can be normalized
public protocol VectorNormalizable {
    /// Normalizes this `Vector`.
    ///
    /// Returns `Vector.zero`, if the vector has `length == 0`.
    @inlinable
    mutating func normalize()
    
    /// Returns a normalized version of this `Vector`.
    ///
    /// Returns `Vector.zero` if the vector has `length == 0`.
    @inlinable
    func normalized() -> Self
}
