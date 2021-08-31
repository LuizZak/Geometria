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
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.offsetBy(.init(x: 5, y: 10))
    ///
    /// print(result) // Prints "(location: (x: 25, y: 40), size: (width: 50, height: 50))"
    /// ```
    @_transparent
    func offsetBy(_ vector: Vector) -> Self {
        Self(location: location + vector, size: size)
    }
    
    /// Returns a copy of this rectangle with its size increased by a given
    /// Vector amount.
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.resizedBy(.init(x: 10, y: 20))
    ///
    /// print(result) // Prints "(location: (x: 20, y: 30), size: (width: 60, height: 70))"
    /// ```
    @_transparent
    func resizedBy(_ vector: Vector) -> Self {
        Self(location: location, size: size + vector)
    }
}
