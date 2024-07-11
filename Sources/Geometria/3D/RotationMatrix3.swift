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
    static func make3DRotation(
        _ angle1InRadians: Scalar,
        _ angle2InRadians: Scalar,
        _ angle3InRadians: Scalar,
        order: RotationOrder3,
        orientation: Orientation3 = .rightHanded
    ) -> Self {

        let r1: Self
        let r2: Self
        let r3: Self

        let rotX = make3DRotationX
        let rotY = make3DRotationY
        let rotZ = make3DRotationZ

        switch order {
        case .xyz:
            r1 = rotX(angle1InRadians, orientation)
            r2 = rotY(angle2InRadians, orientation)
            r3 = rotZ(angle3InRadians, orientation)

        case .xzy:
            r1 = rotX(angle1InRadians, orientation)
            r2 = rotZ(angle2InRadians, orientation)
            r3 = rotY(angle3InRadians, orientation)

        case .yxz:
            r1 = rotY(angle1InRadians, orientation)
            r2 = rotX(angle2InRadians, orientation)
            r3 = rotZ(angle3InRadians, orientation)

        case .yzx:
            r1 = rotY(angle1InRadians, orientation)
            r2 = rotZ(angle2InRadians, orientation)
            r3 = rotX(angle3InRadians, orientation)

        case .zyx:
            r1 = rotZ(angle1InRadians, orientation)
            r2 = rotY(angle2InRadians, orientation)
            r3 = rotX(angle3InRadians, orientation)

        case .zxy:
            r1 = rotZ(angle1InRadians, orientation)
            r2 = rotX(angle2InRadians, orientation)
            r3 = rotY(angle3InRadians, orientation)

        case .zxz:
            r1 = rotZ(angle1InRadians, orientation)
            r2 = rotX(angle2InRadians, orientation)
            r3 = rotZ(angle3InRadians, orientation)

        case .xzx:
            r1 = rotX(angle1InRadians, orientation)
            r2 = rotZ(angle2InRadians, orientation)
            r3 = rotX(angle3InRadians, orientation)

        case .yxy:
            r1 = rotY(angle1InRadians, orientation)
            r2 = rotX(angle2InRadians, orientation)
            r3 = rotY(angle3InRadians, orientation)

        case .xyx:
            r1 = rotX(angle1InRadians, orientation)
            r2 = rotY(angle2InRadians, orientation)
            r3 = rotX(angle3InRadians, orientation)

        case .zyz:
            r1 = rotZ(angle1InRadians, orientation)
            r2 = rotY(angle2InRadians, orientation)
            r3 = rotZ(angle3InRadians, orientation)

        case .yzy:
            r1 = rotY(angle1InRadians, orientation)
            r2 = rotZ(angle2InRadians, orientation)
            r3 = rotY(angle3InRadians, orientation)
        }

        return r1 * r2 * r3
    }

    /// Creates a 3-dimensional [rotation matrix] that rotates around the X-axis
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotationX(_ angleInRadians: Scalar, orientation: Orientation3 = .rightHanded) -> RotationMatrix3 {
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
    static func make3DRotationY(_ angleInRadians: Scalar, orientation: Orientation3 = .rightHanded) -> RotationMatrix3 {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(orientation == .rightHanded ? angleInRadians : -angleInRadians)

        return Self(rows: (
            ( c, 0, s),
            ( 0, 1, 0),
            (-s, 0, c)
        ))
    }

    /// Creates a 3-dimensional [rotation matrix] that rotates around the Y-axis
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @inlinable
    static func make3DRotationZ(_ angleInRadians: Scalar, orientation: Orientation3 = .rightHanded) -> RotationMatrix3 {
        // Same as 2D rotation (around Z axis)
        make2DRotation(orientation == .rightHanded ? angleInRadians : -angleInRadians)
    }

    /// Creates a 3-dimensional [rotation matrix] that [rotates around the given
    /// axis](https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle)
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// `axis` is normalized pior to the creation of the rotation matrix.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    @available(*, deprecated, message: "Use make3DRotationFromAxisAngle<Vector: Vector3FloatingPoint>(axis: Vector, _ angle: Angle<Scalar>, orientation: Orientation3 = .rightHanded) instead.")
    static func make3DRotationFromAxisAngle<Vector: Vector3FloatingPoint>(
        axis: Vector,
        _ angleInRadians: Scalar,
        orientation: Orientation3 = .rightHanded
    ) -> RotationMatrix3 where Vector.Scalar == Scalar {

        let axis = axis.normalized()

        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(orientation == .rightHanded ? angleInRadians : -angleInRadians)
        let t: Scalar = 1 - c

        // NOTE: Doing this in separate statements to ease long compilation times in Xcode 12
        let x = axis.x, xx = x * x
        let y = axis.y, yy = y * y, yx = y * x
        let z = axis.z, zz = z * z, zx = z * x, zy = z * y

        let xs = x * s
        let ys = y * s
        let zs = z * s

        let r1: Self.Row = (t * xx + c,  t * yx - zs, t * zx + ys)
        let r2: Self.Row = (t * yx + zs, t * yy + c,  t * zy - xs)
        let r3: Self.Row = (t * zx - ys, t * zy + xs, t * zz + c)

        return Self(rows: (r1, r2, r3))
    }

    /// Creates a 3-dimensional [rotation matrix] that [rotates around the given
    /// axis](https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle)
    /// with a given [orientation] (handedness), by a given angle in radians.
    ///
    /// `axis` is normalized pior to the creation of the rotation matrix.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    static func make3DRotationFromAxisAngle<Vector: Vector3FloatingPoint>(
        axis: Vector,
        _ angle: Angle<Scalar>,
        orientation: Orientation3 = .rightHanded
    ) -> RotationMatrix3 where Vector.Scalar == Scalar {

        let axis = axis.normalized()

        let c = angle.cos
        let s = Scalar.sin(orientation == .rightHanded ? angle.radians : -angle.radians)
        let t: Scalar = 1 - c

        // NOTE: Doing this in separate statements to ease long compilation times in Xcode 12
        let x = axis.x, xx = x * x
        let y = axis.y, yy = y * y, yx = y * x
        let z = axis.z, zz = z * z, zx = z * x, zy = z * y

        let xs = x * s
        let ys = y * s
        let zs = z * s

        let r1: Self.Row = (t * xx + c,  t * yx - zs, t * zx + ys)
        let r2: Self.Row = (t * yx + zs, t * yy + c,  t * zy - xs)
        let r3: Self.Row = (t * zx - ys, t * zy + xs, t * zz + c)

        return Self(rows: (r1, r2, r3))
    }

    /// Creates a 3-dimensional [rotation matrix] that [rotates around a single
    /// axis](https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle)
    /// with an angle and direction that when applied to `vectorA`, turns it into
    /// the same direction as `vectorB`, with a given [orientation] (handedness).
    ///
    /// `vectorA` and `vectorB` are assumed to be directional vectors, and will
    /// be normalized pior to the creation of the rotation matrix.
    ///
    /// If `vectorA` and `vectorB` point on the same direction, an identity matrix
    /// is returned, instead.
    ///
    /// [rotation matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
    /// [orientation]: https://en.wikipedia.org/wiki/Orientation_(vector_space)
    static func make3DRotationBetween<Vector: Vector3FloatingPoint>(
        _ vectorA: Vector,
        _ vectorB: Vector,
        orientation: Orientation3 = .rightHanded
    ) -> RotationMatrix3 where Vector.Scalar == Scalar {

        let vectorA = vectorA.normalized()
        let vectorB = vectorB.normalized()

        if vectorA == vectorB {
            return .identity
        }

        let rAxis = vectorA.cross(vectorB) * (orientation == .rightHanded ? 1 : -1)
        let angle = Angle(radians: Scalar.acos(vectorA.dot(vectorB)))
        let m = RotationMatrix3.make3DRotationFromAxisAngle(axis: rAxis, angle)

        return m
    }
}
