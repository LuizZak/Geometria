import RealModule

/// Represents a line as a pair of start and end N-dimensional vectors.
public struct Line<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var start: Vector
    public var end: Vector
    
    @_transparent
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
}

extension Line: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Line: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Line: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Line: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Line where Vector: VectorMultiplicative {
    /// Returns the squared length of this line
    @_transparent
    var lengthSquared: Scalar {
        return (end - start).lengthSquared
    }
}

public extension Line where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this line,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `start <-> end`.
    ///
    /// By multiplying the result of this function by `start + (end - start)`,
    /// the projected point as it lays on this line can be obtained.
    @inlinable
    func projectScalar(_ vector: Vector) -> Scalar {
        let relEnd = end - start
        let relVec = vector - start
        
        let proj = relVec.dot(relEnd) / lengthSquared
        
        return proj
    }
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by
    /// `start <-> end`, potentialy extending past either end.
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectScalar(vector)
        
        return start + (end - start) * proj
    }
    
    /// Returns the distance squared between this line and a given vector.
    @inlinable
    func distanceSquared(to vector: Vector) -> Scalar {
        let proj = min(1, max(0, projectScalar(vector)))
        
        let point = start + (end - start) * proj
        
        return vector.distanceSquared(to: point)
    }
}

public extension Line where Vector: VectorReal {
    /// Returns the length of this line
    @_transparent
    var length: Scalar {
        return (end - start).length
    }
    
    /// Returns the distance between this line and a given vector.
    @inlinable
    func distance(to vector: Vector) -> Scalar {
        return distanceSquared(to: vector).squareRoot()
    }
}
