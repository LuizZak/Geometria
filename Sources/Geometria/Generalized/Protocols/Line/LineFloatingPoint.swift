/// Protocol for objects that form geometric lines with at least two
/// floating-point vector representing the endpoints of the line.
public protocol LineFloatingPoint: LineType where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this line,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `a <-> b`.
    ///
    /// By multiplying the result of this function by `(b - a)` and adding `a`,
    /// the projected point as it lays on this line can be obtained.
    func projectScalar(_ vector: Vector) -> Vector.Scalar
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by
    /// `b <-> a`, potentialy extending past either end.
    func project(_ vector: Vector) -> Vector
    
    /// Returns the distance squared between this line and a given vector.
    func distanceSquared(to vector: Vector) -> Vector.Scalar
}

public extension LineFloatingPoint {
    @inlinable
    func projectScalar(_ vector: Vector) -> Vector.Scalar {
        let relEnd = b - a
        let relVec = vector - a
        
        let proj = relVec.dot(relEnd) / relEnd.lengthSquared
        
        return proj
    }
    
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectScalar(vector)
        
        return a.addingProduct(b - a, proj)
    }
    
    @inlinable
    func distanceSquared(to vector: Vector) -> Vector.Scalar {
        let point = project(vector)
        
        return vector.distanceSquared(to: point)
    }
}
