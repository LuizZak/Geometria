/// Represents a 3D line as a pair of double-precision floating-point start and
/// end vectors.
public typealias Line3D = Line<Vector3D>

/// Represents a 3D line as a pair of single-precision floating-point start and
/// end vectors.
public typealias Line3F = Line<Vector2F>

/// Represents a 3D line as a pair of integer start and end vectors.
public typealias Line3i = Line<Vector2i>

public extension Line where Vector: Vector3Type {
    @_transparent
    init(x1: Scalar, y1: Scalar, z1: Scalar, x2: Scalar, y2: Scalar, z2: Scalar) {
        start = Vector(x: x1, y: y1, z: z1)
        end = Vector(x: x2, y: y2, z: z2)
    }
}
