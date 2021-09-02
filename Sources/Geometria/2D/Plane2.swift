/// Represents a 2D plane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
public typealias Plane2D = Plane2<Vector2D>

/// Represents a 2D plane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
public typealias Plane2F = Plane2<Vector2F>

/// Typealias for `Plane<V>`, where `V` is constrained to `Vector2FloatingPoint`.
public typealias Plane2<V: Vector2FloatingPoint> = Plane<V>
