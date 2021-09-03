/// Represents a 3D sphere with a double-precision floating-point center point
/// and radius parameters.
public typealias Sphere3D = Sphere3<Vector3D>

/// Represents a 3D sphere with a single-precision floating-point center point
/// and radius parameters.
public typealias Sphere3F = Sphere3<Vector3F>

/// Typealias for `NSphere<V>`, where `V` is constrained to `Vector3Type`.
public typealias Sphere3<V: Vector3Type> = NSphere<V>
