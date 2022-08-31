/// Protocol for objects that form geometric lines with two floating-point
/// vectors representing two points on the line.
public protocol LineFloatingPoint: LineDivisible, PointProjectableType, SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    /// Gets the normalized slope of this line, i.e. the direction from `a -> b`.
    var normalizedLineSlope: Vector { get }

    /// Returns a generalized ``IntervalLine`` representation of this line.
    var asIntervalLine: IntervalLine<Vector> { get }

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
    
    /// Clamps a given projected normalized magnitude to the closest magnitude 
    /// that is guaranteed to be contained in this line.
    func clampProjectedNormalizedMagnitude(_ scalar: Magnitude) -> Magnitude

    /// Returns an interval line representation of this line that is clamped such
    /// that its end points are limited to the given minimal and maximal normalized
    /// magnitudes relative to this line.
    ///
    /// Providing a minimal magnitude of `-Magnitude.infinity` or maximal
    /// magnitude of `Magnitude.infinity` indicates that those ends of the line
    /// should not be capped at all.
    ///
    /// Clamping the line with both magnitudes as their respective identity signed
    /// infinities results in the same output as ``asIntervalLine``.
    ///
    /// - note: If `minimumNormalizedMagnitude <= maximumNormalizedMagnitude`,
    /// the resulting interval line will be considered [degenerate].
    ///
    /// [degenerate]: https://en.wikipedia.org/wiki/Degeneracy_(mathematics)
    func clampedAsIntervalLine(
        minimumNormalizedMagnitude minimum: Magnitude,
        maximumNormalizedMagnitude maximum: Magnitude
    ) -> IntervalLine<Vector>
    
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
    var normalizedLineSlope: Vector {
        (b - a).normalized()
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
        a.addingProduct(normalizedLineSlope, scalar)
    }
    
    @inlinable
    func projectedNormalizedMagnitude(_ scalar: Magnitude) -> Vector {
        a.addingProduct(lineSlope, scalar)
    }

    @inlinable
    func clampedAsIntervalLine(
        minimumNormalizedMagnitude minimum: Magnitude,
        maximumNormalizedMagnitude maximum: Magnitude
    ) -> IntervalLine<Vector> {
        
        switch (minimum.isFinite, maximum.isFinite) {
        case (false, false):
            return asIntervalLine

        case (true, true), (true, false), (false, true):
            let clampedStart = clampProjectedNormalizedMagnitude(minimum)
            let clampedEnd = clampProjectedNormalizedMagnitude(maximum)

            if category == .lineSegment && clampedStart == .zero && clampedEnd == 1 {
                return asIntervalLine
            }

            let slopeLength = lineSlope.length
            
            return IntervalLine(
                pointOnLine: a,
                direction: normalizedLineSlope,
                minimumMagnitude: clampedStart * slopeLength,
                maximumMagnitude: clampedEnd * slopeLength
            )
        }
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
