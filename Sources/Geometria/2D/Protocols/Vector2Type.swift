import RealModule

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
    /// Creates a new `Vector2Type` with the given scalar on all coordinates
    @inlinable
    init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar)
    }
}

public func min<V: Vector2Type>(_ vec1: V, _ vec2: V) -> V where V.Scalar: Comparable {
    return V(x: min(vec1.x, vec2.x), y: min(vec1.y, vec2.y))
}

public func max<V: Vector2Type>(_ vec1: V, _ vec2: V) -> V where V.Scalar: Comparable {
    return V(x: max(vec1.x, vec2.x), y: max(vec1.y, vec2.y))
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
