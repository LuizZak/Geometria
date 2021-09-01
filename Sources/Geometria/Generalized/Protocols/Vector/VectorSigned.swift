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
    
    /// Returns a `VectorSigned` where each component is `Self.one` with the
    /// signs of each component of this `VectorSigned`.
    ///
    /// ```swift
    /// print(Vector2D(x: 4.0, y: -2.0).sign) // Prints "(x: 1.0, y: -1.0)"
    /// ```
    var sign: Self { get }
    
    /// Returns a `VectorSigned` where each component is the absolute magnitude
    /// of the components of this `VectorSigned`, but with the signs of a
    /// secondary `VectorSigned`.
    ///
    /// Equivalent to multiplying `self.absolute` by `other.sign`
    ///
    /// ```swift
    /// let vec1 = Vector2D(x: 5.0, y: -4.0)
    /// let vec2 = Vector2D(x: -1, y: 1)
    ///
    /// print(vec1.withSign(of: vec2)) // Prints "(x: -5.0, y: 4.0)"
    /// ```
    func withSign(of other: Self) -> Self
    
    /// Negates this Vector by flipping the sign of each component.
    ///
    /// ```swift
    /// print(-Vector2D(x: 2.0, y: -1.0)) // Prints "(x: -2.0, y: 1.0)"
    /// ```
    static prefix func - (lhs: Self) -> Self
}

public extension VectorSigned {
    /// Returns a `VectorSigned` where each component is the absolute magnitude
    /// of the components of this `VectorSigned`, but with the signs of a
    /// secondary `VectorSigned`.
    ///
    /// Equivalent to multiplying `self.absolute` by `other.sign`
    ///
    /// ```swift
    /// let vec1 = Vector2D(x: 5.0, y: -4.0)
    /// let vec2 = Vector2D(x: -1, y: 1)
    ///
    /// print(vec1.withSign(of: vec2)) // Prints "(x: -5.0, y: 4.0)"
    /// ```
    func withSign(of other: Self) -> Self {
        return absolute * other.sign
    }
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
