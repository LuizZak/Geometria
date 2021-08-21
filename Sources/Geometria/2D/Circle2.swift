/// Represents a 2D circle with a double-precision floating-point center point
/// and radius parameters.
public typealias Circle2D = NSphere<Vector2D>

/// Represents a 2D circle with a single-precision floating-point center point
/// and radius parameters.
public typealias Circle2F = NSphere<Vector2F>

public extension NSphere where Vector: Vector2Type & VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this circle's area contains a given point.
    ///
    /// Points at the perimeter of the circle (distance to center == radius)
    /// are considered as contained within the circle.
    @inlinable
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(.init(x: x, y: y))
    }
}
