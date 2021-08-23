/// Vector type where the components are signed numbers.
public protocol VectorSigned: VectorMultiplicative where Scalar: SignedNumeric & Comparable {
    /// Returns a `VectorSigned` where each component is the absolute
    /// value of the components of this `VectorSigned`.
    var absolute: Self { get }
    
    /// Negates this Vector
    static prefix func - (lhs: Self) -> Self
}
