/// Represents an N-dimensional square with an origin point and a side length.
///
/// The edges of the square are parallel to each axis of the corresponding vector
/// type of this square.
public struct NSquare<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// The origin of this box, corresponding to the minimal coordinate of the
    /// box's bounds.
    public var origin: Vector
    
    /// The length of the side edges of this square.
    public var sideLength: Scalar
    
    /// Returns a rectangle with the same boundaries as this square.
    @_transparent
    public var asRectangle: NRectangle<Vector> {
        return NRectangle(location: origin, size: Vector(repeating: sideLength))
    }
    
    @_transparent
    public init(origin: Vector, sideLength: Scalar) {
        self.origin = origin
        self.sideLength = sideLength
    }
}

public extension NSquare where Vector: VectorAdditive {
    /// Returns a box with the same boundaries as this square.
    @_transparent
    var asBox: AABB<Vector> {
        return AABB(minimum: origin, maximum: origin + Vector(repeating: sideLength))
    }
}

public extension NSquare where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if the given vector is contained within the bounds of this
    /// square.
    @inlinable
    func contains(_ vector: Vector) -> Bool {
        let max = origin + Vector(repeating: sideLength)
        
        return vector >= origin && vector <= max
    }
}
