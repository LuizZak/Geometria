/// Vector type where the components are signed numbers.
public protocol VectorSigned: VectorMultiplicative where Scalar: SignedNumeric & Comparable {
    /// Returns a `VectorSigned` where each component is the absolute magnitude
    /// of the components of this `VectorSigned`.
    ///
    /// Equivalent to calling C's abs() function on each component.
    ///
    /// ```swift
    /// print(Vector2D(x: 2.0, y: -1.0).absolute) // Prints "(x: 2.0, y: 1.0)"
    /// ```
    var absolute: Self { get }
    
    /// Negates this Vector by flipping the sign of each component.
    ///
    /// ```swift
    /// print(-Vector2D(x: 2.0, y: -1.0)) // Prints "(x: -2.0, y: 1.0)"
    /// ```
    static prefix func - (lhs: Self) -> Self
}

/// Returns a `VectorSigned` with each component as the absolute value of the
/// components of a given `VectorSigned`.
///
/// Equivalent to calling C's abs() function on each component.
///
/// Convenience for ``VectorSigned/absolute``.
///
/// ```swift
/// print(abs(Vector2D(x: 2.0, y: -1.0))) // Prints "(x: 2.0, y: 1.0)"
/// ```
@inlinable
public func abs<V: VectorSigned>(_ x: V) -> V {
    x.absolute
}
