/// Protocol for objects that form geometric lines with two ``VectorMultiplicative``
/// vectors representing two points on the line.
public protocol LineMultiplicative: LineAdditive where Vector: VectorMultiplicative {
    /// Returns a new line with the end-points of this line scaled by `vector`
    /// around the origin.
    func withPointsScaledBy(_ factor: Vector) -> Self
    
    /// Returns a new line with the end-points of this line scaled by `vector`
    /// around a given center point.
    func withPointsScaledBy(_ factor: Vector, around center: Vector) -> Self
}
