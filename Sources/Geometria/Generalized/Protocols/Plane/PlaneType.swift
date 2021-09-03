/// Represents a plane in N-dimensional space with a center point and a normal
/// vector.
public protocol PlaneType: GeometricType {
    /// The vector for this plane.
    associatedtype Vector: VectorFloatingPoint
    
    /// A point that is on this plane.
    var pointOnPlane: Vector { get }
    
    /// A normal vector specifying the slope- or 'face', of the plane.
    var normal: Vector { get }
}
