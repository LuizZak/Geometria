/// Represents an infinite plane with a point and a normal.
///
/// In 2D, a plane equates to a line, while in 3D and higher dimensions it
/// equates to a flat 2D plane.
public struct Plane<Vector: VectorFloatingPoint>: CustomStringConvertible {
    public var description: String {
        "Plane(point: \(point), normal: \(normal))"
    }
    
    /// A point on this plane.
    public var point: Vector
    
    /// The normal of the plane's surface.
    @UnitVector public var normal: Vector
    
    @_transparent
    public init(point: Vector, normal: Vector) {
        self.point = point
        self.normal = normal
    }
}
