import Geometria

/// Protocol for types that describe 2-dimensional simplexes produced by 2-dimensional
/// periodic geometry.
public protocol Periodic2Simplex: PeriodicSimplex where Vector: Vector2Type {
    /// Gets the starting point of this simplex.
    var start: Vector { get }

    /// Gets the ending point of this simplex.
    var end: Vector { get }
}
