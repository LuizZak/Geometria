/// Vector type where the components are signed numbers.
public protocol VectorSigned: VectorMultiplicative where Scalar: SignedNumeric & Comparable {
    /// Returns a `VectorSigned` where each component is the absolute
    /// value of the components of this `VectorSigned`.
    var absolute: Self { get }
    
    /// Negates this Vector
    static prefix func - (lhs: Self) -> Self
}

/// Returns a `VectorSigned` with each component as the absolute value of the
/// components of a given `VectorSigned`.
///
/// Equivalent to calling C's abs() function on each component.
@inlinable
public func abs<V: VectorSigned>(_ x: V) -> V {
    return x.absolute
}
