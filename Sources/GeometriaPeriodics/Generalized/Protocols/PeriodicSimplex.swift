import Geometria

/// Protocol for types that describe simplexes produced by periodic geometry.
public protocol PeriodicSimplex: GeometricType {
    associatedtype Vector: VectorType
}
