/// Represents a 3D plane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
public typealias Plane3D = Plane3<Vector3D>

/// Represents a 3D plane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
public typealias Plane3F = Plane3<Vector3F>

/// Typealias for `Plane<V>`, where `V` is constrained to `Vector3FloatingPoint`.
public typealias Plane3<V: Vector3FloatingPoint> = Plane<V>
