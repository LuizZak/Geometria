/// Protocol for 2D real vector types.
public protocol Vector2Real: Vector2FloatingPoint & VectorReal where SubVector3: Vector3Real {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2Type`.
    var angle: Scalar { get }

    /// Returns the angle between `self` and `other`.
    func angle(to other: Self) -> Angle<Scalar>

    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @available(*, deprecated, message: "Use rotated(by angle: Angle<Scalar>) instead.")
    func rotated(by angleInRadians: Scalar) -> Self

    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle
    func rotated(by angle: Angle<Scalar>) -> Self

    /// Rotates this vector around the origin by a given angle in radians
    @available(*, deprecated, message: "Use rotate(by angle: Angle<Scalar>) instead.")
    mutating func rotate(by angleInRadians: Scalar)

    /// Rotates this vector around the origin by a given angle
    mutating func rotate(by angle: Angle<Scalar>)

    /// Rotates this vector around a given pivot by a given angle in radians
    @available(*, deprecated, message: "Use rotated(by angle: Angle<Scalar>, around pivot: Self) instead.")
    func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self

    /// Rotates this vector around a given pivot by a given angle
    func rotated(by angle: Angle<Scalar>, around pivot: Self) -> Self

    /// Rotates a given vector around the origin by an angle in radians
    @available(*, deprecated, message: "Use rotate(_ vec: Self, by angle: Angle<Scalar>) instead.")
    static func rotate(_ vec: Self, by angleInRadians: Scalar) -> Self

    /// Rotates a given vector around the origin by an angle
    static func rotate(_ vec: Self, by angle: Angle<Scalar>) -> Self

    @inlinable
    static func * (lhs: Self, rhs: Matrix3x2<Scalar>) -> Self

    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix3x2<Scalar>)
}

public extension Vector2Real {
    @inlinable
    func angle(to other: Self) -> Angle<Scalar> {
        Angle(radians: (other - self).angle)
    }

    func rotated(by angleInRadians: Scalar) -> Self {
        rotated(by: .init(radians: angleInRadians))
    }

    mutating func rotate(by angleInRadians: Scalar) {
        rotate(by: .init(radians: angleInRadians))
    }

    func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self {
        rotated(by: .init(radians: angleInRadians), around: pivot)
    }

    static func rotate(_ vec: Self, by angleInRadians: Scalar) -> Self {
        self.rotate(vec, by: .init(radians: angleInRadians))
    }
}
