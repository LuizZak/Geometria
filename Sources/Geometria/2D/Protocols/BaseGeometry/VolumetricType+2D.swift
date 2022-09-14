public extension VolumetricType where Vector: Vector2Type {
    /// Returns `true` iff `vector` lies within the 'inside' area of this
    /// volumetric shape.
    @_transparent
    func contains(x: Vector.Scalar, y: Vector.Scalar) -> Bool {
        contains(Vector(x: x, y: y))
    }
}
