/// Protocol for objects that form geometric lines with at least two points.
public protocol LineType {
    associatedtype Vector: VectorType
    
    /// Gets the first point that defines the line of this `LineType`
    var a: Vector { get }
    
    /// Gets the second point that defines the line of this `LineType`
    var b: Vector { get }
}

public extension LineType where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this line,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `a <-> b`.
    ///
    /// By multiplying the result of this function by `(b - a)` and adding `a`,
    /// the projected point as it lays on this line can be obtained.
    @inlinable
    func projectScalar(_ vector: Vector) -> Vector.Scalar {
        let relEnd = b - a
        let relVec = vector - a
        
        let proj = relVec.dot(relEnd) / relEnd.lengthSquared
        
        return proj
    }
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by
    /// `b <-> a`, potentialy extending past either end.
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectScalar(vector)
        
        return a.addingProduct(b - a, proj)
    }
}
