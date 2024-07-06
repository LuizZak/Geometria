/// Represents a 2D triangle as a trio of N-dimensional vectors with
/// double-precision floating-point components.
public typealias Triangle2D = Triangle2<Vector2D>

/// Represents a 2D triangle as a trio of N-dimensional vectors with
/// single-precision floating-point components.
public typealias Triangle2F = Triangle2<Vector2F>

/// Represents a 2D triangle as a trio of N-dimensional vectors with integer
/// components.
public typealias Triangle2i = Triangle2<Vector2i>

/// Typealias for `Triangle<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Triangle2<V: Vector2Type> = Triangle<V>

public extension Triangle2 where Vector: Vector2Multiplicative {
    /// Returns a unit triangle where ``a``, ``b``, and ``c`` take the following
    /// values:
    ///
    /// ```swift
    /// a = Vector(x: 0, y: 0)
    /// b = Vector(x: 1, y: 0)
    /// c = Vector(x: 0, y: 1)
    /// ```
    @_transparent
    static var unitTriangle: Self {
        .init(a: .init(x: .zero, y: .zero),
              b: .init(x: 1, y: .zero),
              c: .init(x: .zero, y: 1))
    }

    /// Returns the signed doubled area of this triangle.
    ///
    /// The triangle has a negative signed area if the parallelogram formed by
    /// the edge vectors `CA` and `BA` are counter-clockwise (in Cartesian space
    /// where Y grows positively up).
    ///
    /// For a 2D triangle, the doubled area is computed as the cross-product of
    /// `CA` and `BA`:
    ///
    /// ```swift
    /// (c.x − a.x) * (b.y − a.y) - (c.y − a.y) * (b.x − a.x)
    /// ```
    ///
    /// - seealso: ``signedArea``
    @_transparent
    var signedDoubleArea: Scalar {
        let ca = c - a
        let ba = b - a

        return ca.cross(ba)
    }
}

public extension Triangle2 where Vector: Vector2Multiplicative & VectorDivisible {
    /// Returns the signed area of this triangle.
    ///
    /// The triangle has a negative signed area if the parallelogram formed by
    /// the edge vectors `CA` and `BA` are counter-clockwise (in Cartesian space
    /// where Y grows positively up).
    ///
    /// For a 2D triangle, the area is computed as half of the cross-product of
    /// `CA` and `BA`:
    ///
    /// ```swift
    /// ((c.x − a.x) * (b.y − a.y) - (c.y − a.y) * (b.x − a.x)) / 2
    /// ```
    ///
    /// - seealso: ``signedDoubleArea``
    @_transparent
    var signedArea: Scalar {
        signedDoubleArea / 2
    }
}

public extension Triangle2 where Vector: Vector2Multiplicative & VectorDivisible & VectorSigned {
    /// Returns the signed value of this triangle's winding.
    ///
    /// In Cartesian space where Y grows positively up, the winding is `-1` for
    /// clockwise windings and `-1` for counter-clockwise windings.
    ///
    /// If the area of this triangle is `== .zerp`, `0` is returned, instead.
    @_transparent
    var winding: Scalar {
        let a = signedDoubleArea

        return a == .zero ? .zero : (a < .zero ? -1 : 1)
    }
}

extension Triangle2: VolumetricType where Vector: Vector2FloatingPoint {
    /// Returns whether the given point vector is contained within this triangle.
    ///
    /// Points at the perimeter of the triangle, as well as the points forming
    /// the corners of the triangle, are considered as contained within the
    /// triangle (inclusive).
    ///
    /// Triangles where ``signedDoubleArea`` `== .zero` cannot contain points
    /// and return `false` for any containment check.
    ///
    /// This function is well-defined for ``signedDoubleArea`` of both negative
    /// and positive values.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        let sign = winding

