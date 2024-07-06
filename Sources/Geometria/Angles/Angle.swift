import RealModule

/// A standardized representation of an angle.
public struct Angle<Scalar: FloatingPoint & ElementaryFunctions>: Hashable {
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

    /// Returns the relative sweep angles to go from `self` to `other`.
    ///
    /// In the results, `shortest` contains the smallest angle change to go from
    /// `self` to `other`, and `longest` is the largest angle change.
    ///
    /// If `self` and `other` point to the same angle, `shortest` will be `.zero`
    /// and `longest` will be `Angle(radians: .pi + .pi)`
    public func relativeAngles(to other: Self) -> (shortest: Self, longest: Self) {
        let twoPi: Scalar = .pi + .pi

        let normalOther = other.normalized(from: self.radians)
        let direct = normalOther - self.radians
        let indirect = twoPi - (normalOther - self.radians)

        if direct > indirect {
            return (
                .init(radians: -(twoPi - direct)),
                Self(radians: twoPi - indirect)
            )
        }

        return (
            .init(radians: direct),
            Self(radians: -indirect)
        )
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

public extension Angle {
    /// Returns the cosine of this angle.
    @inlinable
    var cos: Scalar {
        Scalar.cos(self.radians)
    }

    /// Returns the sine of this angle.
    @inlinable
    var sin: Scalar {
        Scalar.sin(self.radians)
    }

    /// Returns the tangent of this angle.
    @inlinable
    var tan: Scalar {
        Scalar.tan(self.radians)
    }

    /// Returns the arccosine of this angle
    @inlinable
    var acos: Scalar {
        Scalar.acos(self.radians)
    }

    /// Returns the arcsine of this angle.
    @inlinable
    var asin: Scalar {
        Scalar.asin(self.radians)
    }

    /// Returns the arctangent of this angle.
    @inlinable
    var atan: Scalar {
        Scalar.atan(self.radians)
    }

    /// Returns the [hyperbolic cosine][https://en.wikipedia.org/wiki/Hyperbolic_function]
    /// of this angle.
    @inlinable
    var cosh: Scalar {
        Scalar.cosh(self.radians)
    }

    /// Returns the [hyperbolic sine][https://en.wikipedia.org/wiki/Hyperbolic_function]
    /// of this angle.
    @inlinable
    var sinh: Scalar {
        Scalar.sinh(self.radians)
    }

    /// Returns the [hyperbolic tangent][https://en.wikipedia.org/wiki/Hyperbolic_function]
    /// of this angle.
    @inlinable
    var tanh: Scalar {
        Scalar.tanh(self.radians)
    }

    /// Returns the [inverse hyperbolic cosine][https://en.wikipedia.org/wiki/Inverse_hyperbolic_function]
    /// of this angle.
    @inlinable
    var acosh: Scalar {
        Scalar.acosh(self.radians)
    }

    /// Returns the [inverse hyperbolic sine][https://en.wikipedia.org/wiki/Inverse_hyperbolic_function]
    /// of this angle.
    @inlinable
    var asinh: Scalar {
        Scalar.asinh(self.radians)
    }

    /// Returns the [inverse hyperbolic tangent][https://en.wikipedia.org/wiki/Inverse_hyperbolic_function]
    /// of this angle.
    @inlinable
    var atanh: Scalar {
        Scalar.atanh(self.radians)
    }
}

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

extension Angle: Numeric {
    public var magnitude: Scalar { radians.magnitude }

    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(radians: Scalar(integerLiteral: value))
    }

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let value = Scalar(exactly: source) else {
            return nil
        }

        self.init(radians: value)
    }

    public static func * (lhs: Angle, rhs: Angle) -> Angle {
        .init(radians: lhs.radians * rhs.radians)
    }

    public static func / (lhs: Angle, rhs: Angle) -> Angle {
        .init(radians: lhs.radians / rhs.radians)
    }

    public static func * (lhs: Angle, rhs: Scalar) -> Angle {
        .init(radians: lhs.radians * rhs)
    }

    public static func / (lhs: Angle, rhs: Scalar) -> Angle {
        .init(radians: lhs.radians / rhs)
    }

    public static func *= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Angle, rhs: Angle) {
        lhs = lhs / rhs
    }

    public static func *= (lhs: inout Angle, rhs: Scalar) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Angle, rhs: Scalar) {
        lhs = lhs / rhs
    }
}
