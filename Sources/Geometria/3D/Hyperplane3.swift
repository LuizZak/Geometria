/// Represents a 3D hyperplane as a pair of double-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3D = Hyperplane3<Vector3D>

/// Represents a 3D hyperplane as a pair of single-precision floating-point vectors
/// describing a point on the plane and the plane's normal.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3F = Hyperplane3<Vector3F>

/// Typealias for `Hyperplane<V>`, where `V` is constrained to ``Vector3FloatingPoint``.
///
/// In 3 dimensions, a hyperplane consists of a 2D surface splitting the 3D space
/// into two.
public typealias Hyperplane3<V: Vector3FloatingPoint> = Hyperplane<V>

extension Hyperplane3: PlaneIntersectablePlane3Type {
    
}

extension Hyperplane3: Convex3Type {
    
}
