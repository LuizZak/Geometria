/// Clamps the given value between a range specied by `minimum` and `maximum`.
///
/// ```swift
/// let a = 7.0
///
/// print(clamp(a, min: 3.0, max: 5.0)) // Prints "5.0"
/// print(clamp(a, min: 5.0, max: 9.0)) // Prints "7.0"
/// print(clamp(a, min: 10.0, max: 15.0)) // Prints "10.0"
/// ```
public func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    if value < min {
        return min
    }
    if value > max {
        return max
    }
    
    return value
}
