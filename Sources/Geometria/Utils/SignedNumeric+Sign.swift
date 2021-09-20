/// Returns the sign of a numerical value, as -1 if the value is negative, 1 if
/// is positive, and 0 if it is zero.
///
/// ```swift
/// print(signValue(-3)) // Prints "-1"
/// print(signValue(0)) // Prints "0"
/// print(signValue(2)) // Prints "1"
/// ```
@_transparent
@usableFromInline
func signValue<T: SignedNumeric & Comparable>(_ value: T) -> T {
    value.signValue
}

extension SignedNumeric where Self: Comparable {
    /// Returns the sign of this numerical value, as -1 if the value is negative,
    /// 1 if is positive, and 0 if it is zero.
    ///
    /// ```swift
    /// print(-3.signValue) // Prints "-1"
    /// print(0.signValue) // Prints "0"
    /// print(2.signValue) // Prints "1"
    /// ```
    @_transparent
    @usableFromInline
    var signValue: Self {
        if self < .zero {
            return -1
        }
        if self > .zero {
            return 1
        }
        
        return .zero
    }
}
