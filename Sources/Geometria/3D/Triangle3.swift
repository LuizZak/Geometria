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

public extension Triangle3 where Vector: Vector3Multiplicative {
    /// Returns the cross product of the edges `BA` and `CA` on this triangle.
    ///
    /// The resulting cross vector can be used to compute the area of the
    /// triangle, its normal, and its winding.
    ///
    /// For a 3D triangle, the cossed area is computed as the cross-product of
    /// `BA` and `CA`:
    ///
    /// ```swift
    /// let ba = b - a
    /// let ca = c - a
    ///
    /// return ba.cross(ca)
    /// ```
    ///
    /// - seealso: ``signedArea``
    @_transparent
    var crossedArea: Vector {
        let ba = b - a
        let ca = c - a
        
        return ba.cross(ca)
    }
}

extension Triangle3: PlaneType where Vector: Vector3FloatingPoint {
    @_transparent
    public var pointOnPlane: Vector { a }
    
    /// Returns normal for this ``Triangle3``. The direction of the normal
    /// depends on the winding of ``a`` -> ``b`` -> ``c``. The normal is always
    /// pointing to the direction where the points form an anti-clockwise winding.
    @_transparent
    public var normal: Vector {
        crossedArea.normalized()
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
    
    /// Performs [Möller-Trumbore intersection algorithm] against a line.
    /// Returns scalars for the line's magnitude, and [barycentric coordinates]
    /// for the triangle's position on the intersection.
    ///
    /// Intersections that happen outside the line's range (see
    /// ``LineFloatingPoint/containsProjectedNormalizedMagnitude(_:)``) return
    /// `nil`, instead.
    ///
    /// [Möller-Trumbore intersection algorithm]: https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm
    /// [barycentric coordinates]: https://en.wikipedia.org/wiki/Barycentric_coordinate_system#Barycentric_coordinates_on_triangles
    @inlinable
    public func mollerTrumboreIntersect<Line: LineFloatingPoint>(with line: Line) -> (lineMagnitude: Scalar, Coordinates)? where Line.Vector == Vector {
        let orig = line.a
        let slope = line.lineSlope
        let dir = slope.normalized()
        
        let v0v1 = b - a
        let v0v2 = c - a
        let pvec = dir.cross(v0v2)
        let det = v0v1.dot(pvec)
        
        if abs(det) < .leastNonzeroMagnitude {
            return nil
        }
        
        let invDet: Scalar = 1 / det
        
        let tvec = orig - a
        let u: Scalar = tvec.dot(pvec) * invDet
        if u < 0 || u > 1 {
            return nil
        }
        
        let qvec = tvec.cross(v0v1)
        let v: Scalar = dir.dot(qvec) * invDet
        if v < 0 || u + v > 1 {
            return nil
        }
        
        let magnitude: Scalar = (v0v2.dot(qvec) * invDet) / slope.length
        if !line.containsProjectedNormalizedMagnitude(magnitude) {
            return nil
        }
        
        return (magnitude, Coordinates(wa: 1 - u - v, wb: u, wc: v))
    }
    
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
        let n = crossedArea
        let denom = n.dot(n)
        
        // a
        let wav = Triangle3(a: b, b: c, c: vector)
        let wa = n.dot(wav.crossedArea) / denom
        
        // b
        let wbv = Triangle3(a: c, b: a, c: vector)
        let wb = n.dot(wbv.crossedArea) / denom
        
        return Coordinates(
            wa: wa,
            wb: wb,
            wc: 1 - wa - wb
        )
    }
}
