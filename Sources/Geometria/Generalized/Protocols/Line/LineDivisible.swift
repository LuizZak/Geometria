import RealModule

/// Protocol for objects that form geometric lines with two ``VectorDivisible``
/// vectors representing two points on the line.
public protocol LineDivisible: LineMultiplicative where Vector: VectorDivisible {
    /// Alias for `Vector.Scalar`.
    typealias Magnitude = Vector.Scalar
    
    /// Performs a vector projection of a given vector with respect to this line,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `a <-> b`.
    ///
    /// By multiplying the result of this function by `(b - a)` and adding `a`,
    /// the projected point as it lays on this line can be obtained.
    ///
    /// - seealso: ``projectedNormalizedMagnitude(_:)-vyrp``
    func projectAsScalar(_ vector: Vector) -> Magnitude
}

public extension LineDivisible {
    @inlinable
    func projectAsScalar(_ vector: Vector) -> Magnitude {
        let relEnd = lineSlope
        let relVec = vector - a
        
        let proj = relVec.dot(relEnd) / relEnd.lengthSquared
        
        return proj
    }
}
