import RealModule
import Geometria
import GeometriaClipping

public extension ConsolePrintBuffer {
    func printPeriodics<Geometry: Periodic2Geometry>(
        _ periodics: [Geometry],
        translation: Vector2D = .zero,
        scale: Vector2D = .one
    ) where Geometry.Vector == Vector2D {

        let sampleVector: (Vector2D) -> Bool = { point in
            for periodic in periodics {
                if periodic.contains(point) {
                    return true
                }
            }

            return false
        }

        printSampling(sampleVector: sampleVector, translation: translation, scale: scale)
    }

    func printSimplexes(
        _ simplexes: [Periodic2GeometrySimplex<Vector2D>],
        translation: Vector2D = .zero,
        scale: Vector2D = .one
    ) {

        let bounds = simplexes.map(\.bounds).reduce(AABB2D.zero, { $0.union($1) })

        let sampleVector: (Vector2D) -> Bool = { point in
            let lineSegment = LineSegment2D(
                start: point,
                end: Vector2D(x: bounds.right + 10, y: point.y)
            )
            let testLine = Periodic2GeometrySimplex.lineSegment2(
                .init(lineSegment: lineSegment, startPeriod: 0.0, endPeriod: 1.0)
            )

            var count = 0
            for simplex in simplexes {
                let intersections = simplex.intersectionPeriods(with: testLine)
                count += intersections.count
            }

            return count % 2 == 1
        }

        printSampling(sampleVector: sampleVector, translation: translation, scale: scale)
    }

    func printSimplexesList(
        _ simplexes: [[Periodic2GeometrySimplex<Vector2D>]],
        translation: Vector2D = .zero,
        scale: Vector2D = .one
    ) {

        let bounds = simplexes.map {
            $0.map(\.bounds).reduce(AABB2D.zero, { $0.union($1) })
        }

        let sampleVector: (Vector2D) -> Bool = { point in
            var count = 0
            for (i, simplexes) in simplexes.enumerated() {
                let bounds = bounds[i]

                let lineSegment = LineSegment2D(
                    start: point,
                    end: Vector2D(x: bounds.right + 10, y: point.y)
                )
                let testLine = Periodic2GeometrySimplex.lineSegment2(
                    .init(lineSegment: lineSegment, startPeriod: 0.0, endPeriod: 1.0)
                )

                for simplex in simplexes {
                    let intersections = simplex.intersectionPeriods(with: testLine)
                    count += intersections.count
                }
            }

            return count % 2 == 1
        }

        printSampling(sampleVector: sampleVector, translation: translation, scale: scale)
    }

    func printSampling(
        sampleVector: (Vector2D) -> Bool,
        translation: Vector2D,
        scale: Vector2D
    ) {
        func sample(_ x: Int, _ y: Int) -> Double {
            let point = self.convert((x, y), translation: translation, scale: scale)
            let sampleArea: [Vector2D] = [
                Vector2D(x: -1, y: -1),
                Vector2D(x: -1, y: 0),
                Vector2D(x: 0, y: 0),
                Vector2D(x: 1, y: 0),
                Vector2D(x: 1, y: 1),
            ]

            var occlusion = 0.0
            let occlusionPerSample: Double = 1.0 / Double(sampleArea.count)
            for vector in sampleArea {
                let sampleScale = scale * 0.2
                if sampleVector(point + vector * sampleScale) {
                    occlusion += occlusionPerSample
                }
            }
            return occlusion
        }

        for x in 0..<(bufferWidth - 1) {
            for y in 0..<bufferHeight {
                let sample = sample(x, y)
                let shades: [Character] = [
                    " ", "░", "▒", "▓", "█",
                ]
                let perShade = 1.0 / Double(shades.count)

                let toShade = Int(sample / perShade).clamped(min: 0, max: shades.count - 1)
                putChar(shades[toShade], x: x, y: y)
            }
        }
    }
}

fileprivate extension ConsolePrintBuffer {
    func convert(
        _ point: (x: Int, y: Int),
        translation: Vector2D,
        scale: Vector2D
    ) -> Vector2D {
        let point = Vector2D(x: Double(point.x), y: Double(point.y))

        return (point - translation) / scale
    }

    func convert(
        _ point: Vector2D,
        translation: Vector2D,
        scale: Vector2D
    ) -> (x: Int, y: Int)? {
        let transformed = (point * scale) + translation

        let x = Int(transformed.x)
        let y = Int(transformed.y)

        if x < 0 || x >= bufferWidth {
            return nil
        }
        if y < 0 || y >= bufferHeight {
            return nil
        }

        return (x, y)
    }
}

extension Comparable {
    fileprivate func clamped(min: Self, max: Self) -> Self {
        if self < min {
            return min
        }
        if self > max {
            return max
        }
        return self
    }
}
