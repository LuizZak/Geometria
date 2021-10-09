import RealModule

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix)
/// with double-precision floating-point components.
public typealias RotationMatrix3D<Scalar: Real & DivisibleArithmetic> = RotationMatrix3<Scalar>

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix)
/// with single-precision floating-point components.
public typealias RotationMatrix3F<Scalar: Real & DivisibleArithmetic> = RotationMatrix3<Scalar>

/// Describes a 3-dimensional [rotation matrix](https://en.wikipedia.org/wiki/Rotation_matrix).
public typealias RotationMatrix3<Scalar: Real & DivisibleArithmetic> = Matrix3x3<Scalar>

/// Specifies configurations for the order of rotations when creating a 
/// ``RotationMatrix3`` from a set of axial rotations.
public enum RotationOrder3: Hashable {
    // MARK: Tait–Bryan angles

    /// Rotation is created by rotating around the X-axis, Y-axis, and finally
    /// Z-axis.
    case xyz

    /// Rotation is created by rotating around the X-axis, Z-axis, and finally
    /// Y-axis.
    case xzy

    /// Rotation is created by rotating around the Z-axis, Y-axis, and finally
    /// X-axis.
    case zyx

    /// Rotation is created by rotating around the Z-axis, X-axis, and finally
    /// Y-axis.
    case zxy

    /// Rotation is created by rotating around the Y-axis, Z-axis, and finally
    /// X-axis.
    case yzx

    /// Rotation is created by rotating around the Y-axis, X-axis, and finally
    /// Y-axis.
    case yxz

    // MARK: Euler angles

    /// Rotation is created by rotating around the Z-axis, X-axis, and finally
    /// tbe Z-axis again.
    case zxz

    /// Rotation is created by rotating around the X-axis, Z-axis, and finally
    /// tbe X-axis again.
    case xzx

    /// Rotation is created by rotating around the Y-axis, X-axis, and finally
    /// tbe Y-axis again.
    case yxy

    /// Rotation is created by rotating around the X-axis, Y-axis, and finally
    /// tbe X-axis again.
    case xyx

    /// Rotation is created by rotating around the Z-axis, Y-axis, and finally
    /// tbe Z-axis again.
    case zyz

    /// Rotation is created by rotating around the Y-axis, Z-axis, and finally
    /// tbe Y-axis again.
    case yzy
}
