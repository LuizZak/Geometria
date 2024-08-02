import Geometria

/// Protocol for types that describe simplexes produced by parametric geometry.
public protocol ParametricSimplex: GeometricType {
    /// The type of vectors that are used to represent this parametric simplex.
    associatedtype Vector: VectorComparable
}
