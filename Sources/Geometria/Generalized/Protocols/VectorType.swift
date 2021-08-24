/// Protocol for N-dimensional vector types
public protocol VectorType {
    associatedtype Scalar
    
    /// Creates a new `VectorType` with the given scalar on all coordinates
    @inlinable
    init(repeating scalar: Scalar)
}
