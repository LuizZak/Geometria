/// Protocol for 3D vector types with additive scalars.
public protocol Vector3Additive: Vector3Type, VectorAdditive where SubVector2: Vector2Additive, SubVector4: Vector4Additive {
    /// Creates a new vector with the coordinates of a given ``Vector2Type``,
    /// and 0 on the ``z`` axis.
    init<V: Vector2Type>(_ vec: V) where V.Scalar == Scalar
}

public extension Vector3Additive {
    /// Creates a new vector with the coordinates of a given ``Vector2Type``,
    /// and 0 on the ``z`` axis.
    @_transparent
    init<V: Vector2Type>(_ vec: V) where V.Scalar == Scalar {
        self.init(vec, z: .zero)
    }
}
