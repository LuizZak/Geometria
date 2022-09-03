/// Protocol for types that can represent 2D vectors.
public protocol Vector2Type: VectorTakeable where TakeDimensions == Vector2TakeDimensions {
    associatedtype SubVector2 = Self

    /// The X coordinate of this 2D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 2D vector.
    var y: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar)
    
    /// Initializes a new instance of this `Vector2Type` type by copying the
    /// coordinates of another `Vector2Type` of matching scalar type.
    init<Vector: Vector2Type>(_ vector: Vector) where Vector.Scalar == Scalar
}

/// Defines the dimension of an indexed takeable getter for a Vector 2 type.
public enum Vector2TakeDimensions: Int {
    case x
    case y
}

public extension Vector2Type {
    /// The number of scalars in the vector.
    ///
    /// For 2D vectors, this value is always 2.
    @_transparent
    var scalarCount: Int { 2 }
    
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
    
    @_transparent
    init<Vector: Vector2Type>(_ vector: Vector) where Vector.Scalar == Scalar {
        self.init(x: vector.x, y: vector.y)
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
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponent // Returns 2.5
    /// ```
    @_transparent
    var maximalComponent: Scalar {
        max(x, y)
    }
    
    /// Returns the least scalar component between x, y in this vector
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponent // Returns -3.0
    /// ```
    @_transparent
    var minimalComponent: Scalar {
        min(x, y)
    }
}
