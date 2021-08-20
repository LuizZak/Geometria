/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias Polygon2D = Polygon2<Vector2D>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias Polygon2F = Polygon2<Vector2F>

/// Represents a 2D polygon as a series of connected integer 2D vertices.
public typealias Polygon2i = Polygon2<Vector2i>

/// Represents a 2D polygon as a series of connected 2D vertices.
public struct Polygon2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var vertices: [Vector]
    
    public init() {
        vertices = []
    }
    
    public init(vertices: [Vector]) {
        self.vertices = vertices
    }
    
    /// Adds a new point at the end of this polygon's vertices list`
    public mutating func addVertex(_ v: Vector) {
        vertices.append(v)
    }
    
    /// Adds a new point at the end of this polygon's vertices list`
    public mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector(x: x, y: y))
    }
}
