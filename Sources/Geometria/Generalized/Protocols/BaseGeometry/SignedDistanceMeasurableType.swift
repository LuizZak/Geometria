/// Represents an object that exposese a single function that returns the signed
/// distance to the closest point on the surface of a geometry.
public protocol SignedDistanceMeasurableType: GeometricType {
    /// The type of vector associated with this ``SignedDistanceMeasurableType``.
    associatedtype Vector: VectorType
    
    /// Returns the signed distance from the closest point on the surface of
    /// this object to the given point.
    func signedDistance(to point: Vector) -> Vector.Scalar
}
