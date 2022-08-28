/// A 1D plane in 2D space that can be intersected with other intersectable
/// planes, producing intersection lines.
///
/// A plane-intersectable plane is implicitly a line-intersectable plane as well.
public protocol PlaneIntersectablePlane2Type: LineIntersectablePlaneType where Vector: Vector2Type {
    /// Returns the intersection of this 2 dimensional plane with another
    /// plane as a vector, or `nil`, if the planes are parallel or
    /// [coplanar](https://en.wikipedia.org/wiki/Coplanarity).
    func intersection<Plane: PlaneType>(with other: Plane) -> Vector? where Plane.Vector == Vector
}

extension PlaneIntersectablePlane2Type where Vector: Vector2FloatingPoint {
    public func intersection<Plane: PlaneType>(with other: Plane) -> Vector? where Plane.Vector == Vector {
        let line1 = Line(a: pointOnPlane, b: pointOnPlane + normal.leftRotated())
        let line2 = Line(a: other.pointOnPlane, b: other.pointOnPlane + other.normal.leftRotated())

        return line1.intersection(with: line2)?.point
    }
}
