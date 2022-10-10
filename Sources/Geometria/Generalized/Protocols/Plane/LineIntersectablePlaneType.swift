/// Represents a plane type that has support for line-intersection.
public protocol LineIntersectablePlaneType: PlaneType {
    /// Returns the normalized magnitude for a line's intersection point on this
    /// plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this plane, or this plane is a finite plane and the
    /// line does not cross its bounded area.
    func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(
        with line: Line
    ) -> Vector.Scalar? where Line.Vector == Vector
    
    /// Returns the result of a line intersection on this plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this plane, or this plane is a finite plane and the
    /// line does not cross its bounded area.
    func intersection<Line: LineFloatingPoint>(
        with line: Line
    ) -> Vector? where Line.Vector == Vector
}

public extension LineIntersectablePlaneType {
    @inlinable
    func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(
        with line: Line
    ) -> Vector.Scalar? where Line.Vector == Vector {

        let denom = normal.dot(line.lineSlope)
        if abs(denom) < .leastNonzeroMagnitude {
            return nil
        }
        
        let numer = normal.dot(pointOnPlane - line.a)
        
        return numer / denom
    }
    
    @inlinable
    func intersection<Line: LineFloatingPoint>(
        with line: Line
    ) -> Vector? where Line.Vector == Vector {
        
        guard let magnitude = unclampedNormalMagnitudeForIntersection(with: line) else {
            return nil
        }
        
        if line.containsProjectedNormalizedMagnitude(magnitude) {
            return line.projectedNormalizedMagnitude(magnitude)
        }
        
        return nil
    }
}
