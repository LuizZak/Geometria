import Geometria

/// Protocol for types that describe simplexes produced by periodic geometry.
public protocol PeriodicSimplex: GeometricType {
    /// The type of vectors that are used to represent this periodic simplex.
    associatedtype Vector: VectorType

    /// The type of period that is used to represent this periodic simplex's
    /// period range in its parent periodic geometry.
    associatedtype Period: PeriodType
}