import Geometria

/// A boolean periodic type generator that takes as input periodic types and
/// produces other periodic types based on [boolean algebra] of the input
/// geometries.
///
/// [boolean algebra]: https://en.wikipedia.org/wiki/Boolean_algebra
public protocol Boolean2Periodic where T1.Vector == T2.Vector {
    /// The vector type associated with productions from this boolean periodic
    /// generator.
    typealias Vector = T1.Vector

    associatedtype T1: Periodic2Geometry
    associatedtype T2: Periodic2Geometry

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The simplex type produced by this periodic geometry.
    typealias Simplex = Periodic2GeometrySimplex<Vector>

    /// Creates a new instance of this boolean periodic type with two input
    /// periodic geometries.
    ///
    /// The tolerance specified is used to differentiate intersections that are
    /// too close together. Specifying a tolerance of `Scalar.infinity` results
    /// in no intersection being ignored, except for exactly duplicated ones,
    /// which are always ignored.
    init(_ lhs: T1, _ rhs: T2, tolerance: Scalar) where T1.Vector == Vector, T2.Vector == Vector

    /// Generates the simplexes for this boolean periodic.
    ///
    /// More than one simplex collection may be generated, depending on the input
    /// shapes and the underlying operation being applied.
    func allSimplexes() -> [[Simplex]]
}

extension Boolean2Periodic {
    /// Creates a new instance of this boolean periodic type with two input
    /// periodic geometries.
    ///
    /// The tolerance is set to `Scalar.leastNonzeroMagnitude`.
    public init(_ lhs: T1, _ rhs: T2) where T1.Vector == Vector, T2.Vector == Vector {
        self.init(lhs, rhs, tolerance: .leastNonzeroMagnitude)
    }
}
