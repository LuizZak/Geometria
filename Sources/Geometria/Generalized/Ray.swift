/// Represents an N-dimensional ray line which has a starting point and crosses
/// a secondary point projecting past infinity.
public struct Ray<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// The starting position of this ray
    public var start: Vector
    
    /// A secondary point a line tracing from `start` passes through before
    /// being projected to infinity in a straight line.
    public var b: Vector
    
    @_transparent
    public init(start: Vector, b: Vector) {
        self.start = start
        self.b = b
    }
}

extension Ray: LineType {
    @_transparent
    public var a: Vector { return start }
}

extension Ray: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ray: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ray: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ray: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Ray {
    /// Returns a `Line` representation of this ray, where the `line.a` matches
    /// `self.start` and `line.b` matches `self.b`.
    @inlinable
    var asLine: Line<Vector> {
        return Line(a: start, b: b)
    }
}

public extension Ray where Vector: VectorFloatingPoint {
    /// Returns the distance squared between this line and a given vector.
    @inlinable
    func distanceSquared(to vector: Vector) -> Scalar {
        let proj = max(0, projectScalar(vector))
        
        let point = start + (b - start) * proj
        
        return vector.distanceSquared(to: point)
    }
}

public extension Ray where Vector: VectorReal {
    /// Returns the distance between this line and a given vector.
    @inlinable
    func distance(to vector: Vector) -> Scalar {
        return distanceSquared(to: vector).squareRoot()
    }
}
