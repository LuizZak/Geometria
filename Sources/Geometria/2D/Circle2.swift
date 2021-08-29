/// Represents a 2D circle with a double-precision floating-point center point
/// and radius parameters.
public typealias Circle2D = Circle2<Vector2D>

/// Represents a 2D circle with a single-precision floating-point center point
/// and radius parameters.
public typealias Circle2F = Circle2<Vector2F>

/// Typealias for `NSphere<V>`, where `V` is constrained to `Vector2Type`.
public typealias Circle2<V: Vector2Type> = NSphere<V>

public extension Circle2 where Vector: VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this circle's area contains a given point.
    ///
    /// Points at the perimeter of the circle (distance to center == radius)
    /// are considered as contained within the circle.
    @_transparent
    func contains(x: Scalar, y: Scalar) -> Bool {
        contains(.init(x: x, y: y))
    }
}
