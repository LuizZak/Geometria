/// Describes a circle with a double-precision, floating-point center point and
/// radius parameters
public typealias Circle = CircleT<Double>

/// Describes a circle with a center point and radius
public struct CircleT<Scalar: VectorScalar>: Equatable, Codable {
    public var center: Vector2<Scalar>
    public var radius: Scalar
    
    public init(center: Vector2<Scalar>, radius: Scalar) {
        self.center = center
        self.radius = radius
    }
    
    @inlinable
    public func expanded(by value: Scalar) -> CircleT {
        return CircleT(center: center, radius: radius + value)
    }
    
    @inlinable
    public func contains(x: Scalar, y: Scalar) -> Bool {
        let dx = x - center.x
        let dy = y - center.y
        
        return dx * dx + dy * dy < radius * radius
    }
    
    @inlinable
    public func contains(_ point: Vector2<Scalar>) -> Bool {
        return contains(x: point.x, y: point.y)
    }
}
