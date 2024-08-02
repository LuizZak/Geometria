/// Protocol for 2D vector types with multiplicative scalars.
public protocol Vector2Multiplicative: Vector2Additive, VectorMultiplicative where SubVector3: Vector3Multiplicative {
    /// Gets the (x: 1, y: 0) vector of this type.
    static var unitX: Self { get }

    /// Gets the (x: 0, y: 1) vector of this type.
    static var unitY: Self { get }

    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands,
    /// with the 'z' coordinate being 0.
    ///
    /// Also called perp-dot product, as it equates to taking the dot product
    /// of `self • other.perpendicular`. Provided in `Vector2Multiplicative` as
    /// a convenience, as the protocol constraints are more lax than
    /// `Vector2Signed`.
    func cross(_ other: Self) -> Scalar

    /// Performs a 2D [vector triple product] between `self`, `b`, and `c`:
    /// `a x (b x c)`.
    ///
    /// Can be used to derive a vector perpendicular to `ab`, such that it points
    /// in the direction of `ac`.
    ///
    /// [vector triple product]: https://en.wikipedia.org/wiki/Triple_product#Vector_triple_product
    func tripleProduct(_ b: Self, _ c: Self) -> Self

    /// Returns the winding value of the three given input points.
    ///
    /// Winding indicates whether the vectors are clockwise (> 0), colinear (== 0),
    /// or counter-clockwise (< 0)
    static func winding(_ p0: Self, _ p1: Self, _ p2: Self) -> Scalar
}

public extension Vector2Multiplicative {
    /// Gets the (x: 1, y: 0) vector of this type.
    @_transparent
    static var unitX: Self {
        Self(x: 1, y: 0)
    }

    /// Gets the (x: 0, y: 1) vector of this type.
    @_transparent
    static var unitY: Self {
        Self(x: 0, y: 1)
    }

    @_transparent
    func cross(_ other: Self) -> Scalar {
        // NOTE: Doing this in separate statements to ease long compilation times in Xcode 12
        let d1 = x * other.y
        let d2 = y * other.x

        return d1 - d2
    }

    @inlinable
    func tripleProduct(_ b: Self, _ c: Self) -> Self {
        let a3 = SubVector3(self, z: .zero)
        let b3 = SubVector3(b, z: .zero)
        let c3 = SubVector3(c, z: .zero)

        return Self(a3.tripleProduct(b3, c3)[.x, .y])
    }

    /// Returns the winding value of the three given input points.
    ///
    /// Winding indicates whether the vectors are clockwise (> 0), colinear (== 0),
    /// or counter-clockwise (< 0)
    @inlinable
    static func winding(_ p0: Self, _ p1: Self, _ p2: Self) -> Scalar {
        var winding: Self.Scalar = .zero

        winding = (p1 - p2).cross(p1 - p0)

        return winding
    }

    /// Returns `true` if the three given input points are wound in clockwise order.
    @inlinable
    static func areClockwise(_ p0: Self, _ p1: Self, _ p2: Self) -> Bool where Scalar: Comparable {
        return winding(p0, p1, p2) > .zero
    }
}
