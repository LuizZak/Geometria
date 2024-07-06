import Geometria

/// A 2-dimensional simplex composed of a circular arc segment.
public struct CircleArc2Simplex<Vector: Vector2Real>: Periodic2Simplex {
    /// The circular arc segment associated with this simplex.
    public var circleArc: CircleArc2<Vector>

    /// Initializes a new circular arc segment simplex value with a given circular
    /// arc segment.
    public init(circleArc: CircleArc2<Vector>) {
        self.circleArc = circleArc
    }
}

extension CircleArc2Simplex {
    @inlinable
    public var start: Vector { circleArc.startPoint }

    @inlinable
    public var end: Vector { circleArc.endPoint }
}
