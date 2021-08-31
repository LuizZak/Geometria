/// Protocol for rectangle geometric types that can be constructed with location
/// and size.
///
/// Rectangle types that cannot be constructed with arbitrary location or sizes
/// (e.g. ``NSquare`` has location but size is restricted to a single side
/// length scalar) should not conform to this protocol, instead use base
/// protocol ``RectangleType``.
public protocol ConstructableRectangleType: RectangleType {
    /// Initializes a new instance of a `ConstructableRectangleType` with the
    /// given location and size vectors.
    init(location: Vector, size: Vector)
    
    /// Returns a new rectangle that matches this rectangles's size with a new
    /// location.
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.withLocation(.init(x: 5, y: 10))
    ///
    /// print(result) // Prints "(location: (x: 5, y: 10), size: (width: 50, height: 50))"
    /// ```
    func withLocation(_ location: Vector) -> Self
    
    /// Returns a new rectangle that matches this rectangles's location with a
    /// new size.
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.withSize(.init(x: 25, y: 25))
    ///
    /// print(result) // Prints "(location: (x: 20, y: 30), size: (width: 25, height: 25))"
    /// ```
    func withSize(_ size: Vector) -> Self
}

public extension ConstructableRectangleType {
    @inlinable
    func withLocation(_ location: Vector) -> Self {
        Self(location: location, size: size)
    }
    
    @inlinable
    func withSize(_ size: Vector) -> Self {
        Self(location: location, size: size)
    }
}
