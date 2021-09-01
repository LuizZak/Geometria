/// Represents a `VectorType` with comparison operators available.
public protocol VectorComparable: VectorType where Scalar: Comparable {
    /// Returns the index of the component of this vector that has the greatest
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponentIndex // Returns 1
    /// ```
    var maximalComponentIndex: Int { get }
    
    /// Returns the index of the component of this vector that has the least
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponentIndex // Returns 0
    /// ```
    var minimalComponentIndex: Int { get }
    
    /// Returns the component of this vector that has the greatest value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponent // Returns 2.5
    /// ```
    var maximalComponent: Scalar { get }
    
    /// Returns the component of this vector that has the least value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponent // Returns -3.0
    /// ```
    var minimalComponent: Scalar { get }
    
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: -3.0, y: 2.5)
    /// let v2 = Vector2D(x: 4.0, y: -6.2)
    ///
    /// print(Vector2D.pointwiseMin(v1, v2)) // Prints "(x: -3.0, y: -6.2)"
    /// ```
    static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: -3.0, y: 2.5)
    /// let v2 = Vector2D(x: 4.0, y: -6.2)
    ///
    /// print(Vector2D.pointwiseMax(v1, v2)) // Prints "(x: 4, y: 2.5)"
    /// ```
    static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: -2.0, y: 1)
    /// let v2 = Vector2D(y: 3.0, y: 2)
    /// let v3 = Vector2D(y: 4.0, y: 1)
    ///
    /// print(v2 > v1) // Prints "true"
    /// print(v3 > v1) // Prints "false"
    /// ```
    static func > (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: -2.0, y: 1)
    /// let v2 = Vector2D(y: 3.0, y: 2)
    /// let v3 = Vector2D(y: 4.0, y: 1)
    ///
    /// print(v2 >= v1) // Prints "true"
    /// print(v3 >= v1) // Prints "true"
    /// ```
    static func >= (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: 2.0, y: -1)
    /// let v2 = Vector2D(y: -3.0, y: -2)
    /// let v3 = Vector2D(y: -4.0, y: -1)
    ///
    /// print(v2 < v1) // Prints "true"
    /// print(v3 < v1) // Prints "false"
    /// ```
    static func < (lhs: Self, rhs: Self) -> Bool
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// ```swift
    /// let v1 = Vector2D(x: 2.0, y: -1)
    /// let v2 = Vector2D(y: -3.0, y: -2)
    /// let v3 = Vector2D(y: -4.0, y: -1)
    ///
    /// print(v2 <= v1) // Prints "true"
    /// print(v3 <= v1) // Prints "true"
    /// ```
    static func <= (lhs: Self, rhs: Self) -> Bool
}

public extension VectorComparable {
    /// Returns the index of the component of this vector that has the greatest
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponentIndex // Returns 1
    /// ```
    var maximalComponentIndex: Int {
        var c = 0
        var value = self[c]
        
        for i in 1..<scalarCount where self[i] > value {
            c = i
            value = self[i]
        }
        
        return c
    }
    
    /// Returns the index of the component of this vector that has the least
    /// value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponentIndex // Returns 0
    /// ```
    var minimalComponentIndex: Int {
        var c = 0
        var value = self[c]
        
        for i in 1..<scalarCount where self[i] < value {
            c = i
            value = self[i]
        }
        
        return c
    }
    
    /// Returns the component of this vector that has the greatest value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).maximalComponent // Returns 2.5
    /// ```
    @_transparent
    var maximalComponent: Scalar {
        self[maximalComponentIndex]
    }
    
    /// Returns the component of this vector that has the least value.
    ///
    /// ```swift
    /// Vector2D(x: -3.0, y: 2.5).minimalComponent // Returns -3.0
    /// ```
    @_transparent
    var minimalComponent: Scalar {
        self[minimalComponentIndex]
    }
}

/// Returns the pointwise minimal Vector where each component is the minimal
/// scalar value at each index for both vectors.
///
/// Convenience for ``VectorComparable/pointwiseMin(_:_:)``.
@_transparent
public func min<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    V.pointwiseMin(lhs, rhs)
}

/// Returns the pointwise maximal Vector where each component is the maximal
/// scalar value at each index for both vectors.
///
/// Convenience for ``VectorComparable/pointwiseMax(_:_:)``.
@_transparent
public func max<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    V.pointwiseMax(lhs, rhs)
}
