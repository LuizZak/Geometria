/// Represents a 2D rounded rectangle with double-precision floating-point bounds
/// and X and Y radius.
public typealias RoundRectangle2D = RoundRectangle2<Vector2D>

/// Represents a 2D rounded rectangle with single-precision floating-point bounds
/// and X and Y radius.
public typealias RoundRectangle2F = RoundRectangle2<Vector2F>

/// Represents a 2D rounded rectangle with integerbounds and X and Y radius.
public typealias RoundRectangle2i = RoundRectangle2<Vector2i>

/// Represents a 2D rounded rectangle with rectangular bounds and X and Y radius.
public struct RoundRectangle2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var bounds: NRectangle<Vector>
    public var radius: Vector
    
    public init(bounds: NRectangle<Vector>, radius: Vector) {
        self.bounds = bounds
        self.radius = radius
    }
    
    public init(bounds: NRectangle<Vector>, radiusX: Scalar, radiusY: Scalar) {
        self.bounds = bounds
        self.radius = Vector(x: radiusX, y: radiusY)
    }
}

extension RoundRectangle2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension RoundRectangle2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension RoundRectangle2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension RoundRectangle2: Decodable where Vector: Decodable, Scalar: Decodable { }
