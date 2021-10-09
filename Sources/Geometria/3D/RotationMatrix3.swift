import RealModule

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix)
/// with double-precision floating-point components.
public typealias RotationMatrix3D = RotationMatrix3<Double>

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix)
/// with single-precision floating-point components.
public typealias RotationMatrix3F = RotationMatrix3<Float>

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix).
public typealias RotationMatrix3<Scalar: Real & DivisibleArithmetic> = Matrix3x3<Scalar>

public extension RotationMatrix3 {
    /// Creates a 3-dimensional [rotation matrix] from a set of rotations around
    /// three axis.
    ///
    /// The [orientation] (handedness) provided affects how angles are interpreted
    /// as rotations around each axis.
    /// 
    /// - Parameters:
    /// - order: The order of the axis of rotations that the three angles
    /// will be interpreted as.
    /// - orientation: The [handedness] of the system. Right-handed systems
    /// rotate about the axis in a counter-clockwise direction for positive angles,
    /// while left-handed systems rotate clockwise with the same positive angles.
    /// - angle1InRadians: The first angle of the rotation in radians.
    /// - angle2InRadians: The second angle of the rotation in radians.
    /// - angle3InRadians: The third angle of the rotation in radians.
    ///
    /// - Returns: A rotation matrix that can be used to rotate a vector in 3-space
    /// according to the parameters specified.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotation(order: RotationOrder3,
                               orientation: Orientation3,
                               _ angle1InRadians: Scalar,
                               _ angle2InRadians: Scalar,
                               _ angle3InRadians: Scalar) -> Self {
        
        let r1: Self
        let r2: Self
        let r3: Self

        let rotX = make3DRotationX
        let rotY = make3DRotationY
        let rotZ = make3DRotationZ

        switch order {
        case .xyz:
            r1 = rotX(orientation, angle1InRadians)
            r2 = rotY(orientation, angle2InRadians)
            r3 = rotZ(orientation, angle3InRadians)

        case .xzy:
            r1 = rotX(orientation, angle1InRadians)
            r2 = rotZ(orientation, angle2InRadians)
            r3 = rotY(orientation, angle3InRadians)

        case .yxz:
            r1 = rotY(orientation, angle1InRadians)
            r2 = rotX(orientation, angle2InRadians)
            r3 = rotZ(orientation, angle3InRadians)

        case .yzx:
            r1 = rotY(orientation, angle1InRadians)
            r2 = rotZ(orientation, angle2InRadians)
            r3 = rotX(orientation, angle3InRadians)

        case .zyx:
            r1 = rotZ(orientation, angle1InRadians)
            r2 = rotY(orientation, angle2InRadians)
            r3 = rotX(orientation, angle3InRadians)

        case .zxy:
            r1 = rotZ(orientation, angle1InRadians)
            r2 = rotX(orientation, angle2InRadians)
            r3 = rotY(orientation, angle3InRadians)

        case .zxz:
            r1 = rotZ(orientation, angle1InRadians)
            r2 = rotX(orientation, angle2InRadians)
            r3 = rotZ(orientation, angle3InRadians)

        case .xzx:
            r1 = rotX(orientation, angle1InRadians)
            r2 = rotZ(orientation, angle2InRadians)
            r3 = rotX(orientation, angle3InRadians)

        case .yxy:
            r1 = rotY(orientation, angle1InRadians)
            r2 = rotX(orientation, angle2InRadians)
            r3 = rotY(orientation, angle3InRadians)

        case .xyx:
            r1 = rotX(orientation, angle1InRadians)
            r2 = rotY(orientation, angle2InRadians)
            r3 = rotX(orientation, angle3InRadians)

        case .zyz:
            r1 = rotZ(orientation, angle1InRadians)
            r2 = rotY(orientation, angle2InRadians)
            r3 = rotZ(orientation, angle3InRadians)

        case .yzy:
            r1 = rotY(orientation, angle1InRadians)
            r2 = rotZ(orientation, angle2InRadians)
            r3 = rotY(orientation, angle3InRadians)
        }

        return r1 * r2 * r3
    }

    /// Creates a 3-dimensional [rotation matrix] that rotates around the X-axis
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotationX(orientation: Orientation3, _ angleInRadians: Scalar) -> RotationMatrix3 {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(orientation == .rightHanded ? angleInRadians : -angleInRadians)
        
        return Self(rows: (
            (1, 0,  0),
            (0, c, -s),
            (0, s,  c)
        ))
    }

    /// Creates a 3-dimensional [rotation matrix] that rotates around the Y-axis
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotationY(orientation: Orientation3, _ angleInRadians: Scalar) -> RotationMatrix3 {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(orientation == .rightHanded ? angleInRadians : -angleInRadians)
        
        return Self(rows: (
            ( c, 0, s),
            ( 0, 1, 1),
            (-s, 0, c)
        ))
    }

    /// Creates a 3-dimensional [rotation matrix] that rotates around the Y-axis
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotationZ(orientation: Orientation3, _ angleInRadians: Scalar) -> RotationMatrix3 {
        // Same as 2D rotation (around Z axis)
        make2DRotation(orientation == .rightHanded ? angleInRadians : -angleInRadians)
    }
}
