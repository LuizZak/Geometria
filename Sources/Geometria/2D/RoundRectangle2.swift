/// Represents a 2D rounded rectangle with double-precision floating-point bounds
/// and X and Y radius
public typealias RoundRectangle2D = RoundRectangle2<Double>

/// Represents a 2D rounded rectangle with single-precision floating-point bounds
/// and X and Y radius
public typealias RoundRectangle2F = RoundRectangle2<Float>

/// Represents a 2D rounded rectangle with bounds and X and Y radius
public struct RoundRectangle2<Scalar: VectorScalar>: Equatable, Codable {
    public var bounds: Rectangle2<Scalar>
    public var radius: Vector2<Scalar>
    
    public init(bounds: Rectangle2<Scalar>, radius: Vector2<Scalar>) {
        self.bounds = bounds
        self.radius = radius
    }
    
    public init(bounds: Rectangle2<Scalar>, radiusX: Scalar, radiusY: Scalar) {
        self.bounds = bounds
        self.radius = Vector2<Scalar>(x: radiusX, y: radiusY)
    }
}
