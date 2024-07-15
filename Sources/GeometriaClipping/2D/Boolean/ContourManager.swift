import Geometria

/// Manages inclusions/merging of contour objects.
class ContourManager<Vector: Vector2Real> {
    typealias Contour = Parametric2Contour<Vector>
    typealias Simplex = Parametric2GeometrySimplex<Vector>
    typealias Period = Vector.Scalar

    private var contours: [Contour]

    init() {
        contours = []
    }

    func allContours() -> [Contour] {
        contours
    }

    func append(_ contour: Contour) {
        contours.append(contour)
    }

    func beginContour() -> ContourBuilder {
        return ContourBuilder(manager: self)
    }

    class ContourBuilder {
        private var hasEnded: Bool = false
        private let manager: ContourManager
        private var simplexes: [Simplex]

        init(manager: ContourManager) {
            self.manager = manager
            self.simplexes = []
        }

        func append<S: Sequence>(contentsOf simplexes: S) where S.Element == Simplex {
            assert(!hasEnded, "!hasEnded: Attempted to append simplexes to finished contour")

            self.simplexes.append(contentsOf: simplexes)
        }

        func append(_ simplex: Simplex) {
            assert(!hasEnded, "!hasEnded: Attempted to append simplex to finished contour")

            simplexes.append(simplex)
        }

        func endContour(startPeriod: Period, endPeriod: Period) {
            assert(!hasEnded, "!hasEnded: Attempted to end already finished contour")

            hasEnded = true

            let contour = self.contour(startPeriod: startPeriod, endPeriod: endPeriod)
            manager.append(contour)
        }

        private func contour(startPeriod: Period, endPeriod: Period) -> Contour {
            Contour(
                normalizing: simplexes,
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
        }
    }
}
