/// Protocol for 2D vector types with multiplicable scalars.
public protocol Vector2Multiplicative: Vector2Type, VectorMultiplicative {
    /// Gets the (x: 1, y: 0) vector of this type.
    static var unitX: Self { get }
    
    /// Gets the (x: 0, y: 1) vector of this type.
    static var unitY: Self { get }
    
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    ///
    /// Also called perp-dot product, as it equates to taking the dot product
    /// of `self • other.perpendicular`. Provided in `Vector2Multiplicative` as
    /// a convenience, as the protocol constraints are more lax than
    /// `Vector2Signed`.
    @inlinable
    func cross(_ other: Self) -> Scalar
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
}
