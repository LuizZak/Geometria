/// Protocol for 2D vector types where the components are signed numbers.
public protocol Vector2Signed: Vector2Multiplicative & VectorSigned where SubVector3: VectorSigned {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance.
    mutating func formPerpendicular()

    /// Returns a Vector perpendicular to this Vector relative to the origin
    func perpendicular() -> Self

    /// Returns a vector that represents this vector's point, rotated 90º counter
    /// clockwise relative to the origin.
    func leftRotated() -> Self

    /// Rotates this vector 90º counter clockwise relative to the origin.
    /// This alters the vector instance.
    mutating func formLeftRotated()

    /// Returns a vector that represents this vector's point, rotated 90º
    /// clockwise relative to the origin.
    func rightRotated() -> Self

    /// Rotates this vector 90º clockwise relative to the origin.
    /// This alters the vector instance.
    mutating func formRightRotated()
}
