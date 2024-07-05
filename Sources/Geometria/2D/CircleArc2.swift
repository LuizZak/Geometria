import RealModule

/// Represents a 2D arc of a circle with double-precision floating-point components.
public typealias CircleArc2D = CircleArc2<Vector2D>

/// Represents a 2D arc of a circle with single-precision floating-point components.
public typealias CircleArc2F = CircleArc2<Vector2F>

/// Represents a 2D arc of a circle as a center, radius, and start+sweep angles.
public struct CircleArc2<Vector: Vector2Real>: GeometricType {
    public typealias Scalar = Vector.Scalar

    /// The center of the arc's circle.
    public var center: Vector

    /// The radius of the arc's circle.
    public var radius: Scalar

    /// The starting angle of this arc, in radians.
    public var startAngle: Angle<Scalar>

    /// The sweep angle of this arc, in radians.
    public var sweepAngle: Angle<Scalar>

    /// Initializes a new circular arc with the given input parameters.
    public init(
        center: Vector,
        radius: Scalar,
        startAngle: Scalar,
        sweepAngle: Scalar
    ) {
        self.init(
            center: center,
            radius: radius,
            startAngle: .init(radians: startAngle),
            sweepAngle: .init(radians: sweepAngle)
        )
    }

    /// Initializes a new circular arc with the given input parameters.
    public init(
        center: Vector,
        radius: Scalar,
        startAngle: Angle<Scalar>,
        sweepAngle: Angle<Scalar>
    ) {
        self.center = center
        self.radius = radius
        self.startAngle = startAngle
        self.sweepAngle = sweepAngle
    }
}

extension CircleArc2: Equatable where Vector: Equatable { }
extension CircleArc2: Hashable where Vector: Hashable { }

public extension CircleArc2 {
    /// Returns the stop angle of this sweep, as the sum of `startAngle` + `sweepAngle`.
    var stopAngle: Angle<Scalar> {
        startAngle + sweepAngle
    }

    /// Computes the area of this circular arc, when interpreted as a pie slice
    /// of a circle.
    @inlinable
    var area: Scalar {
        (radius * radius / 2) * sweepAngle.radians
    }

    /// Computes the length of this circular arc.
    @inlinable
    var length: Scalar {
        radius * sweepAngle.radians
    }

    /// Returns `true` if this circular arc contains a given angle value within
    /// its start + sweep region.
    func contains(_ angle: Scalar) -> Bool {
        return contains(.init(radians: angle))
    }

    /// Returns `true` if this circular arc contains a given angle value within
    /// its start + sweep region.
    func contains(_ angle: Angle<Scalar>) -> Bool {
        let normalAngle = angle.normalized(from: .zero)
        var normalStart = startAngle.normalized(from: .zero)
        var normalStop = (startAngle + sweepAngle).normalized(from: .zero)

        if sweepAngle.radians < .zero {
            swap(&normalStart, &normalStop)
        }

        if normalStart > normalStop {
            return normalAngle >= normalStart || normalAngle <= normalStop
        }

        return normalAngle >= normalStart && normalAngle <= normalStop
    }
}
