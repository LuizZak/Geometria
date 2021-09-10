/// A protocol for types that expose at least an X and Y component for a ``TakeVector2``.
///
/// Objects of this type cannot be created as-is from 2 components, use
/// ``Vector2Type``, instead.
public protocol Vector2TakeableType: VectorType {
    /// Gets the X component of this vector takeable.
    var x: Scalar { get }
    
    /// Gets the Y component of this vector takeable.
    var y: Scalar { get }
}
