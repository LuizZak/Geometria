import Geometria

/// A 2-dimensional simplex composed of a line segment.
public struct LineSegment2Simplex<Vector: Vector2Type>: Periodic2Simplex {
    /// The line segment associated with this simplex.
    public var lineSegment: LineSegment2<Vector>

    /// Initializes a new line segment simplex value with a given line segment.
    public init(lineSegment: LineSegment2<Vector>) {
        self.lineSegment = lineSegment
    }
}

extension LineSegment2Simplex {
    @inlinable
    public var start: Vector { lineSegment.start }

    @inlinable
    public var end: Vector { lineSegment.end }
}
