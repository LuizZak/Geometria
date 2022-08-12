/// Protocol for types that can represent 4D vectors.
public protocol Vector4Type: VectorTakeable {
    associatedtype SubVector4 = Self
    
    /// The X coordinate of this 4D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 4D vector.
    var y: Scalar { get set }
    
    /// The Z coordinate of this 4D vector.
    var z: Scalar { get set }
    
    /// The W coordinate of this 4D vector.
    var w: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar)
    
    /// Creates a new vector with the coordinates of a given ``Vector3Type``,
    /// along with a new value for the ``z`` and ``w`` axis.
    init<V: Vector2Type>(_ vec: V, z: Scalar, w: Scalar) where V.Scalar == Scalar
    
    /// Creates a new vector with the coordinates of a given ``Vector3Type``,
    /// along with a new value for the ``w`` axis.
    init<V: Vector3Type>(_ vec: V, w: Scalar) where V.Scalar == Scalar
    
    /// Initializes a new instance of this `Vector4Type` type by copying the
    /// coordinates of another `Vector4Type` of matching scalar type.
    init<Vector: Vector4Type>(_ vector: Vector) where Vector.Scalar == Scalar
}

public extension Vector4Type {
    /// The number of scalars in the vector.
    ///
    /// For 4D vectors, this value is always 4.
    @_transparent
    var scalarCount: Int { 4 }
    
    /// Accesses the scalar at the specified position.
    ///
    /// - index `0`: ``x``
    /// - index `1`: ``y``
    /// - index `2`: ``z``
    /// - index `3`: ``w``
    ///
    /// - precondition: `index >= 0 && index < 4`
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
                
            case 3:
                return w
                
            default:
                preconditionFailure("index >= 0 && index < 4")
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
                
            case 3:
                w = newValue
                
            default:
                preconditionFailure("index >= 0 && index < 4")
            }
        }
    }
    
    @_transparent
    init<V: Vector2Type>(_ vec: V, z: Scalar, w: Scalar) where V.Scalar == Scalar {
        self.init(x: vec.x, y: vec.y, z: z, w: w)
    }
    
    @_transparent
    init<V: Vector3Type>(_ vec: V, w: Scalar) where V.Scalar == Scalar {
        self.init(x: vec.x, y: vec.y, z: vec.z, w: w)
    }
    
    @_transparent
    init<Vector: Vector4Type>(_ vector: Vector) where Vector.Scalar == Scalar {
        self.init(x: vector.x, y: vector.y, z: vector.z, w: vector.w)
    }
}

public extension Vector4Type where Self: VectorComparable {
    /// Returns the index of the component of this vector that has the greatest
    /// value.
    ///
    /// ```swift
    /// Vector4D(x: -3.0, y: 2.5, z: 0, w: 3).maximalComponentIndex // Returns 3
    /// ```
    @_transparent
    var maximalComponentIndex: Int {
        if x > y && x > z && x > w {
            return 0
        }
        if y > z && y > w {
            return 1
        }
        if z > w {
            return 2
        }
        
        return 3
    }
    
    /// Returns the index of the component of this vector that has the least
    /// value.
    ///
    /// ```swift
    /// Vector4D(x: -3.0, y: 2.5, z: 0, w: 2).minimalComponentIndex // Returns 0
    /// ```
    @_transparent
    var minimalComponentIndex: Int {
        if x < y && x < z && x < w {
            return 0
        }
        if y < z && y < w {
            return 1
        }
        if z < w {
            return 2
        }
        
        return 3
    }
    
    /// Returns the greatest scalar component between x, y, z, and w in this vector
    ///
    /// ```swift
    /// Vector3D(x: -3.0, y: 2.5, z: 0, w: 3).maximalComponent // Returns 3
    /// ```
    @_transparent
    var maximalComponent: Scalar {
        max(max(max(x, y), z), w)
    }
    
    /// Returns the least scalar component between x, y, z, and w in this vector
    ///
    /// ```swift
    /// Vector4D(x: -3.0, y: 2.5, z: 0, w: 0).minimalComponent // Returns -3.0
    /// ```
    @_transparent
    var minimalComponent: Scalar {
        min(min(min(x, y), z), w)
    }
}
