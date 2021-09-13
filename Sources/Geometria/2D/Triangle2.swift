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
        return signedDoubleArea / 2
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
}
