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

    /// Returns `true` if `self` and `other` cover to the same angle sweep, after
    /// normalization.
    ///
    /// This method ignores the signs of the sweeps, and only compares the covered
    /// circular arc of both angle sweeps.
    public func isEquivalent(to other: Self) -> Bool {
        let (selfStart, selfStop) = self.normalizedStartStop(from: .zero)
        let (otherStart, otherStop) = other.normalizedStartStop(from: .zero)

        if selfStart == otherStart && selfStop == otherStop {
            return true
        }

        return false
    }

    /// Returns `true` if this angle sweep intersects with another angle sweep.
    ///
    /// The result is `true` also for angle sweeps that overlap only on their
    /// end-points, i.e. the check is inclusive.
    public func intersects(_ other: Self) -> Bool {
        if contains(other.start) || contains(other.stop) {
            return true
        }
        if other.contains(start) || other.contains(stop) {
            return true
        }

        return false
    }

    /// Returns `true` if this circular arc contains a given angle value within
    /// its start + sweep region.
    public func contains(_ angle: Angle<Scalar>) -> Bool {
        // If the sweep is of a full circle or more, the it contains all angles.
        guard sweep.radians.magnitude < Scalar.pi * 2 else {
            return true
        }

        let (normalStart, normalStop) = normalizedStartStop(from: .zero)

        let normalAngle = angle.normalized(from: .zero)
        if normalStart > normalStop {
            return normalAngle >= normalStart || normalAngle <= normalStop
        }

        return normalAngle >= normalStart && normalAngle <= normalStop
    }

    /// Returns the result of clamping a given angle so it is contained within
    /// this angle sweep.
    public func clamped(_ angle: Angle<Scalar>) -> Angle<Scalar> {
        // Sweeps of full circles don't clamp any angle
        guard sweep.radians.magnitude < Scalar.pi * 2 else {
            return angle
        }

        let (normalStart, normalStop) = normalizedStartStop(from: .zero)

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

    /// Returns a value from 0.0 to 1.0, inclusive, indicating how far along a
    /// given angle is to `self.start` and `self.stop`, where `0.0` is exactly
    /// on `start`, and `1.0` is exactly on `stop`.
    ///
    /// - note: Angle sweeps that are greater than `2π` will not properly map
    /// into a ratio due to the overlapping angle ranges.
    public func ratioOfAngle(_ angle: Angle<Scalar>) -> Scalar {
        // TODO: Examine replacing the complex wrapping logic with 'angle.normalized(from: start.radians)'

        guard sweep.radians.magnitude < Scalar.pi * 2 else {
            let normalAngle = angle.normalized(from: start.radians)

            return normalAngle / sweep.radians
        }

        let normalAngle = angle.normalized(from: .zero)
        let (normalStart, normalStop) = normalizedStartStop(from: .zero)

        var total: Scalar
        if normalStart > normalStop {
            total = (.pi * 2 - normalStart)
            total += normalStop
        } else {
            total = normalStop - normalStart
        }
        if total == .zero {
            total = .leastNonzeroMagnitude
        }

        if normalStart > normalStop {
            let result: Scalar
            let startToOrigin: Scalar = (.pi * 2) - normalStart
            let originToEnd = normalStop

            // Split the ratio into two sub-ranges: one from start - 2π, and one
            // from 0 - stop
            if normalAngle <= normalStop {
                result = (startToOrigin + normalAngle) / (startToOrigin + originToEnd)
            } else {
                result = (normalAngle - normalStart) / (startToOrigin + originToEnd)
            }

            if sweep.radians < .zero {
                return (1 - result)
            }
            return result
        }

        let result = (normalAngle - normalStart) / (normalStop - normalStart)

        if sweep.radians < .zero {
            return 1 - result
        }
        return result
    }

    func normalizedStartStop(from lowerBound: Scalar) -> (normalStart: Scalar, normalStop: Scalar) {
        var normalStart = start.normalized(from: lowerBound)
        var normalStop = (start + sweep).normalized(from: lowerBound)

        if sweep.radians < .zero {
            swap(&normalStart, &normalStop)
        }

        return (normalStart, normalStop)
    }
}
