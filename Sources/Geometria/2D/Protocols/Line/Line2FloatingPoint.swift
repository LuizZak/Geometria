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
        
        let otherA = other.a
        let otherB = other.b
        
        let denomHalf: Scalar = (b.x - a.x) * (otherB.y - otherA.y)
        let denom: Scalar = denomHalf - ((b.y - a.y) as Scalar * (otherB.x - otherA.x) as Scalar)
        
        if abs(denom) < .leastNonzeroMagnitude {
            return nil
        }
        
        let UaTopHalf: Scalar = (other.b.x - otherA.x) as Scalar * (a.y - otherA.y)
        let UaTop: Scalar = UaTopHalf - ((otherB.y - otherA.y) as Scalar * (a.x - otherA.x))
        
        let UbTopHalf: Scalar = (b.x - a.x) as Scalar * (a.y - otherA.y)
        let UbTop: Scalar = UbTopHalf - ((b.y - a.y) as Scalar * (a.x - otherA.x))
        
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
