/// Protocol for geometric types defined by vectors that fill enclosed
/// rectangular areas with a defined location and size.
public protocol RectangleType: GeometricType {
    /// The vector type associated with this ``RectangleType``.
    associatedtype Vector: VectorType
    
    /// The starting location of this rectangle with the minimal coordinates
    /// contained within the rectangle.
    var location: Vector { get }
    
    /// The size of this rectangle, which when added to ``location`` produce the
    /// maximal coordinates contained within this rectangle.
    var size: Vector { get }
}
