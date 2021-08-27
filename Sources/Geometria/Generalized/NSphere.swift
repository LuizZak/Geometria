/// Represents an N-sphere with a center point and radius.
public struct NSphere<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radius: Scalar
    
    @_transparent
    public init(center: Vector, radius: Scalar) {
        self.center = center
        self.radius = radius
    }
}

extension NSphere: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NSphere: Hashable where Vector: Hashable, Scalar: Hashable { }
extension NSphere: Encodable where Vector: Encodable, Scalar: Encodable { }
extension NSphere: Decodable where Vector: Decodable, Scalar: Decodable { }

extension NSphere: BoundedVolumeType where Vector: VectorAdditive {
    public var bounds: AABB<Vector> {
        return AABB(minimum: center - radius, maximum: center + radius)
    }
}

public extension NSphere where Scalar: AdditiveArithmetic {
    @inlinable
    func expanded(by value: Scalar) -> NSphere {
        return NSphere(center: center, radius: radius + value)
    }
}

public extension NSphere where Vector: VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this N-sphere's area contains a given point by checking
    /// if the distance from the center of this N-sphere to the point is less than
    /// or equal to the radius of this N-sphere.
    ///
    /// Points at the perimeter of the N-sphere (distance to center == radius)
    /// are considered as contained within the N-sphere.
    @inlinable
    func contains(_ point: Vector) -> Bool {
        let d = point - center
        
        return d.lengthSquared <= radius * radius
    }
}
