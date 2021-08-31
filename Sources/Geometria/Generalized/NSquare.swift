/// Represents an N-dimensional square with an origin point and a scalar value
/// for the side length of each edge.
public struct NSquare<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The location of this box, corresponding to the minimal coordinate of the
    /// box's bounds.
    public var location: Vector
    
    /// The length of the side edges of this square.
    public var sideLength: Scalar
    
    /// Returns a rectangle with the same boundaries as this square.
    @_transparent
    public var asRectangle: NRectangle<Vector> {
        NRectangle(location: location, size: Vector(repeating: sideLength))
    }
    
    @_transparent
    public init(location: Vector, sideLength: Scalar) {
        self.location = location
        self.sideLength = sideLength
    }
}

extension NSquare: RectangleType & BoundableType where Vector: VectorAdditive {
    /// Returns the span of this ``NSquare``.
    public var size: Vector {
        return Vector(repeating: sideLength)
    }
    
    /// Returns the minimal ``AABB`` capable of containing this ``NSquare``.
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(minimum: location, maximum: location + Vector(repeating: sideLength))
    }
}

extension NSquare: VolumetricType where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if the given vector is contained within the bounds of this
    /// square.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        let max = location + Vector(repeating: sideLength)
        
        return vector >= location && vector <= max
    }
}
