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
        
        let slope: Vector = lineSlope
        let slopeOther: Vector = other.lineSlope
        
        let denom: Scalar = slope.cross(slopeOther)
        if abs(denom) < Scalar.leastNonzeroMagnitude {
            return nil
        }
        
        let startDiff: Vector = a - other.a
        
        let ua: Scalar = slopeOther.cross(startDiff) / denom
        guard self.containsProjectedNormalizedMagnitude(ua) else {
            return nil
        }
        
        let ub: Scalar = slope.cross(startDiff) / denom
        guard other.containsProjectedNormalizedMagnitude(ub) else {
            return nil
        }
        
        let hitPt: Vector = projectedNormalizedMagnitude(ua)
        
        return LineIntersectionResult(
            point: hitPt,
            line1NormalizedMagnitude: ua,
            line2NormalizedMagnitude: ub
        )
    }
}
