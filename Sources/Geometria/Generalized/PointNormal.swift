/// Represents a point along with a normal on the surface of a geometry.
///
/// This point-normal pair type has more lax constraints compared to
/// `PointNormalPlane`.
public struct PointNormal<Vector: VectorType>: GeometricType, CustomStringConvertible {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    public var description: String {
        "PointNormal(point: \(point), normal: \(normal))"
    }
    
    /// A point on the surface of an object.
    public var point: Vector
    
    // TODO: This should be wrapped in @UnitVector, but that cascades a
    // TODO: VectorFloatingPoint requirement through ConvexLineIntersection.
    // TODO: Inspect if it's ok to push the requirement there as well.
    
    /// The surface normal of the shape at the point point.
    public var normal: Vector
    
    @_transparent
    public init(point: Vector, normal: Vector) {
        self.point = point
        self.normal = normal
    }
}

extension PointNormal: Equatable where Vector: Equatable { }
extension PointNormal: Hashable where Vector: Hashable { }

extension PointNormal: PlaneType where Vector: VectorFloatingPoint {
    @_transparent
    public var pointOnPlane: Vector { point }
    
    /// Returns a ``PointNormalPlane`` value initialized with this point normal's
    /// parameters.
    @_transparent
    public var asPlane: PointNormalPlane<Vector> {
        return PointNormalPlane(point: point, normal: normal)
    }
    
    /// Creates a ``PointNormal`` that wraps the given plane object.
    @_transparent
    public init<Plane: PlaneType>(_ plane: Plane) where Plane.Vector == Vector {
        self.init(point: plane.pointOnPlane, normal: plane.normal)
    }
}
