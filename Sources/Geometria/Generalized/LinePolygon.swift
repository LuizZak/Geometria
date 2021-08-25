/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias LinePolygon2D = LinePolygon<Vector2D>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias LinePolygon2F = LinePolygon<Vector2F>

/// Represents a 2D polygon as a series of connected integer 2D vertices.
public typealias LinePolygon2i = LinePolygon<Vector2i>

/// Represents a line polygon as a series of connected N-dimensional vertices.
public struct LinePolygon<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var vertices: [Vector]
    
    @_transparent
    public init() {
        vertices = []
    }
    
    @_transparent
    public init(vertices: [Vector]) {
        self.vertices = vertices
    }
    
    /// Adds a new vertex at the end of this polygon's vertices list
    @_transparent
    public mutating func addVertex(_ v: Vector) {
        vertices.append(v)
    }
}

extension LinePolygon: Equatable where Vector: Equatable, Scalar: Equatable { }
extension LinePolygon: Hashable where Vector: Hashable, Scalar: Hashable { }
extension LinePolygon: Encodable where Vector: Encodable, Scalar: Encodable { }
extension LinePolygon: Decodable where Vector: Decodable, Scalar: Decodable { }
