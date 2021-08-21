/// Represents an N-sphere with a center point and radius.
public struct NSphere<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radius: Scalar
    
    public init(center: Vector, radius: Scalar) {
        self.center = center
        self.radius = radius
    }
}

extension NSphere: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NSphere: Hashable where Vector: Hashable, Scalar: Hashable { }
extension NSphere: Encodable where Vector: Encodable, Scalar: Encodable { }
extension NSphere: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension NSphere where Scalar: AdditiveArithmetic {
    @inlinable
    func expanded(by value: Scalar) -> NSphere {
        return NSphere(center: center, radius: radius + value)
    }
}

public extension NSphere where Vector: VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this N-sphere's area contains a given point.
    ///
    /// Points at the perimeter of the N-sphere (distance to center == radius)
    /// are considered as contained within the N-sphere.
    @inlinable
    func contains(_ point: Vector) -> Bool {
        let d = point - center
        
        return d.lengthSquared <= radius * radius
    }
}
