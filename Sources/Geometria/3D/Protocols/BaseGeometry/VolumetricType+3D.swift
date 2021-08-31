public extension VolumetricType where Vector: Vector3Type {
    /// Returns `true` iff `vector` lies within the 'inside' volume of this
    /// volumetric shape.
    @_transparent
    func contains(x: Vector.Scalar, y: Vector.Scalar, z: Vector.Scalar) -> Bool {
        contains(.init(x: x, y: y, z: z))
    }
}
