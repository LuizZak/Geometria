/// Represents a 3D hyperplane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3D = Hyperplane3<Vector3D>

/// Represents a 3D hyperplane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3F = Hyperplane3<Vector3F>

/// Typealias for `Hyperplane<V>`, where `V` is constrained to ``Vector3FloatingPoint``.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3<V: Vector3FloatingPoint> = Hyperplane<V>

public extension Hyperplane3 {
    /// Returns the intersection of this 3 dimensional hyperplane with another
    /// hyperplane as a line, or `nil`, if the hyperplanes are parallel or
    /// [coplanar](https://en.wikipedia.org/wiki/Coplanarity).
    func intersection(with other: Self) -> Line<Vector>? {
        guard other.normal.absolute != normal.absolute else {
            return nil
        }

        // Line is orthogonal to the normal of both planes
        let lineDirection = normal.cross(other.normal)

        // Find a line that travels from this plane to the other by finding the
        // orthogonal vector between this plane's normal and the normal we
        // created above.
        let toPlane = normal.cross(lineDirection)

        // Making a line projection in the direction of the second hyperplane
        // should result in an intersection point we can place the line at.
        let lineToPlane = Line(a: point, b: point + toPlane)
        guard let pointOnPlane = other.intersection(with: lineToPlane) else {
            return nil
        }

        return Line(a: pointOnPlane, b: pointOnPlane + lineDirection)
    }
}

extension Hyperplane3: Convex3Type {
    
}
