/// Represents an object that exposese a single function that returns the signed
/// squared distance to the closest point on the surface of a geometry.
public protocol SignedSquaredDistanceMeasurableType {
    /// The type of vector associated with this ``SignedSquaredDistanceMeasurableType``.
    associatedtype Vector: VectorType
    
    /// Returns the signed squared distance from the closest point on the surface
    /// of this object to the given point.
    func signedSquaredDistance(to point: Vector) -> Vector.Scalar
}
