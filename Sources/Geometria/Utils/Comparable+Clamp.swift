/// Clamps the given value between a range specified by `minimum` and `maximum`.
///
/// ```swift
/// let a = 7.0
///
/// print(clamp(a, min: 3.0, max: 5.0)) // Prints "5.0"
/// print(clamp(a, min: 5.0, max: 9.0)) // Prints "7.0"
/// print(clamp(a, min: 10.0, max: 15.0)) // Prints "10.0"
/// ```
@_transparent
@usableFromInline
func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    value.clamped(min: min, max: max)
}

extension Comparable {
    /// Clamps the given value between a range specified by `minimum` and `maximum`.
    ///
    /// ```swift
    /// let a = 7.0
    ///
    /// print(a.clamped(min: 3.0, max: 5.0)) // Prints "5.0"
    /// print(a.clamped(min: 5.0, max: 9.0)) // Prints "7.0"
    /// print(a.clamped(min: 10.0, max: 15.0)) // Prints "10.0"
    /// ```
    @_transparent
    @usableFromInline
    func clamped(min: Self, max: Self) -> Self {
        if self < min {
            return min
        }
        if self > max {
            return max
        }
        
        return self
    }
}
