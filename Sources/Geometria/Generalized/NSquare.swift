/// Represents an N-dimensional square with an origin point and a scalar value
/// for the side length of each edge.
public struct NSquare<Vector: VectorType>: GeometricType {
    public typealias Scalar = Vector.Scalar
    
    /// The origin of this box, corresponding to the minimal coordinate of the
    /// box's bounds.
    public var origin: Vector
    
    /// The length of the side edges of this square.
    public var sideLength: Scalar
    
    /// Returns a rectangle with the same boundaries as this square.
    @_transparent
    public var asRectangle: NRectangle<Vector> {
        NRectangle(location: origin, size: Vector(repeating: sideLength))
    }
    
    @_transparent
    public init(origin: Vector, sideLength: Scalar) {
        self.origin = origin
        self.sideLength = sideLength
    }
}

extension NSquare: BoundableType where Vector: VectorAdditive {
    /// Returns a box with the same boundaries as this square.
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(minimum: origin, maximum: origin + Vector(repeating: sideLength))
    }
}

extension NSquare: VolumetricType where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if the given vector is contained within the bounds of this
    /// square.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        let max = origin + Vector(repeating: sideLength)
        
        return vector >= origin && vector <= max
    }
}
