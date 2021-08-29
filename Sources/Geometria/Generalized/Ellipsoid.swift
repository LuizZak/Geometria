import RealModule

/// Represents an N-dimensional ellipsoid as a center with an N-dimensional
/// radii vector which describes the axis of the ellipsoid.
public struct Ellipsoid<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radius: Vector
    
    public init(center: Vector, radius: Vector) {
        self.center = center
        self.radius = radius
    }
}

extension Ellipsoid: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ellipsoid: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ellipsoid: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ellipsoid: Decodable where Vector: Decodable, Scalar: Decodable { }

extension Ellipsoid: BoundableType where Vector: VectorAdditive {
    @_transparent
    public var bounds: AABB<Vector> {
        return AABB(minimum: center - radius, maximum: center + radius)
    }
}

public extension Ellipsoid where Vector: VectorReal {
    /// Returns `true` if the given point is contained within this ellipse.
    ///
    /// The method returns `true` for points that lie on the outer perimeter of
    /// the ellipse (inclusive)
    @inlinable
    func contains(_ point: Vector) -> Bool {
        let r2 = Vector.pow(radius, 2)
        
        let p: Vector = Vector.pow(point - center, 2) / r2
        
        return p.lengthSquared <= 1
    }
}
