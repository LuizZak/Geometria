import Geometria

/// A 2-dimensional parametric shape that is composed of generic contours that
/// are joined end-to-end in a loop.
public struct Compound2Parametric<Vector: Vector2Real>: ParametricClip2Geometry {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Parametric2GeometrySimplex<Vector>
    public typealias Contour = Parametric2Contour<Vector>

    /// The list of contours that compose this compound parametric.
    public var contours: [Contour]

    public var startPeriod: Period
    public var endPeriod: Period

    /// Initializes a new compound parametric with a given list of contours, using
    /// the start and end periods of the first contour as the start and end
    /// periods for the geometry.
    public init(contours: [Contour]) {
        self.init(
            contours: contours,
            startPeriod: contours.first?.startPeriod ?? .zero,
            endPeriod: contours.first?.endPeriod ?? 1
        )
    }

    /// Initializes a new compound parametric with a given list of contours, first
    /// normalizing their period intervals so they lie in the range
    /// `(0, 1]`.
    public init(
        normalizing contours: [Contour]
    ) {
        self.init(
            normalizing: contours,
            startPeriod: .zero,
            endPeriod: 1
        )
    }

    /// Initializes a new compound parametric with a given list of contours, first
    /// normalizing their period intervals so they lie in the range
    /// `(startPeriod, endPeriod]`.
    public init(
        normalizing contours: [Contour],
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            contours: contours.normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            ),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Initializes a new compound parametric with a given list of contours and
    /// a pre-defined start/end period range.
    ///
    /// - note: The period of the contained contours is not modified and is
    /// assumed to match the range `(startPeriod, endPeriod]`.
    public init(contours: [Contour], startPeriod: Period, endPeriod: Period) {
        self.contours = contours
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    public func allContours() -> [Parametric2Contour<Vector>] {
        contours
    }

    public func reversed() -> Compound2Parametric<Vector> {
        let contours = self.contours
            .map({ $0.reversed() })
            .reversed()

        return .init(
            normalizing: Array(contours),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }
}
