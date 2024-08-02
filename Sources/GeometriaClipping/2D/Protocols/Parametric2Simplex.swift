import Geometria

/// Protocol for types that describe 2-dimensional simplexes produced by 2-dimensional
/// parametric geometry.
public protocol Parametric2Simplex: ParametricSimplex where Vector: Vector2Type {
    typealias Scalar = Vector.Scalar

    /// The type of period that is used to represent this parametric simplex's
    /// period range in its parent parametric geometry.
    typealias Period = Vector.Scalar

    /// Gets the starting point of this simplex.
    var start: Vector { get }

    /// Gets the inclusive start period of this simplex within its parent
    /// 2-dimensional parametric geometry.
    var startPeriod: Period { get }

    /// Gets the ending point of this simplex.
    var end: Vector { get }

    /// Gets the exclusive end period of this simplex within its parent
    /// 2-dimensional parametric geometry.
    var endPeriod: Period { get }

    /// Gets the bounding box for this simplex.
    var bounds: AABB2<Vector> { get }

    /// Computes the point of this simplex at a given period value.
    ///
    /// At `startPeriod`, the result is `start`, and at `endPeriod`, the result
    /// is `end`, with values in between continuously translating from start to
    /// the end, not necessarily in a straight line.
    func compute(at period: Period) -> Vector

    /// Returns `true` if a given vector is at most `√(toleranceSquared)`-distance
    /// away from this simplex's surface.
    func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool

    /// Returns `true` if this simplex intersects a horizontal line going right
    /// (positive X axis), starting at a given point.
    ///
    /// If this simplex intersects the given ray a multiple of two times, including
    /// zero times, the result is `false`.
    ///
    /// Used for point-containment checks of contours.
    func intersectsHorizontalLine(start: Vector, tolerance: Scalar) -> Bool

    /// Returns the closest period to an input vector.
    func closestPeriod(to vector: Vector) -> Period

    /// Reverses this simplex by swapping its start <-> end points, making it
    /// travel in the opposite direction.
    ///
    /// The start and end periods remain the same.
    func reversed() -> Self

    /// Splits this simplex at a given period, returning two simplexes that join
    /// to form the same range of periods/strokes that this simplex spans.
    ///
    /// - precondition: `period` is a valid period contained within `startPeriod..<endPeriod`.
    @inlinable
    func split(at period: Period) -> (Self, Self)
}

extension Parametric2Simplex {
    /// Constructs `startPeriod..<endPeriod`
    @inlinable
    public var periodRange: Range<Period> {
        startPeriod..<endPeriod
    }
}

public enum SimplexWinding {
    /// A clockwise winding.
    case clockwise

    /// A counter-clockwise winding.
    case counterClockwise
}
