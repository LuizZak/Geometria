/// Protocol for types that can represent 2D vectors.
public protocol Vector2Type: VectorType {
    /// The X coordinate of this 2D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 2D vector.
    var y: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar)
    
    /// Creates a new `Vector2Type` with the given scalar on all coordinates
    @inlinable
    init(repeating scalar: Scalar)
}

/// Returns the pointwise minimal Vector where each component is the minimal
/// scalar value at each index for both vectors.
@inlinable
public func min<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    return V.pointwiseMin(lhs, rhs)
}

/// Returns the pointwise maximal Vector where each component is the maximal
/// scalar value at each index for both vectors.
@inlinable
public func max<V: VectorComparable>(_ lhs: V, _ rhs: V) -> V {
    return V.pointwiseMax(lhs, rhs)
}

/// Returns a `VectorSigned` with each component as the absolute value of the
/// components of a given `VectorSigned`.
///
/// Equivalent to calling C's abs() function on each component.
@inlinable
public func abs<V: VectorSigned>(_ x: V) -> V {
    return x.absolute
}

/// Rounds the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
///
/// Equivalent to calling C's round() function on each component.
@inlinable
public func round<V: VectorFloatingPoint>(_ x: V) -> V {
    return x.rounded(.toNearestOrAwayFromZero)
}

/// Rounds up the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.up`.
///
/// Equivalent to calling C's ceil() function on each component.
@inlinable
public func ceil<V: VectorFloatingPoint>(_ x: V) -> V {
    return x.rounded(.up)
}

/// Rounds down the components of a given `VectorFloatingPoint` using
/// `FloatingPointRoundingRule.down`.
///
/// Equivalent to calling C's floor() function on each component.
@inlinable
public func floor<V: VectorFloatingPoint>(_ x: V) -> V {
    return x.rounded(.down)
}
