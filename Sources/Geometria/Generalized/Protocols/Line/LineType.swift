/// Protocol for objects that form geometric lines with at least two points.
public protocol LineType: GeometricType {
    /// The vector type associated with this `LineType`.
    associatedtype Vector: VectorType
    
    /// Gets the first point that defines the line of this `LineType`.
    var a: Vector { get }
    
    /// Gets the second point that defines the line of this `LineType`.
    var b: Vector { get }
}
