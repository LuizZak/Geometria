/// Protocol for types that can represent 3D vectors.
public protocol Vector3Type: VectorType {
    /// The X coordinate of this 3D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 3D vector.
    var y: Scalar { get set }
    
    /// The Z coordinate of this 3D vector.
    var z: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar, z: Scalar)
}

public extension Vector3Type where Self: VectorComparable {
    /// Returns the greatest scalar component between x, y, z in this vector
    @_transparent
    var maximalComponent: Scalar {
        return max(max(x, y), z)
    }
    
    /// Returns the least scalar component between x, y, z in this vector
    @_transparent
    var minimalComponent: Scalar {
        return min(min(x, y), z)
    }
}
