/// A protocol for projective spaces, where lower-dimensional spaces can be
/// represented as embedded in higher dimensional features, like a point on a
/// 2D plane in 3D.
public protocol ProjectiveSpace {
    /// The vector type for the higher-dimensional shape in Euclidean geometric
    /// space.
    associatedtype Vector: VectorType
    
    /// The type for projective coordinates within the projective space.
    associatedtype Coordinates: Equatable
    
    /// Projects a vector onto this projective space, and if successful, returns
    /// a set of coordinates for this projective space.
    func attemptProjection(_ vector: Vector) -> Coordinates?
    
    /// Pulls out a projective coordinate from this space back to the original
    /// space of this projective space.
    func projectOut(_ proj: Coordinates) -> Vector
}
