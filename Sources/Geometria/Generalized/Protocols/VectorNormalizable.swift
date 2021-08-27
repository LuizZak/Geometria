/// Protocol for Vector types that can be normalized
public protocol VectorNormalizable: VectorReal {
    /// Normalizes this `Vector`.
    ///
    /// Returns `Vector.zero`, if the vector has `length == 0`.
    mutating func normalize()
    
    /// Returns a normalized version of this `Vector`.
    ///
    /// Returns `Vector.zero` if the vector has `length == 0`.
    func normalized() -> Self
}
