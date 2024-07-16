import Geometria

/// A 2-dimensional parametric shape that is composed of generic contours that
/// are joined end-to-end in a loop.
public struct Compound2Parametric<Vector: Vector2Real>: ParametricClip2Geometry {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Parametric2GeometrySimplex<Vector>
    public typealias Contour = Parametric2Contour<Vector>

    private var _cache: _Cache

    /// The list of contours that compose this compound parametric.
    public var contours: [Contour] {
        willSet { _ensureUnique() }
    }

    public var startPeriod: Period {
        willSet { _ensureUnique() }
    }
    public var endPeriod: Period {
        willSet { _ensureUnique() }
    }

    public var bounds: AABB<Vector> {
        if let cached = _cache.bounds {
            return cached
        }

        let result = AABB(aabbs: self.allContours().map(\.bounds))
        _cache.bounds = result
        return result
    }

    public init(_ geometry: some ParametricClip2Geometry<Vector>) {
        self.init(
            contours: geometry.allContours(),
            startPeriod: geometry.startPeriod,
            endPeriod: geometry.endPeriod
        )
    }

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
        self._cache = _Cache()
    }

    private mutating func _ensureUnique() {
        if !isKnownUniquelyReferenced(&_cache) {
            _cache = _cache.copy()
        }
    }

    public func allContours() -> [Parametric2Contour<Vector>] {
        contours
    }

    public func reversed() -> Self {
        if let cached = _cache.reversed {
            return cached
        }

        let contours = self.contours
            .map({ $0.reversed() })
            .reversed()

        let result = Self(
            normalizing: Array(contours),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )

        _cache.reversed = result

        return result
    }

    private class _Cache {
        var reversed: Compound2Parametric?
        var bounds: AABB<Vector>?

        func copy() -> _Cache {
            return _Cache()
        }
    }
}
