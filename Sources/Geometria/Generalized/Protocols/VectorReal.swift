import RealModule

/// Protocol for vector types where the components are real numbers.
public protocol VectorReal: VectorFloatingPoint where Scalar: Real {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `VectorReal`
    var length: Scalar { get }
    
    /// Returns the distance between this `VectorReal` and another `VectorReal`
    func distance(to vec: Self) -> Scalar
    
    /// Returns the result of powering each component of this vector by the `n`th
    /// power.
    static func pow(_ vec: Self, _ n: Scalar) -> Self
    
    /// Returns the result of powering each component of this vector by the `n`th
    /// power represented by each corresponding component of the `n` vector.
    static func pow(_ vec: Self, _ n: Self) -> Self
}
