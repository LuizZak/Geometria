/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias Polygon2D = Polygon2<Double>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias Polygon2F = Polygon2<Float>

/// Represents a 2D polygon as a series of connected 2D vertices.
public struct Polygon2<Scalar> {
    public var vertices: [Vector2<Scalar>]
    
    public init() {
        vertices = []
    }
    
    public init(vertices: [Vector2<Scalar>]) {
        self.vertices = vertices
    }
    
    /// Adds a new point at the end of this polygon's vertices list`
    public mutating func addVertex(_ v: Vector2<Scalar>) {
        vertices.append(v)
    }
    
    /// Adds a new point at the end of this polygon's vertices list`
    public mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector2(x: x, y: y))
    }
}
