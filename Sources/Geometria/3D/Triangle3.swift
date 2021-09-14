/// Represents a 3D triangle as a trio of N-dimensional vectors with
/// double-precision floating-point components.
public typealias Triangle3D = Triangle3<Vector3D>

/// Represents a 3D triangle as a trio of N-dimensional vectors with
/// single-precision floating-point components.
public typealias Triangle3F = Triangle3<Vector3F>

/// Represents a 3D triangle as a trio of N-dimensional vectors with integer
/// components.
public typealias Triangle3i = Triangle3<Vector3i>

/// Typealias for `Triangle<V>`, where `V` is constrained to ``Vector3Type``.
public typealias Triangle3<V: Vector3Type> = Triangle<V>

extension Triangle3: PlaneType where Vector: Vector3FloatingPoint {
    @_transparent
    public var pointOnPlane: Vector { a }
    
    /// Returns normal for this ``Triangle3``. The direction of the normal
    /// depends on the winding of ``a`` -> ``b`` -> ``c``. The normal is always
    /// pointing to the direction where the points form an anti-clockwise winding.
    @_transparent
    public var normal: Vector {
        let ab = a - b
        let ac = a - c
        
        return ab.cross(ac).normalized()
    }
}

extension Triangle3: LineIntersectablePlaneType where Vector: Vector3FloatingPoint {
    /// Returns the plane this ``Triangle3`` forms on 3D space, with the normal
    /// pointing to the winding between ``a`` -> ``b`` -> ``c``.
    @_transparent
    public var asPlane: PointNormalPlane<Vector> {
        .init(point: a, normal: normal)
    }
    
    @usableFromInline
    func normalMagnitude<Line: LineFloatingPoint>(_ line: Line) -> Vector.Scalar? where Line.Vector == Vector {
        let denom = normal.dot(line.lineSlope)
        if abs(denom) <= .leastNonzeroMagnitude {
            return nil
        }
        
        let numer = normal.dot(pointOnPlane - line.a)
        return numer / denom
    }
    
    @usableFromInline
    func containsProjectedPoint(_ vector: Vector) -> Bool {
        let n = normal
        let e0 = b - a
        let e1 = c - b
        let e2 = a - c
        let c0 = vector - a
        let c1 = vector - b
        let c2 = vector - c
        
        guard e0.cross(c0).dot(n) > 0 else {
            return false
        }
        guard e1.cross(c1).dot(n) > 0 else {
            return false
        }
        guard e2.cross(c2).dot(n) > 0 else {
            return false
        }
        
        return true
    }
    
    /// Returns the normalized magnitude for a line's intersection point on this
    /// triangle.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this triangle, or the intersection point is not
    /// within this triangle's area.
    @inlinable
    public func unclampedNormalMagnitudeForIntersection<Line: LineFloatingPoint>(with line: Line)
    -> Vector.Scalar? where Line.Vector == Vector {
        
        guard let magnitude = normalMagnitude(line) else {
            return nil
        }
        
        let point = line.projectedNormalizedMagnitude(magnitude)
        guard containsProjectedPoint(point) else {
            return nil
        }
        
        return magnitude
    }
    
    /// Returns the result of a line intersection on this triangle.
    ///
    /// Result is `nil` if intersection is not within the line's limits, the
    /// line is parallel to this triangle, or the intersection point is not
    /// within this triangle's area.
    @inlinable
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> Vector? where Line.Vector == Vector {
        guard let magnitude = normalMagnitude(line) else {
            return nil
        }
        guard line.containsProjectedNormalizedMagnitude(magnitude) else {
            return nil
        }
        
        let point = line.projectedNormalizedMagnitude(magnitude)
        guard containsProjectedPoint(point) else {
            return nil
        }
        
        return point
    }
}
