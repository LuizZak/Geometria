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
    
    /// Creates a new vector with the coordinates of a given ``Vector2Type``,
    /// along with a new value for the ``z`` axis.
    init<V: Vector2Type>(_ vec: V, z: Scalar) where V.Scalar == Scalar
}

public extension Vector3Type {
    /// The number of scalars in the vector.
    ///
    /// For 3D vectors, this value is always 3.
    @_transparent
    var scalarCount: Int { 3 }
    
    /// Accesses the scalar at the specified position.
    ///
    /// - index `0`: ``x``
    /// - index `1`: ``y``
    /// - index `2`: ``z``
    ///
    /// - precondition: `index >= 0 && index < 3`
    @inlinable
    subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0:
                return x
                
            case 1:
                return y
                
            case 2:
                return z
                
            default:
                preconditionFailure("index >= 0 && index < 3")
            }
        }
        set {
            switch index {
            case 0:
                x = newValue
                
            case 1:
                y = newValue
                
            case 2:
                z = newValue
                
            default:
                preconditionFailure("index >= 0 && index < 3")
            }
        }
    }
    
    /// Creates a new vector with the coordinates of a given ``Vector2Type``,
    /// along with a new value for the ``z`` axis.
    init<V: Vector2Type>(_ vec: V, z: Scalar) where V.Scalar == Scalar {
        self.init(x: vec.x, y: vec.y, z: z)
    }
}

public extension Vector3Type where Self: VectorComparable {
    /// Returns the index of the component of this vector that has the greatest
    /// value.
    ///
    /// ```swift
    /// Vector3D(x: -3.0, y: 2.5, z: 0).maximalComponentIndex // Returns 1
    /// ```
    @_transparent
    var maximalComponentIndex: Int {
        if x > y {
            if y > z {
                return 0
            }
            if x > z {
                return 0
            }
        }
        
        if y > z {
            return 1
        }
        
        return 2
    }
    
    /// Returns the index of the component of this vector that has the least
    /// value.
    ///
    /// ```swift
    /// Vector3D(x: -3.0, y: 2.5, z: 0).minimalComponentIndex // Returns 0
    /// ```
    @_transparent
    var minimalComponentIndex: Int {
        if x < y {
            if y < z {
                return 0
            }
            if x < z {
                return 0
            }
        }
        
        if y < z {
            return 1
        }
        
        return 2
    }
    
    /// Returns the greatest scalar component between x, y, z in this vector
    @_transparent
    var maximalComponent: Scalar {
        max(max(x, y), z)
    }
    
    /// Returns the least scalar component between x, y, z in this vector
    @_transparent
    var minimalComponent: Scalar {
        min(min(x, y), z)
    }
}
