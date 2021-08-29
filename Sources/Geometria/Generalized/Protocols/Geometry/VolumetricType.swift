/// Protocol for geometric types that have an internal volumetric area that can
/// be queried with Vectors for containment checks.
public protocol VolumetricType: GeometricType {
    associatedtype Vector: VectorComparable
    
    /// Returns `true` iff `vector` lies within the 'inside' area of this
    /// volumetric shape.
    func contains(_ vector: Vector) -> Bool
}

// TODO: Move these extensions 2D/3D folders

public extension VolumetricType where Vector: Vector2Type {
    /// Returns `true` iff `vector` lies within the 'inside' area of this
    /// volumetric shape.
    @_transparent
    func contains(x: Vector.Scalar, y: Vector.Scalar) -> Bool {
        contains(.init(x: x, y: y))
    }
}

public extension VolumetricType where Vector: Vector3Type {
    /// Returns `true` iff `vector` lies within the 'inside' area of this
    /// volumetric shape.
    @_transparent
    func contains(x: Vector.Scalar, y: Vector.Scalar, z: Vector.Scalar) -> Bool {
        contains(.init(x: x, y: y, z: z))
    }
}
