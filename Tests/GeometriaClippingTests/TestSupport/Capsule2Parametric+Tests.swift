import Geometria
import GeometriaClipping

extension Capsule2Parametric where Vector == Vector2D {
    static func makeCapsuleSequence(_ segments: [(point: Vector2D, radius: Double)]) -> [Self] {
        guard var last = segments.first else {
            return []
        }

        var result: [Self] = []

        for next in segments.dropFirst() {
            defer { last = next }

            let capsule = Self(
                start: last.point,
                startRadius: last.radius,
                end: next.point,
                endRadius: next.radius,
                startPeriod: 0.0,
                endPeriod: 1.0
            )

            result.append(capsule)
        }

        return result
    }
}
