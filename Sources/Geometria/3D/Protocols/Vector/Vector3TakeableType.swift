/// A protocol for types that expose at least an X, Y, and Z component for a
/// ``TakeVector3``.
///
/// Objects of this type cannot be created as-is from 3 components, use
/// ``Vector3Type``, instead.
public protocol Vector3TakeableType: Vector2TakeableType {
    /// Gets the Z component of this vector takeable.
    var z: Scalar { get }
}
