/// Protocol for 2D line types where the vectors are floating-point vectors.
public protocol Line2FloatingPoint: LineFloatingPoint & Line2Type {
    /// Returns the result of a line-line intersection with `other`.
    func intersection<Line: Line2FloatingPoint>(with other: Line)
        -> LineIntersectionResult<Vector>? where Line.Vector == Vector
}

public extension Line2FloatingPoint {
    @inlinable
    func intersection<Line: Line2FloatingPoint>(with other: Line) -> LineIntersectionResult<Vector>? where Line.Vector == Vector {
        let otherA = other.a
        let otherB = other.b
        
        let denomHalf = (b.x - a.x) * (otherB.y - otherA.y)
        let denom = denomHalf - (((b.y - a.y) as Vector.Scalar) * (otherB.x - otherA.x))
        
        if abs(denom) < .leastNonzeroMagnitude {
            return nil
        }
        
        let UaTopHalf = (other.b.x - otherA.x) * (a.y - otherA.y)
        let UaTop = UaTopHalf - (((otherB.y - otherA.y) as Vector.Scalar) * (a.x - otherA.x))
        let UbTopHalf = (((b.x - a.x) as Vector.Scalar) * (a.y - otherA.y))
        let UbTop = UbTopHalf - (((b.y - a.y) as Vector.Scalar) * (a.x - otherA.x))
        
        let Ua = UaTop / denom
        let Ub = UbTop / denom
        
        if self.containsProjectedNormalizedMagnitude(Ua) && other.containsProjectedNormalizedMagnitude(Ub) {
            let hitPt = a + ((b - a) * Ua)
            
            return LineIntersectionResult(
                point: hitPt,
                line1NormalizedMagnitude: Ua,
                line2NormalizedMagnitude: Ub
            )
        }
        
        return nil
    }
}
