/// Protocol for 2D line types where the vectors are floating-point vectors.
public protocol Line2FloatingPoint: LineFloatingPoint & Line2Type {
    /// Returns the result of a line-line intersection with `other`.
    func intersection<Line: Line2FloatingPoint>(with other: Line)
        -> LineIntersectionResult<Vector>? where Line.Vector == Vector
}

public extension Line2FloatingPoint {
    @inlinable
    func intersection<Line: Line2FloatingPoint>(with other: Line) -> LineIntersectionResult<Vector>? where Line.Vector == Vector {
        let denom = ((other.b.y - other.a.y) * (b.x - a.x)) - ((other.b.x - other.a.x) * (b.y - a.y))
        
        if abs(denom) < .leastNonzeroMagnitude {
            return nil
        }
        
        let UaTop = ((other.b.x - other.a.x) * (a.y - other.a.y)) - ((other.b.y - other.a.y) * (a.x - other.a.x))
        let UbTop = ((b.x - a.x) * (a.y - other.a.y)) - ((b.y - a.y) * (a.x - other.a.x))
        
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
