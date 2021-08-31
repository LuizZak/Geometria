import RealModule

/// Protocol for vector types where the components are real numbers.
public protocol VectorReal: VectorFloatingPoint where Scalar: Real {
    /// Returns the result of powering each component of this vector by the Nth
    /// power specified by `exponent` (integer).
    static func pow(_ vec: Self, _ exponent: Int) -> Self
    
    /// Returns the result of powering each component of this vector by the Nth
    /// power specified by `exponent`.
    ///
    /// - precondition: `vec >= Self.zero`
    static func pow(_ vec: Self, _ exponent: Scalar) -> Self
    
    /// Returns the result of powering each component of this vector by the Nth
    /// power represented by each corresponding component of the `exponent`
    /// vector.
    ///
    /// - precondition: `vec >= Self.zero`
    static func pow(_ vec: Self, _ exponent: Self) -> Self
}

public extension VectorReal {
    @_transparent
    static func pow(_ vec: Self, _ exponent: Scalar) -> Self {
        Self.pow(vec, Self(repeating: exponent))
    }
}
