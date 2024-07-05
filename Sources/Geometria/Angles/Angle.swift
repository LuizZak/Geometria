import RealModule

/// A standardized representation of an angle.
public struct Angle<Scalar: Real>: Hashable {
    /// Gets the angle value for the mathematical constant `π`.
    @inlinable
    public static var pi: Self { Self(radians: Scalar.pi) }

    /// Gets the radian value associated with this angle.
    public let radians: Scalar

    /// Initializes this angle with a given radians angle value.
    public init(radians: Scalar) {
        self.radians = radians
    }

    /// Returns this angle's normalized representation, starting from a given
    /// offset, such that the angle is confined to `[lowerBound, lowerBound + π)`
    public func normalized(from lowerBound: Scalar) -> Scalar {
        Self.normalize(radians, offset: lowerBound, period: .pi * 2)
    }

    /// Normalizes an input value to `a - k` where `k` is an integer that satisfies
    /// `offset <= a - k < offset + period`.
    static func normalize(
        _ a: Scalar,
        offset: Scalar,
        period: Scalar
    ) -> Scalar {
        let upper = offset + period

        if offset <= a && a < upper {
            return a
        }

        let aMo: Scalar = a - offset
        let normalized: Scalar = aMo - period * (aMo / period).rounded(.down) + offset

        if normalized < upper {
            if normalized > offset {
                return normalized
            }

            return offset
        } else {
            // If value is too small to be representable compared to the
            // floor expression above (i.e. value + x = x), then we may
            // end up with a number exactly equal to the upper bound.
            // In that case, subtract one period from the normalized value
            // so that the result is strictly less than the upper bound. (We also
            // want to ensure that we do not return anything less than the lower bound.)
            return max(offset, normalized - period)
        }
    }
}

extension Angle: Encodable where Scalar: Encodable { }
extension Angle: Decodable where Scalar: Decodable { }

extension Angle: AdditiveArithmetic {
    /// Gets the zero radian angle.
    @inlinable
    public static var zero: Angle { .init(radians: .zero) }

    /// Adds two angles by summing their radians representation.
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        .init(radians: lhs.radians + rhs.radians)
    }

    /// Subtracts two angles by subtracting their radians representation.
    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        .init(radians: lhs.radians - rhs.radians)
    }

    /// Adds a scalar and an angle, producing an angle value.
    public static func + (lhs: Angle, rhs: Scalar) -> Angle {
        .init(radians: lhs.radians + rhs)
    }

    /// Subtracts a scalar from an angle, producing an angle value
    public static func - (lhs: Angle, rhs: Scalar) -> Angle {
        .init(radians: lhs.radians - rhs)
    }
}