        guard sign != 0 else {
            return false
        }
        guard Triangle(a: a, b: b, c: vector).signedDoubleArea * sign >= 0 else {
            return false
        }
        guard Triangle(a: b, b: c, c: vector).signedDoubleArea * sign >= 0 else {
            return false
        }
        guard Triangle(a: c, b: a, c: vector).signedDoubleArea * sign >= 0 else {
            return false
        }

        return true
    }

    /// Performs a projection of a given set of coordinates onto this triangle
    /// as a set of barycentric coordinates.
    @_transparent
    public func toBarycentric(x: Scalar, y: Scalar) -> Coordinates {
        toBarycentric(.init(x: x, y: y))
    }

    /// Performs a projection of a given vector onto this triangle as a set of
    /// barycentric coordinates.
    ///
    /// The resulting coordinates might have scalar values `< .zero`, indicating
    /// points that projected outside the area of the triangle.
    @inlinable
    public func toBarycentric(_ vector: Vector) -> Coordinates {
        let sArea = signedDoubleArea
        if sArea == .zero {
            return .zero
        }

        let wa = Triangle(a: b, b: c, c: vector).signedDoubleArea / sArea
        let wb = Triangle(a: c, b: a, c: vector).signedDoubleArea / sArea
        let wc = 1 - wa - wb

        return Coordinates(
            wa: wa,
            wb: wb,
            wc: wc
        )
    }
}

extension Triangle2: Convex2Type where Vector: Vector2FloatingPoint {
    // TODO: Find a more properly optimized line-triangle intersection algorithm.

    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// 2D triangle's outer perimeter.
    public func intersection<Line>(with line: Line) -> ConvexLineIntersection<Vector> where Line : Line2FloatingPoint, Vector == Line.Vector {
        var minUA: Scalar = .infinity
        var minNorm: Vector = .zero

        var maxUA: Scalar = -.infinity
        var maxNorm: Vector = .zero

        func processEdge(_ l: LineSegment<Vector>) {
            guard let inters = line.intersection(with: l) else {
                return
            }

            let edgeSlope = l.lineSlope
            let lineSlope = line.lineSlope

            // Use the edge line slope direction that minimizes the dot product
            // against the query line (aka use the edge normal that points in the
            // opposite direction of the line).
            let norm: Vector
            if edgeSlope.leftRotated().dot(lineSlope) < edgeSlope.rightRotated().dot(lineSlope) {
                norm = edgeSlope.leftRotated()
            } else {
                norm = edgeSlope.rightRotated()
            }

            minUA = Scalar.minimum(minUA, inters.line1NormalizedMagnitude)
            minNorm = norm

            maxUA = Scalar.maximum(maxUA, inters.line1NormalizedMagnitude)
            maxNorm = norm
        }

        processEdge(lineAB)
        processEdge(lineBC)
        processEdge(lineCA)

        let pnEnter: LineIntersectionPointNormal<Vector>?
        let pnExit: LineIntersectionPointNormal<Vector>?

        if minUA < .infinity {
            pnEnter = LineIntersectionPointNormal(
                normalizedMagnitude: minUA,
                point: line.projectedNormalizedMagnitude(minUA),
                normal: minNorm.normalized()
            )
        } else {
            pnEnter = nil
        }

        if maxUA > -.infinity {
            pnExit = LineIntersectionPointNormal(
                normalizedMagnitude: maxUA,
                point: line.projectedNormalizedMagnitude(maxUA),
                normal: maxNorm.normalized()
            )
        } else {
            pnExit = nil
        }

        switch (pnEnter, pnExit) {
        // Single-point: Enter, exit, or single-point
        case let (en?, ex?) where en.point == ex.point:
            if contains(line.a) {
                return .exit(en)
            }
            if contains(line.b) {
                return .enter(en)
            }

            return .singlePoint(en)

        // Dual-point: enter-exit
        case let (en?, ex?):
            return .enterExit(en, ex)

        // No intersection, or full containment
        case (nil, nil):
            if contains(line.a) && contains(line.b) {
                return .contained
            }

            return .noIntersection
        default:
            return .noIntersection
        }
    }
}
