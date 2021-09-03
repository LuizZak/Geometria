/// Protocol for 3D line types where the vectors are floating-point vectors.
public protocol Line3FloatingPoint: Line3Type & LineFloatingPoint {
    /// Returns a pair of unclamped, normalized magnitudes, on `self` and
    /// `other`, where the magnitudes when projected on each line result in a
    /// pair of points that form the shortest line between the two original
    /// lines.
    ///
    /// Returns `nil` for parallel lines, and for any line where `a == b`.
    func unclampedNormalizedMagnitudesForShortestLine<Line: Line3FloatingPoint>(to other: Line)
        -> (onSelf: Vector.Scalar, onOther: Vector.Scalar)? where Line.Vector == Vector
    
    /// Returns the shortest line segment between the points of this line to
    /// another 3D line.
    func shortestLine<Line: Line3FloatingPoint>(to other: Line) -> LineSegment<Vector>? where Line.Vector == Vector
}

public extension Line3FloatingPoint {
    @inlinable
    func unclampedNormalizedMagnitudesForShortestLine<Line: Line3FloatingPoint>(to other: Line)
        -> (onSelf: Vector.Scalar, onOther: Vector.Scalar)? where Line.Vector == Vector {
        
        // Algorithm as described in: http://paulbourke.net/geometry/pointlineplane/
        typealias Scalar = Vector.Scalar
        
        // For clarity when referencing points in expressions
        let p1 = self.a
        let p2 = self.b
        let p3 = other.a
        let p4 = other.b
        
        // dmnop = (xm - xn)(xo - xp) + (ym - yn)(yo - yp) + (zm - zn)(zo - zp)
        let p13 = p1 - p3
        let p43 = p4 - p3
        
        let d4343 = p43.dot(p43)
        if d4343.isApproximatelyEqual(to: 0) {
            return nil
        }
        
        let p21 = p2 - p1
        let d2121 = p21.dot(p21)
        if d2121.isApproximatelyEqual(to: 0) {
            return nil
        }
        
        let d1343 = p13.dot(p43)
        let d4321 = p43.dot(p21)
        let d1321 = p13.dot(p21)
        
        // mua = ( d1343 d4321 - d1321 d4343 ) / ( d2121 d4343 - d4321 d4321 )
        let muaDenom: Scalar = ((d1343 * d4321) as Scalar).addingProduct(-d1321, d4343)
        if muaDenom.isApproximatelyEqual(to: 0) {
            return nil
        }
        let muaNumer: Scalar = d2121 * d4343.addingProduct(-d4321, d4321)
        let mua: Scalar = muaDenom / muaNumer
        
        // mub = ( d1343 + mua d4321 ) / d4343
        let mub: Scalar = d1343.addingProduct(mua, d4321) / d4343
        
        return (mua, mub)
    }
    
    @inlinable
    func shortestLine<Line: Line3FloatingPoint>(to other: Line) -> LineSegment<Vector>? where Line.Vector == Vector {
        guard let (mua, mub) = unclampedNormalizedMagnitudesForShortestLine(to: other) else {
            return nil
        }
        
        let clampa = self.clampProjectedNormalizedMagnitude(mua)
        let clampb = other.clampProjectedNormalizedMagnitude(mub)
        
        return LineSegment(
            start: self.projectedNormalizedMagnitude(clampa),
            end: other.projectedNormalizedMagnitude(clampb)
        )
    }
}
