/// Represents a 2D ellipse as a double-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2D = Ellipse2<Vector2D>

/// Represents a 2D ellipse as a single-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2F = Ellipse2<Vector2F>

/// Represents a 2D ellipse as a integer center with X and Y radii.
public typealias Ellipse2i = Ellipse2<Vector2i>

/// Represents a 2D ellipse as a center with X and Y radii.
public struct Ellipse2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radiusX: Scalar
    public var radiusY: Scalar
    
    public init(center: Vector, radiusX: Scalar, radiusY: Scalar) {
        self.center = center
        self.radiusX = radiusX
        self.radiusY = radiusY
    }
}

extension Ellipse2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ellipse2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ellipse2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ellipse2: Decodable where Vector: Decodable, Scalar: Decodable { }
