/// Represents a 2D circle with a double-precision floating-point center point
/// and radius parameters.
public typealias Circle2D = Circle2<Vector2D>

/// Represents a 2D circle with a single-precision floating-point center point
/// and radius parameters.
public typealias Circle2F = Circle2<Vector2F>

/// Represents a 2D circle with a center point and radius.
public struct Circle2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radius: Scalar
    
    public init(center: Vector, radius: Scalar) {
        self.center = center
        self.radius = radius
    }
}

extension Circle2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Circle2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Circle2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Circle2: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Circle2 where Scalar: AdditiveArithmetic {
    @inlinable
    func expanded(by value: Scalar) -> Circle2 {
        return Circle2(center: center, radius: radius + value)
    }
}

public extension Circle2 where Scalar: Numeric & Comparable {
    /// Returns `true` if this circle's area contains a given point.
    @inlinable
    func contains(x: Scalar, y: Scalar) -> Bool {
        let dx = x - center.x
        let dy = y - center.y
        
        return dx * dx + dy * dy < radius * radius
    }
    
    /// Returns `true` if this circle's area contains a given point.
    @inlinable
    func contains(_ point: Vector2<Scalar>) -> Bool {
        return contains(x: point.x, y: point.y)
    }
}
