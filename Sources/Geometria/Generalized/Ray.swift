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

extension Ray: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ray: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ray: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ray: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Ray where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this ray,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `start <-> b`.
    ///
    /// By multiplying the result of this function by `start + (b - start)`,
    /// the projected point as it lays on this line can be obtained.
    @inlinable
    func projectScalar(_ vector: Vector) -> Scalar {
        let relEnd = b - start
        let relVec = vector - start
        
        let proj = relVec.dot(relEnd) / (b - start).lengthSquared
        
        return proj
    }
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by
    /// `start <-> b`, potentialy extending past either end.
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectScalar(vector)
        
        return start + (b - start) * proj
    }
    
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
