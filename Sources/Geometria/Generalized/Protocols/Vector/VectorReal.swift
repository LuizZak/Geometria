import RealModule

/// Protocol for vector types where the components are real numbers.
public protocol VectorReal: VectorFloatingPoint & VectorComparable where Scalar: Real {
    /// Returns the result of powering each component of this vector by the `n`th
    /// power.
    ///
    /// - precondition: `vec >= Self.zero`
    static func pow(_ vec: Self, _ n: Scalar) -> Self
    
    /// Returns the result of powering each component of this vector by the `n`th
    /// power (integer).
    static func pow(_ vec: Self, _ n: Int) -> Self
    
    /// Returns the result of powering each component of this vector by the `n`th
    /// power represented by each corresponding component of the `n` vector.
    ///
    /// - precondition: `vec >= Self.zero`
    static func pow(_ vec: Self, _ n: Self) -> Self
}
