/// Protocol for general geometric types that can be fitted into a finite, 
/// non-empty axis-aligned bounding box.
public protocol BoundableType {
    /// The vector type associated with this `BoundableType`.
    associatedtype Vector: VectorType
    
    /// Gets a bounding box with the minimal volume to fully enclose all points
    /// of this geometry.
    var bounds: AABB<Vector> { get }
}
