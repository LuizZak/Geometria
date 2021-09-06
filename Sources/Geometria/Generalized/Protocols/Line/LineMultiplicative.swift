/// Protocol for objects that form geometric lines with two ``VectorMultiplicative``
/// vectors representing two points on the line.
public protocol LineMultiplicative: LineAdditive where Vector: VectorMultiplicative {
    /// Returns a new line with the end-points of this line scaled by `vector`.
    func withPointsScaledBy(_ factor: Vector) -> Self
}
