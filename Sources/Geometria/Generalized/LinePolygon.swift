/// Represents a line polygon as a series of connected N-dimensional vertices.
///
/// A 2-dimensional line polygon defines a closed polygon, while in higher
/// dimensions it is simply a list of line segments where the ends meet at the
/// vertices.
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

extension LinePolygon: BoundedVolumeType where Vector: VectorAdditive & VectorComparable {
    public var bounds: AABB<Vector> {
        return AABB(points: vertices)
    }
}
