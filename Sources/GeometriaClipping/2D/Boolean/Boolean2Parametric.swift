import Geometria

/// A boolean parametric type generator that takes as input parametric types and
/// produces other parametric types based on [boolean algebra] of the input
/// geometries.
///
/// [boolean algebra]: https://en.wikipedia.org/wiki/Boolean_algebra
public protocol Boolean2Parametric where T1.Vector == T2.Vector {
    /// The vector type associated with productions from this boolean parametric
    /// generator.
    typealias Vector = T1.Vector

    associatedtype T1: ParametricClip2Geometry
    associatedtype T2: ParametricClip2Geometry

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The simplex type produced by this parametric geometry.
    typealias Simplex = Parametric2GeometrySimplex<Vector>

    /// Creates a new instance of this boolean parametric type with two input
    /// parametric geometries.
    ///
    /// The tolerance specified is used to differentiate intersections that are
    /// too close together. Specifying a tolerance of `Scalar.infinity` results
    /// in no intersection being ignored, except for exactly duplicated ones,
    /// which are always ignored.
    init(_ lhs: T1, _ rhs: T2, tolerance: Scalar) where T1.Vector == Vector, T2.Vector == Vector

    /// Generates the simplexes for this boolean parametric.
    ///
    /// More than one simplex collection may be generated, depending on the input
    /// shapes and the underlying operation being applied.
    func allSimplexes() -> [[Simplex]]
}

extension Boolean2Parametric {
    /// Creates a new instance of this boolean parametric type with two input
    /// parametric geometries.
    ///
    /// The tolerance is set to `Scalar.leastNonzeroMagnitude`.
    public init(_ lhs: T1, _ rhs: T2) where T1.Vector == Vector, T2.Vector == Vector {
        self.init(lhs, rhs, tolerance: .leastNonzeroMagnitude)
    }
}
