/// Protocol for objects that form geometric lines with two ``VectorAdditive``
/// vectors representing two points on the line.
public protocol LineAdditive: LineType where Vector: VectorAdditive {
    /// Gets the slope of this line, or the vector that represents `b - a`.
    var lineSlope: Vector { get }
    
    /// Returns a new line with the same slope, but with the end-points shifted
    /// by `vector`.
    func offsetBy(_ vector: Vector) -> Self
}

public extension LineAdditive {
    @_transparent
    var lineSlope: Vector {
        b - a
    }
}
