/// Represents an infinite plane with a point and a normal.
///
/// In 2D, a plane equates to a line, while in 3D and higher dimensions it
/// equates to a flat 2D plane.
public struct PointNormalPlane<Vector: VectorFloatingPoint>: CustomStringConvertible {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    public var description: String {
        "PointNormalPlane(point: \(point), normal: \(normal))"
    }
    
    /// A point on this plane.
    public var point: Vector
    
    /// The normal of the plane's surface.
    @UnitVector public var normal: Vector
    
    @_transparent
    public init(point: Vector, normal: Vector) {
        self.point = point
        self.normal = normal
    }
}

public extension PointNormalPlane {
    /// Returns a ``PointNormal`` value initialized with this plane's parameters.
    @_transparent
    var asPointNormal: PointNormal<Vector> {
        return PointNormal(point: point, normal: normal)
    }
    
    /// Returns the normalized magnitude for a line's intersection point on this
    /// plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, or if
    /// the line is parallel to this plane.
    func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(with line: Line) -> Scalar? where Line.Vector == Vector {
        let denom = normal.dot(line.lineSlope)
        if denom.isApproximatelyEqual(to: 0) {
            return nil
        }
        
        let numer = normal.dot(point - line.a)
        
        return numer / denom
    }
    
    /// Returns the result of a line intersection on this plane.
    ///
    /// Result is `nil` if intersection is not within the line's limits, or if
    /// the line is parallel to this plane.
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

extension PointNormalPlane: PointProjectiveType {
    /// Returns the signed distance of a given point to this plane.
    ///
    /// By offsetting the point by -(signed distance x ``normal``), the
    /// projected point on the plane is retrieved.
    @inlinable
    public func signedDistance(to vector: Vector) -> Scalar {
        let v = vector - point
        return v.dot(normal)
    }
    
    /// Projects a given vector on this plane.
    ///
    /// Returns the closest point on this plane to `vector`.
    @inlinable
    public func project(_ vector: Vector) -> Vector {
        let d = signedDistance(to: vector)
        
        return vector.addingProduct(-d, normal)
    }
}
