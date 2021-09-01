/// Represents a point along with a normal on the surface of a geometry.
public struct PointNormal<Vector: VectorType>: CustomStringConvertible {
    public var description: String {
        return "PointNormal(point: \(point), normal: \(normal))"
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
