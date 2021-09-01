/// Protocol for types that can represent 2D vectors.
public protocol Vector2Type: VectorType {
    /// The X coordinate of this 2D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 2D vector.
    var y: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar)
}

public extension Vector2Type {
    /// The number of scalars in the vector.
    ///
    /// For 2D vectors, this value is always 2.
    @_transparent
    var scalarCount: Int { return 2 }
    
    /// Accesses the scalar at the specified position.
    ///
    /// - index `0`: ``x``
    /// - index `1`: ``y``
    ///
    /// - precondition: `index >= 0 && index < 2`
    @inlinable
    subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0:
                return x
                
            case 1:
                return y
                
            default:
                preconditionFailure("index >= 0 && index < 2")
            }
        }
        set {
            switch index {
            case 0:
                x = newValue
                
            case 1:
                y = newValue
                
            default:
                preconditionFailure("index >= 0 && index < 2")
            }
        }
    }
}

public extension Vector2Type where Self: VectorComparable {
    /// Returns the index of the component of this vector that has the greatest
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponentIndex // Returns 1
    /// ```
    @_transparent
    var maximalComponentIndex: Int {
        x > y ? 0 : 1
    }
    
    /// Returns the index of the component of this vector that has the least
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponentIndex // Returns 0
    /// ```
    @_transparent
    var minimalComponentIndex: Int {
        x < y ? 0 : 1
    }
    
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
