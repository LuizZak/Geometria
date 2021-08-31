/// Protocol for N-dimensional vector types.
public protocol VectorType {
    /// The scalar type associated with this `VectorType`.
    associatedtype Scalar
    
    /// Creates a new `VectorType` with the given scalar on all coordinates.
    init(repeating scalar: Scalar)
}
