/// Represents a rounded rectangle with double-precision, floating-point bounds
/// and X and Y radius
public typealias RoundRectangle = RoundRectangleT<Double>

/// Represents a rounded rectangle with bounds and X and Y radius
public struct RoundRectangleT<Scalar: VectorScalar>: Equatable, Codable {
    public var bounds: RectangleT<Scalar>
    public var radius: Vector2<Scalar>
    
    public init(bounds: RectangleT<Scalar>, radius: Vector2<Scalar>) {
        self.bounds = bounds
        self.radius = radius
    }
    
    public init(bounds: RectangleT<Scalar>, radiusX: Scalar, radiusY: Scalar) {
        self.bounds = bounds
        self.radius = Vector2<Scalar>(x: radiusX, y: radiusY)
    }
}
