import Geometria

/// Protocol for types that describe 2-dimensional simplexes produced by 2-dimensional
/// periodic geometry.
public protocol Periodic2Simplex: PeriodicSimplex where Vector: Vector2Type {
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
}

extension Periodic2Simplex {
    /// Constructs `startPeriod..<endPeriod`
    public var periodRange: Range<Period> {
        startPeriod..<endPeriod
    }
}
