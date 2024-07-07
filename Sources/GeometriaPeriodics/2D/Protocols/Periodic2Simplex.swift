import Geometria

/// Protocol for types that describe 2-dimensional simplexes produced by 2-dimensional
/// periodic geometry.
public protocol Periodic2Simplex: PeriodicSimplex where Vector: Vector2Type {
    /// The type of period that is used to represent this periodic simplex's
    /// period range in its parent periodic geometry.
    typealias Period = Vector.Scalar

    /// Gets the starting point of this simplex.
    var start: Vector { get }

    /// Gets the inclusive start period of this simplex within its parent
    /// 2-dimensional periodic geometry.
    var startPeriod: Period { get }

    /// Gets the ending point of this simplex.
    var end: Vector { get }

    /// Gets the exclusive end period of this simplex within its parent
    /// 2-dimensional periodic geometry.
    var endPeriod: Period { get }

    /// Gets the bounding box for this simplex.
    var bounds: AABB2<Vector> { get }

    /// Computes the point of this simplex at a given period value.
    ///
    /// At `startPeriod`, the result is `start`, and at `endPeriod`, the result
    /// is `end`, with values in between continuously translating from start to
    /// the end, not necessarily in a straight line.
    func compute(at period: Period) -> Vector
}

extension Periodic2Simplex {
    /// Constructs `startPeriod..<endPeriod`
    public var periodRange: Range<Period> {
        startPeriod..<endPeriod
    }
}
