/// Represents a double-precision floating-point 3D cube.
public typealias Cube3D = NSquare<Vector3D>

/// Represents a single-precision floating-point 3D cube.
public typealias Cube3F = NSquare<Vector3F>

/// Represents an integer 3D cube.
public typealias Cube3i = NSquare<Vector3i>

public extension NSquare where Vector: Vector3Type {
    @_transparent
    init(x: Scalar, y: Scalar, z: Scalar, sideLength: Scalar) {
        self.init(origin: .init(x: x, y: y, z: z), sideLength: sideLength)
    }
}
