/// Protocol for rectangle geometric types that can be constructed.
public protocol ConstructableRectangleType: RectangleType {
    /// Initializes a new instance of this `RectangleType` with the given
    /// location and size vectors.
    init(location: Vector, size: Vector)
    
    /// Returns a new rectangle that matches this rectangles's size with a new
    /// location.
    func withLocation(_ location: Vector) -> Self
    
    /// Returns a new rectangle that matches this rectangles's location with a
    /// new size.
    func withSize(_ size: Vector) -> Self
}

public extension ConstructableRectangleType {
    @inlinable
    func withLocation(_ location: Vector) -> Self {
        return Self(location: location, size: size)
    }
    
    @inlinable
    func withSize(_ size: Vector) -> Self {
        return Self(location: location, size: size)
    }
}
