/// Protocol for types that can represent 2D vectors.
public protocol Vector2Type: VectorType {
    /// The X coordinate of this 2D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 2D vector.
    var y: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar)
}

public extension Vector2Type where Self: VectorComparable {
    /// Returns the greatest scalar component between x, y in this vector
    @_transparent
    var maximalComponent: Scalar {
        max(x, y)
    }
    
    /// Returns the least scalar component between x, y in this vector
    @_transparent
    var minimalComponent: Scalar {
        min(x, y)
    }
}
