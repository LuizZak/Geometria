/// Protocol for N-dimensional vector types.
public protocol VectorType {
    /// The scalar type associated with this `VectorType`.
    associatedtype Scalar
    
    /// The number of scalars in the vector.
    var scalarCount: Int { get }
    
    /// Accesses the scalar at the specified position.
    ///
    /// - precondition: `index >= 0 && index < ` ``scalarCount``
    subscript(index: Int) -> Scalar { get set }
    
    /// Creates a new `VectorType` with the given scalar on all coordinates.
    init(repeating scalar: Scalar)
}
