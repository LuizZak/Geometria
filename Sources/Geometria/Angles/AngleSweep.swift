import RealModule

/// A pair of angle + angle range values that can be used to test inclusivity of
/// `Angle<Scalar>` values.
public struct AngleSweep<Scalar: FloatingPoint & ElementaryFunctions>: Hashable {
    public var start: Angle<Scalar>
    public var sweep: Angle<Scalar>

    /// Returns `start + sweep`.
    public var stop: Angle<Scalar> {
        start + sweep
    }

    public init(start startInRadians: Scalar, sweep sweepInRadians: Scalar) {
        self.start = .init(radians: startInRadians)
        self.sweep = .init(radians: sweepInRadians)
    }

    public init(start: Angle<Scalar>, sweep: Angle<Scalar>) {
        self.start = start
        self.sweep = sweep
    }

    /// Returns `true` if this circular arc contains a given angle value within
    /// its start + sweep region.
    public func contains(_ angle: Angle<Scalar>) -> Bool {
        let normalAngle = angle.normalized(from: .zero)
        var normalStart = start.normalized(from: .zero)
        var normalStop = (start + sweep).normalized(from: .zero)

        if sweep.radians < .zero {
            swap(&normalStart, &normalStop)
        }

        if normalStart > normalStop {
            return normalAngle >= normalStart || normalAngle <= normalStop
        }

        return normalAngle >= normalStart && normalAngle <= normalStop
    }

    /// Returns the result of clamping a given angle so it is contained within
    /// this angle sweep.
    public func clamped(_ angle: Angle<Scalar>) -> Angle<Scalar> {
        var normalStart = start.normalized(from: .zero)
        var normalStop = (start + sweep).normalized(from: .zero)

        if sweep.radians < .zero {
            swap(&normalStart, &normalStop)
        }

        let nMin = (Angle(radians: normalStart) - angle).normalized(from: -.pi)
        let nMax = (Angle(radians: normalStop) - angle).normalized(from: -.pi)

        if nMin <= 0 && nMax >= 0 {
            return angle
        }
        if nMin.magnitude < nMax.magnitude {
            return .init(radians: normalStart)
        }

        return .init(radians: normalStop)
    }
}
