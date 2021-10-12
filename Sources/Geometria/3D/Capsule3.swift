/// Represents a regular 3-dimensional [Capsule] as a pair of end points and a
/// radius with double-precision floating-point numbers.
///
/// [Capsule]: https://en.wikipedia.org/wiki/Capsule_(geometry)
public typealias Capsule3D = Capsule3<Vector3D>

/// Represents a regular 3-dimensional [Capsule] as a pair of end points and a
/// radius with single-precision floating-point numbers.
///
/// [Capsule]: https://en.wikipedia.org/wiki/Capsule_(geometry)
public typealias Capsule3F = Capsule3<Vector3F>

/// Represents a regular 3-dimensional [Capsule] as a pair of end points and a
/// radius with integers.
///
/// [Capsule]: https://en.wikipedia.org/wiki/Capsule_(geometry)
public typealias Capsule3i = Capsule3<Vector3i>

/// Typealias for `NCapsule<V>`, where `V` is constrained to ``Vector3Type``.
public typealias Capsule3<V: Vector3Type> = NCapsule<V>

public extension Capsule3 {
    /// Returns a ``Cylinder3`` with the same ``start``, ``end``, and ``radius``
    /// parameter sas this capsule.
    var asCylinder: Cylinder3<Vector> {
        Cylinder3(start: start, end: end, radius: radius)
    }
}

extension Capsule3: SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    public func signedDistance(to point: Vector) -> Vector.Scalar {
        // Derived from:
        // https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
        let pa = point - start
        let ba = end - start
        let h = clamp(pa.dot(ba) as Scalar / ba.lengthSquared as Scalar, min: 0, max: 1)
        
        return ((pa - (ba * h) as Vector) as Vector).length - radius
    }
}
