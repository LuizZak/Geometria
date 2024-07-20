import Geometria

/// A boolean parametric type generator that takes as input parametric types and
/// produces other parametric types based on [boolean algebra] of the input
/// geometries.
///
/// [boolean algebra]: https://en.wikipedia.org/wiki/Boolean_algebra
public protocol Boolean2Parametric<Vector> {
    /// The vector type associated with productions from this boolean parametric
    /// generator.
    associatedtype Vector: Vector2Real

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The contour type produced by this parametric geometry.
    typealias Contour = Parametric2Contour<Vector>
    /// The simplex type produced by this parametric geometry.
    typealias Simplex = Parametric2GeometrySimplex<Vector>

    /// Generates the contours for this boolean parametric.
    ///
    /// More than one contour may be generated, depending on the input shapes and
    /// the underlying operation being applied.
    func allContours() -> [Contour]
}
