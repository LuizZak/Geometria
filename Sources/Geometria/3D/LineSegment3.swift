/// Represents a 3D line as a pair of double-precision floating-point start and
/// end vectors.
public typealias LineSegment3D = LineSegment3<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point start and
/// end vectors.
public typealias LineSegment3F = LineSegment3<Vector3F>

/// Represents a 3D line as a pair of integer start and end vectors.
public typealias LineSegment3i = LineSegment3<Vector3i>

/// Typealias for `LineSegment<V>`, where `V` is constrained to `Vector3Type`.
public typealias LineSegment3<V: Vector3Type> = LineSegment<V>

extension LineSegment3: Line3Type {
    @_transparent
    public init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        start = Vector(x: x1, y: y1, z: z1)
        end = Vector(x: x2, y: y2, z: z2)
    }
}

extension LineSegment3: Line3FloatingPoint where Vector: Vector3Type & VectorFloatingPoint {
    
}
