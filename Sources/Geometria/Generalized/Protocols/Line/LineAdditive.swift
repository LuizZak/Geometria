/// Protocol for objects that form geometric lines with two ``VectorAdditive``
/// vectors representing two points on the line.
public protocol LineAdditive: LineType where Vector: VectorAdditive {
    /// Returns a new line with the same slope, but with the end-points shifted
    /// by `vector`.
    func offsetBy(_ vector: Vector) -> Self
}
