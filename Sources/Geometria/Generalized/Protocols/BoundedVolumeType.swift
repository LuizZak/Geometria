/// Describes a geometric type that can be fitted into a finite, axis-aligned
/// bounding box.
public protocol BoundedVolumeType {
    associatedtype Vector: VectorType
    
    /// Gets a bounding box with the minimal volume to fully enclose all points
    /// of this geometry.
    var bounds: AABB<Vector> { get }
}
