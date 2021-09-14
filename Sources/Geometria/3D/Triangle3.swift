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
        let n = normal
        let denom = n.dot(line.lineSlope)
        if abs(denom) <= .leastNonzeroMagnitude {
            return nil
        }
        
        let numer = n.dot(pointOnPlane - line.a)
        return numer / denom
    }
    
    @usableFromInline
    func containsProjectedPoint(_ vector: Vector) -> Bool {
        let bary = toBarycentric(vector)
        guard bary.wa >= 0, bary.wb >= 0, bary.wc >= 0 else {
            return false
        }
        
        return (bary.wa + bary.wb + bary.wc) <= 1
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
    
    // TODO: Unit test these methods separately.
    
    /// Performs a projection of a given set of coordinates onto this triangle
    /// as a set of barycentric coordinates.
    @_transparent
    public func toBarycentric(x: Scalar, y: Scalar, z: Scalar) -> Coordinates {
        toBarycentric(.init(x: x, y: y, z: z))
    }
    
    /// Performs a projection of a given vector onto this triangle as a set of
    /// barycentric coordinates.
    ///
    /// The resulting coordinates might have scalar values `< .zero`, indicating
    /// points that projected outside the area of the triangle.
    ///
    /// The method assumes `vector` is [coplanar] with ``a``, ``b``, and ``c``.
    ///
    /// [coplanar]: https://en.wikipedia.org/wiki/Coplanarity
    @inlinable
    public func toBarycentric(_ vector: Vector) -> Coordinates {
        let ba = b - a
        let ca = c - a
        let n = ba.cross(ca)
        
        let denom = n.dot(n)
        
        // a
        let e0 = c - b
        let c0 = vector - b
        
        let wa = n.dot(e0.cross(c0)) / denom
        
        // b
        let e1 = a - c
        let c1 = vector - c
        
        let wb = n.dot(e1.cross(c1)) / denom
        
        return Coordinates(
            wa: wa,
            wb: wb,
            wc: 1 - wa - wb
        )
    }
}
