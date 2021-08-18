/// A type with values that support division.
public protocol DivisibleArithmetic: Numeric {
    /// Divides two values.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    static func / (lhs: Self, rhs: Self) -> Self

    /// Divides two values and stores the result in the left-hand-side
    /// variable.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    static func /= (lhs: inout Self, rhs: Self)
}

public extension DivisibleArithmetic {
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
}

// MARK: - Integers conformance
extension Int: DivisibleArithmetic { }
extension UInt: DivisibleArithmetic { }

extension Int8: DivisibleArithmetic { }
extension Int16: DivisibleArithmetic { }
extension Int32: DivisibleArithmetic { }
extension Int64: DivisibleArithmetic { }
extension UInt8: DivisibleArithmetic { }
extension UInt16: DivisibleArithmetic { }
extension UInt32: DivisibleArithmetic { }
extension UInt64: DivisibleArithmetic { }

// MARK: - Floating-point conformance
extension Float: DivisibleArithmetic { }
extension Float80: DivisibleArithmetic { }
extension Double: DivisibleArithmetic { }
