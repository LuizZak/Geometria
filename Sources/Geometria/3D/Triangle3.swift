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

public extension Triangle3 where Vector: Vector3FloatingPoint {
    /// Returns normal for this ``Triangle3``. The direction of the normal
    /// depends on the winding of ``a`` -> ``b`` -> ``c``. The normal is always
    /// pointing to the direction where the points form an anti-clockwise winding.
    @_transparent
    var normal: Vector {
        let ab = a - b
        let ac = a - c
        
        return ab.cross(ac).normalized()
    }
    
    /// Returns the plane this ``Triangle3`` forms on 3D space, with the normal
    /// pointing to the winding between ``a`` -> ``b`` -> ``c``.
    @_transparent
    var asPlane: PointNormalPlane<Vector> {
        .init(point: a, normal: normal)
    }
}
