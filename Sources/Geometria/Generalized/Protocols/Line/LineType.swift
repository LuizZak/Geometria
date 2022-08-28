/// Protocol for objects that form geometric lines with at least two distinct
/// points the line is guaranteed to cross.
public protocol LineType: GeometricType {
    /// The vector type associated with this `LineType`.
    associatedtype Vector: VectorType
    
    /// Gets the first point that defines the line of this `LineType`.
    ///
    /// This point is always guaranteed to be colinear and part of the line limits.
    var a: Vector { get }
    
    /// Gets the second point that defines the line of this `LineType`.
    ///
    /// This point is not guaranteed to be part of the line limits but it is
    /// guaranteed to be colinear.
    var b: Vector { get }
}
