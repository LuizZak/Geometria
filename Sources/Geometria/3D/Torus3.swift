/// Represents a three dimensional [torus] shape as a center point, an axis of
/// rotation around that center point, and two radii describing the radius of
/// a circle, and the radius of the axis of rotation of the circle around the
/// center point of the torus with double-precision floating-point numbers.
public typealias Torus3D = Torus3<Vector3D>

/// Represents a three dimensional [torus] shape as a center point, an axis of
/// rotation around that center point, and two radii describing the radius of
/// a circle, and the radius of the axis of rotation of the circle around the
/// center point of the torus with single-precision floating-point numbers.
public typealias Torus3F = Torus3<Vector3F>

/// Represents a three dimensional [torus] shape as a center point, an axis of
/// rotation around that center point, and two radii describing the radius of
/// a circle, and the radius of the axis of rotation of the circle around the
/// center point of the torus.
///
/// [torus]: https://en.wikipedia.org/wiki/Torus
public struct Torus3<Vector: Vector3FloatingPoint>: GeometricType {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// The geometric center point of the torus.
    public var center: Vector
    
    /// The axis of revolution of the circle forming the torus in three-space.
    /// The major radius of the torus expands perpendicular to this axis by
    /// ``majorRadius``.
    @UnitVector public var axis: Vector
    
    /// The radius from the center of the torus to the center of the tube.
    public var majorRadius: Scalar
    
    /// The radius of the tube of the torus.
    public var minorRadius: Scalar
    
    @_transparent
    public init(center: Vector, axis: Vector, majorRadius: Scalar, minorRadius: Scalar) {
        self.center = center
        self.axis = axis
        self.majorRadius = majorRadius
        self.minorRadius = minorRadius
    }
}

extension Torus3: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Torus3: Hashable where Vector: Hashable, Scalar: Hashable { }

extension Torus3: BoundableType {
    /// Gets the minimal bounding box capable of fully containing all the points
    /// of this ``Torus3``.
    @inlinable
    public var bounds: AABB<Vector> {
        // Find an axis to extract a normal from this torus's axis of rotation
        var cross = axis.cross(.unitX)
        if cross.lengthSquared == 0 {
            cross = axis.cross(.unitY)
        }

        let radius = majorRadius + minorRadius
        
        let normCross = cross.normalized() * radius
        let otherAxis = normCross.cross(axis).normalized() * radius

        let minorRadiusSpan = axis * minorRadius
        
        let a = center - normCross
        let b = center + normCross
        let c = center - otherAxis
        let d = center + otherAxis

        let top = AABB(of: a - minorRadiusSpan, b - minorRadiusSpan, c - minorRadiusSpan, d - minorRadiusSpan)
        let bot = AABB(of: a + minorRadiusSpan, b + minorRadiusSpan, c + minorRadiusSpan, d + minorRadiusSpan)

        return top.union(bot)
    }
}
