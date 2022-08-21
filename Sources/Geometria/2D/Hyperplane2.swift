/// Represents a 2D hyperplane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 2 dimensions, a hyperplane consists of a 1D line splitting the 2D space
/// into two.
public typealias Hyperplane2D = Hyperplane2<Vector2D>

/// Represents a 2D hyperplane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 2 dimensions, a hyperplane consists of a 1D line splitting the 2D space
/// into two.
public typealias Hyperplane2F = Hyperplane2<Vector2F>

/// Typealias for `Hyperplane<V>`, where `V` is constrained to ``Vector2FloatingPoint``.
///
/// In 2 dimensions, a hyperplane consists of a 1D line splitting the 2D space
/// into two.
public typealias Hyperplane2<V: Vector2FloatingPoint> = Hyperplane<V>
