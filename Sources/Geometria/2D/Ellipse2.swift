/// Describes an ellipse as a double-precision floating-point center with X and
/// Y radii
public typealias Ellipse2D = Ellipse2<Double>

/// Describes an ellipse as a single-precision floating-point center with X and
/// Y radii
public typealias Ellipse2F = Ellipse2<Float>

/// Describes an ellipse as a center with X and Y radii
public struct Ellipse2<Scalar: VectorScalar> {
    public var center: Vector2<Scalar>
    public var radiusX: Scalar
    public var radiusY: Scalar
    
    public init(center: Vector2<Scalar>, radiusX: Scalar, radiusY: Scalar) {
        self.center = center
        self.radiusX = radiusX
        self.radiusY = radiusY
    }
}

extension Ellipse2: Equatable where Scalar: Equatable { }
extension Ellipse2: Hashable where Scalar: Hashable { }
extension Ellipse2: Encodable where Scalar: Encodable { }
extension Ellipse2: Decodable where Scalar: Decodable { }
