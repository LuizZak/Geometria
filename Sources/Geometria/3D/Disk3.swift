/// Represents a 3-dimensional flat disk as a center point, normal, and radius.
///
/// A disk can be interpreted as a clipped plane, where the only points
/// contained within the plane are the ones `<=` ``radius`` distance from the
/// center.
public struct Disk3<Vector: Vector3FloatingPoint>: GeometricType {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// The center point of the disk.
    public var center: Vector
    
    /// The normal of the disk's surface.
    @UnitVector public var normal: Vector
    
    /// The radius of the disk.
    public var radius: Scalar
    
    @_transparent
    public init(center: Vector, normal: Vector, radius: Scalar) {
        self.center = center
        self.normal = normal
        self.radius = radius
    }
}

extension Disk3: Equatable where Vector: Equatable { }
extension Disk3: Hashable where Vector: Hashable { }

extension Disk3: LineIntersectivePlaneType {
    @_transparent
    public var pointOnPlane: Vector { center }
    
    @usableFromInline
    func normalMagnitude<Line: LineFloatingPoint>(_ line: Line) -> Vector.Scalar? where Line.Vector == Vector {
        let denom = normal.dot(line.lineSlope)
        if abs(denom) <= .leastNonzeroMagnitude {
            return nil
        }
        
        let numer = normal.dot(pointOnPlane - line.a)
        return numer / denom
    }
    
    /// Returns the normalized magnitude for a line's intersection point on this
    /// disk.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this disk, or the intersection point is not within
    /// this disk's radius.
    @inlinable
    public func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(with line: Line)
    -> Vector.Scalar? where Line.Vector == Vector {
        
        guard let magnitude = normalMagnitude(line) else {
            return nil
        }
        
        let point = line.projectedNormalizedMagnitude(magnitude)
        if point.distanceSquared(to: center) > radius * radius {
            return nil
        }
        
        return magnitude
    }
    
    /// Returns the result of a line intersection on this disk.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this disk, or the intersection point is not within
    /// this disk's radius.
    @inlinable
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> Vector? where Line.Vector == Vector {
        guard let magnitude = normalMagnitude(line) else {
            return nil
        }
        guard line.containsProjectedNormalizedMagnitude(magnitude) else {
            return nil
        }
        
        let point = line.projectedNormalizedMagnitude(magnitude)
        guard point.distanceSquared(to: center) <= radius * radius else {
            return nil
        }
        
        return point
    }
}
