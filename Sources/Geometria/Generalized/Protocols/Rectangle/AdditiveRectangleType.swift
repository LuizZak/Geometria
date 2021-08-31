/// Protocol refining ``RectangleType`` with ``VectorAdditive`` extensions.
public protocol AdditiveRectangleType: RectangleType where Vector: VectorAdditive {
    /// Returns a copy of this rectangle with its location offset by a given
    /// Vector amount.
    func offsetBy(_ vector: Vector) -> Self
    
    /// Returns a copy of this rectangle with its size increased by a given
    /// Vector amount.
    func resizedBy(_ vector: Vector) -> Self
}

public extension AdditiveRectangleType where Self: ConstructableRectangleType {
    /// Returns a copy of this rectangle with its location offset by a given
    /// Vector amount.
    @_transparent
    func offsetBy(_ vector: Vector) -> Self {
        Self(location: location + vector, size: size)
    }
    
    /// Returns a copy of this rectangle with its size increased by a given
    /// Vector amount.
    @_transparent
    func resizedBy(_ vector: Vector) -> Self {
        Self(location: location, size: size + vector)
    }
}
