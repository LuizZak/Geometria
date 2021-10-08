/// Represents a three dimensional [torus] shape as a center point, an axis of
/// rotation around that center point, and two radii describing the radius of
/// a circle, and the radius of the axis of rotation of the circle around the
/// center point of the torus.
///
/// [torus]: https://en.wikipedia.org/wiki/Torus
public struct Torus3<Vector: Vector3Type> {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// The geometric center point of the torus.
    public var center: Vector
    
    /// The axis of revolution of the circle forming the torus in three-space.
    @UnitVector public var axis: Vector
    
    /// The radius from the center of the torus to the center of the tube.
    public var majorTorus: Scalar
    
    /// The radius of the tube of the torus.
    public var minorRadius: Scalar
    
    @_transparent
    public init(center: Vector, majorTorus: Torus3<Vector>.Scalar, minorRadius: Torus3<Vector>.Scalar) {
        self.center = center
        self.majorTorus = majorTorus
        self.minorRadius = minorRadius
    }
}
