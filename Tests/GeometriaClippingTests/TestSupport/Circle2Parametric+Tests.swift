import Geometria
import GeometriaClipping

extension Circle2Parametric where Vector == Vector2D {

    private static func makeSut(
        _ center: Vector2D,
        radius: Double,
        startPeriod: Double = 0.0,
        endPeriod: Double = 1.0
    ) -> Self {

        return .init(
            center: center,
            radius: radius,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    static func makeTestCircle(radius: Double = 100.0) -> Self {
        return makeSut(.zero, radius: radius)
    }
}
