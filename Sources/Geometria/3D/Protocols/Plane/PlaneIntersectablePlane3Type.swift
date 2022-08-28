/// A 2D plane in 3D space that can be intersected with other intersectable
/// planes, producing intersection lines.
///
/// A plane-intersectable plane is implicitly a line-intersectable plane as well.
public protocol PlaneIntersectablePlane3Type: LineIntersectablePlaneType where Vector: Vector3Type {
    /// Returns the intersection of this 3 dimensional plane with another
    /// plane as a line, or `nil`, if the planes are parallel or
    /// [coplanar](https://en.wikipedia.org/wiki/Coplanarity).
    func intersection<Plane: LineIntersectablePlaneType>(with other: Plane) -> Line<Vector>? where Plane.Vector == Vector
}

extension PlaneIntersectablePlane3Type where Vector: Vector3Multiplicative {
    public func intersection<Plane: LineIntersectablePlaneType>(with other: Plane) -> Line<Vector>? where Plane.Vector == Vector {
        guard other.normal.absolute != normal.absolute else {
            return nil
        }

        // Line is orthogonal to the normal of both planes
        let lineDirection = normal.cross(other.normal)

        // Find a line that travels from this plane to the other by finding the
        // orthogonal vector between this plane's normal and the normal we
        // created above.
        let toPlane = normal.cross(lineDirection)

        // Making a line projection in the direction of the second plane should
        // result in an intersection point we can place the line at.
        let lineToPlane = Line(a: pointOnPlane, b: pointOnPlane + toPlane)
        guard let pointOnPlane = other.intersection(with: lineToPlane) else {
            return nil
        }

        return Line(a: pointOnPlane, b: pointOnPlane + lineDirection)
    }
}
