/// Protocol for objects that form geometric lines with two floating-point
/// vectors representing two points on the line.
public protocol LineFloatingPoint: LineDivisible, PointProjectableType, SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    /// Mirrors a vector along this line such that the point is the same distance
    /// to the line, with a relative angle to its starting point that is the
    /// negative of the current point's angle to the its starting point.
    func mirror(point: Vector) -> Vector

    /// Performs a vector projection of a given vector with respect to this line.
    /// The resulting vector lies within the infinite line formed by extending
    /// `a <-> b`.
    ///
    /// ``project(_:)``
    func projectUnclamped(_ vector: Vector) -> Vector

    /// Returns the result of creating a projection of this line's start point
    /// projected towards this line's end point, with a total magnitude of
    /// `scalar`.
    ///
    /// For `scalar == 0`, returns `self.a`, for `scalar == self.length`,
    /// returns `self.b`.
    ///
    /// - parameter scalar: A non-normalized magnitude that describes the length
    /// along the slope of this line to generate the point out of.
    func projectedMagnitude(_ scalar: Magnitude) -> Vector

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
    func projectedNormalizedMagnitude(_ scalar: Magnitude) -> Vector

    /// Returns `true` if a normalized, projected `scalar` representing a segment
    /// of this line with the same starting point and direction, with
    /// `length = self.length * scalar`, lies within the boundaries of this line.
    ///
    /// For infinite lines, all projected scalars lie within the line, while in
    /// line segments bounded with start/end points, only values laying in (0-1)
    /// are contained on the line.
    func containsProjectedNormalizedMagnitude(_ scalar: Magnitude) -> Bool

    /// Returns a projected normalized magnitude that is guaranteed to be
    /// contained in this line.
    func clampProjectedNormalizedMagnitude(_ scalar: Magnitude) -> Magnitude

    /// Returns the squared distance between this line and a given vector.
    ///
    /// - seealso: ``distance(to:)-9p2y4``
    func distanceSquared(to vector: Vector) -> Vector.Scalar

    /// Returns the distance between this line and a given vector.
    ///
    /// Equivalent to `self.distanceSquared(to: vector).squareRoot()`.
    ///
    /// - seealso: ``distanceSquared(to:)-3wyqd``
    func distance(to vector: Vector) -> Vector.Scalar
}

public extension LineFloatingPoint {
    @inlinable
    func mirror(point: Vector) -> Vector {
        let projected = projectUnclamped(point)
        let result = point + (projected - point) * 2

        return result
    }

    /// Returns the closest point on this line to a given point.
    ///
    /// The point is limited to the line's bounds using
    /// ``clampProjectedNormalizedMagnitude(_:)``, so it's guaranteed to be within
    /// `a <-> b`.
    ///
    /// - seealso: ``projectUnclamped(_:)-7kmi0``
    @inlinable
    func project(_ vector: Vector) -> Vector {
        let proj = projectAsScalar(vector)
        let clampedProj = clampProjectedNormalizedMagnitude(proj)

        return projectedNormalizedMagnitude(clampedProj)
    }

    @inlinable
    func projectUnclamped(_ vector: Vector) -> Vector {
        let proj = projectAsScalar(vector)

        return projectedNormalizedMagnitude(proj)
    }

    @inlinable
    func projectedMagnitude(_ scalar: Magnitude) -> Vector {
        a.addingProduct(lineSlope.normalized(), scalar)
    }

    @inlinable
    func projectedNormalizedMagnitude(_ scalar: Magnitude) -> Vector {
        a.addingProduct(lineSlope, scalar)
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

    @_transparent
    func signedDistance(to point: Vector) -> Vector.Scalar {
        distance(to: point)
    }
}
