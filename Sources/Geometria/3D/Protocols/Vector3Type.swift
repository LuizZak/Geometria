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
    
    /// Creates a new `Vector3Type` with the given scalar on all coordinates
    @inlinable
    init(repeating scalar: Scalar)
}
