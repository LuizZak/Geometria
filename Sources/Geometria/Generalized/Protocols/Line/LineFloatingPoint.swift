/// Protocol for objects that form geometric lines with two floating-point
/// vectors representing the endpoints of the line.
public protocol LineFloatingPoint: LineType where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this line,
    /// returning a scalar value representing the normalized magnitude of the
    /// projected point between `a <-> b`.
    ///
    /// By multiplying the result of this function by `(b - a)` and adding `a`,
    /// the projected point as it lays on this line can be obtained.
    ///
    /// - seealso: projectedNormalizedMagnitude(_:)
    func projectAsScalar(_ vector: Vector) -> Vector.Scalar
    
    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by extending
    /// `a <-> b`.
    func project(_ vector: Vector) -> Vector
    
    /// Returns the result of creating a projection of this line's start point
    /// projected towards this line's end point, with a total magnitude of
    /// `scalar`.
    ///
    /// For `scalar == 0`, returns `self.a`, for `scalar == self.length`,
    /// returns `self.b`.
    ///
    /// - parameter scalar: A non-normalized magnitude that describes the length
    /// along the slope of this line to generate the point out of.
    func projectedMagnitude(_ scalar: Vector.Scalar) -> Vector

    /// Returns the result of creating a projection of this line's start point
    /// projected towards this line's end point, with a normalized magnitude of
    /// `scalar`.
    ///
    /// For `scalar == 0`, returns `self.a`, for `scalar == 1`, returns `self.b`
    ///
    /// - parameter scalar: A normalized magnitude that describes the length
    /// along the slope of this line to generate the point out of. Values
    /// outside the range [0, 1] are allowed and equate to projections past the
    /// endpoints of the line.
    func projectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector
    
    /// Returns `true` if a normalized, projected `scalar` representing a segment
    /// of this line with the same starting point and direction, with
    /// `length = self.length * scalar`, lies within the boundaries of this line.
    ///
    /// For infinite lines, all projected scalars lie within the line, while in
    /// line segments bounded with start/end points, only values lying in (0-1)
    /// are contained on the line.
    func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool
    
    /// Returns the squared distance between this line and a given vector.
    func distanceSquared(to vector: Vector) -> Vector.Scalar
    
    /// Returns the distance between this line and a given vector.
    ///
    /// Equivalent to `self.distanceSquared(to: vector).squareRoot()`.
    func distance(to vector: Vector) -> Vector.Scalar
}

public extension LineFloatingPoint {
    @inlinable
    func projectAsScalar(_ vector: Vector) -> Vector.Scalar {
        let relEnd = b - a
        let relVec = vector - a
        
        let proj = relVec.dot(relEnd) / relEnd.lengthSquared
        
        return proj
    }
    
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectAsScalar(vector)
        
        return projectedNormalizedMagnitude(proj)
    }
    
    @inlinable
    func projectedMagnitude(_ scalar: Vector.Scalar) -> Vector {
        a.addingProduct((b - a).normalized(), scalar)
    }
    
    @inlinable
    func projectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector {
        a.addingProduct(b - a, scalar)
    }
    
    @inlinable
    func distanceSquared(to vector: Vector) -> Vector.Scalar {
        let point = project(vector)
        
        return vector.distanceSquared(to: point)
    }
    
    @_transparent
    func distance(to vector: Vector) -> Vector.Scalar {
        distanceSquared(to: vector).squareRoot()
    }
}
