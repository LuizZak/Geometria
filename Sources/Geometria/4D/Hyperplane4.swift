/// Represents a 4D hyperplane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 4 dimensions, a hyperplane consists of a 3D surface splitting the 4D space
/// into two.
public typealias Hyperplane4D = Hyperplane4<Vector4D>

/// Represents a 4D hyperplane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 4 dimensions, a hyperplane consists of a 3D surface splitting the 4D space
/// into two.
public typealias Hyperplane4F = Hyperplane4<Vector4F>

/// Typealias for `Hyperplane<V>`, where `V` is constrained to ``Vector4FloatingPoint``.
///
/// In 4 dimensions, a hyperplane consists of a 3D surface splitting the 4D space
/// into two.
public typealias Hyperplane4<V: Vector4FloatingPoint> = Hyperplane<V>
