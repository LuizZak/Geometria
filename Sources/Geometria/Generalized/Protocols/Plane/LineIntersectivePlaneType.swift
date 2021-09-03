/// Represents a plane type that has support for line-intersection.
public protocol LineIntersectivePlaneType: PointProjectivePlaneType {
    /// Returns the normalized magnitude for a line's intersection point on this
    /// plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, or if
    /// the line is parallel to this plane.
    func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(with line: Line)
        -> Vector.Scalar? where Line.Vector == Vector
    
    /// Returns the result of a line intersection on this plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, or if
    /// the line is parallel to this plane.
    func intersection<Line: LineFloatingPoint>(with line: Line)
        -> Vector? where Line.Vector == Vector
}

public extension LineIntersectivePlaneType {
    @inlinable
    func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(with line: Line) -> Vector.Scalar? where Line.Vector == Vector {
        let denom = normal.dot(line.lineSlope)
        if denom.isApproximatelyEqual(to: 0) {
            return nil
        }
        
        let numer = normal.dot(pointOnPlane - line.a)
        
        return numer / denom
    }
    
    @inlinable
    func intersection<Line: LineFloatingPoint>(with line: Line) -> Vector? where Line.Vector == Vector {
        guard let magnitude = unclampedNormalMagnitudeForIntersection(with: line) else {
            return nil
        }
        
        if line.containsProjectedNormalizedMagnitude(magnitude) {
            return line.projectedNormalizedMagnitude(magnitude)
        }
        
        return nil
    }
}
