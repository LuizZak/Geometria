/// Protocol for 2D line types where the vectors are floating-point vectors.
public protocol Line2FloatingPoint: LineFloatingPoint & Line2Type where Vector: Vector2FloatingPoint {
    /// Returns the result of a line-line intersection with `other`.
    func intersection<Line: Line2FloatingPoint>(with other: Line)
        -> LineIntersectionResult<Vector>? where Line.Vector == Vector
}

public extension Line2FloatingPoint {
    @inlinable
    func intersection<Line: Line2FloatingPoint>(with other: Line) -> LineIntersectionResult<Vector>? where Line.Vector == Vector {
        typealias Scalar = Vector.Scalar
        
        let slope = lineSlope
        let slopeOther = other.lineSlope
        
        let denom = slope.cross(slopeOther)
        
        if denom.isApproximatelyEqual(to: 0) {
            return nil
        }
        
        let startDiff = a - other.a
        
        let Ua = slopeOther.cross(startDiff) / denom
        guard self.containsProjectedNormalizedMagnitude(Ua) else {
            return nil
        }
        
        let Ub = slope.cross(startDiff) / denom
        guard other.containsProjectedNormalizedMagnitude(Ub) else {
            return nil
        }
        
        let hitPt = projectedNormalizedMagnitude(Ua)
        
        return LineIntersectionResult(
            point: hitPt,
            line1NormalizedMagnitude: Ua,
            line2NormalizedMagnitude: Ub
        )
    }
}
