/// Protocol for 2D line types where the vectors are signed vectors.
public protocol Line2Signed: LineSigned & Line2Multiplicative where Vector: Vector2Signed {
    /// Returns `true` if this line is colinear with a given point, up to a given
    /// tolerance of their cross-product check.
    func isCollinear(with point: Vector, tolerance: Vector.Scalar) -> Bool

    /// Returns `true` if this line is colinear with a given line, up to a given
    /// tolerance of their cross-product check.
    func isCollinear<Line: Line2Signed>(
        with line: Line,
        tolerance: Vector.Scalar
    ) -> Bool where Line.Vector == Vector
}

public extension Line2Signed {
    @inlinable
    func isCollinear(
        with point: Vector,
        tolerance: Vector.Scalar
    ) -> Bool {
        let ap = self.a - point
        let bp = self.b - point

        return ap.cross(bp).magnitude < tolerance.magnitude
    }

    @inlinable
    func isCollinear<Line: Line2Signed>(
        with line: Line,
        tolerance: Vector.Scalar
    ) -> Bool where Line.Vector == Vector {
        isCollinear(with: line.a, tolerance: tolerance) && isCollinear(with: line.b, tolerance: tolerance)
    }
}
