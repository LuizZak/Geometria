import RealModule

/// Represents a line as a pair of start and end N-dimensional vectors.
public struct Line<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var start: Vector
    public var end: Vector
    
    @inlinable
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
    @inlinable
    var lengthSquared: Scalar {
        return (end - start).lengthSquared
    }
}

public extension Line where Vector: VectorReal {
    /// Returns the length of this line
    @inlinable
    var length: Scalar {
        return (end - start).length
    }
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by
    /// `start <-> end`, extending past both ends.
    func project(_ vector: Vector) -> Vector {
        let relEnd = end - start
        let relVec = vector - start
        
        let proj = relVec.dot(relEnd) / length
        
        return start + (end - start) * proj
    }
}