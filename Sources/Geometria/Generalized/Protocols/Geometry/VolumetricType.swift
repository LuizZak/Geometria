/// Protocol for geometric types that have an internal volumetric area that can
/// be queried with Vectors for containment checks.
public protocol VolumetricType: GeometricType {
    associatedtype Vector: VectorComparable
    
    /// Returns `true` iff `vector` lies within the 'inside' area of this
    /// volumetric shape.
    func contains(_ vector: Vector) -> Bool
}
