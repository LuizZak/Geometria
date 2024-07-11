import XCTest
import Geometria
import TestCommons

@testable import GeometriaAlgorithms

class PointCloud2Tests: XCTestCase {
    typealias Sut = PointCloud<Vector2D>

    // MARK: Graham scan

    func testGrahamScanConvexHull() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 3.0, y: -11.0),
                .init(x: -3.0, y: -7.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 2.0, y: 3.0),
                .init(x: 12.0, y: -10.0),
            ]
        )

        let result = sut.grahamScanConvexHull()

        TestFixture.beginFixture(lineScale: 30, renderScale: 15) { fixture in
            let asLinePolygon = LinePolygon2(vertices: result.points)
            fixture.add(sut)
            fixture.add(asLinePolygon)

            fixture.assertEquals(result.points, [
                .init(x: 3.0, y: -11.0),
                .init(x: -3.0, y: -7.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 12.0, y: -10.0),
            ])
        }
    }

    func testGrahamScanConvexHull_twoPoints() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
            ]
        )

        let result = sut.grahamScanConvexHull()

        TestFixture.beginFixture(lineScale: 30, renderScale: 15) { fixture in
            let asLinePolygon = LinePolygon2(vertices: result.points)
            fixture.add(sut)
            fixture.add(asLinePolygon)

            fixture.assertEquals(result.points, [])
        }
    }

    func testGrahamScanConvexHull_withColinearPoints() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 3.0, y: -11.0),
                .init(x: 2.0, y: -10.0),
                .init(x: 1.0, y: -9.0),
                .init(x: -3.0, y: -7.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 2.0, y: 3.0),
                .init(x: 12.0, y: -10.0),
            ]
        )

        let result = sut.grahamScanConvexHull()

        TestFixture.beginFixture(lineScale: 30, renderScale: 15) { fixture in
            let asLinePolygon = LinePolygon2(vertices: result.points)
            fixture.add(sut)
            fixture.add(asLinePolygon)

            fixture.assertEquals(result.points, [
                .init(x: 3.0, y: -11.0),
                .init(x: -3.0, y: -7.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 12.0, y: -10.0),
            ])
        }
    }

    func testGrahamScanConvexHull_strictlyColinearPoints() {
        let sut = Sut(
            points: [
                .init(x: 3.0, y: -11.0),
                .init(x: 2.0, y: -10.0),
                .init(x: 1.0, y: -9.0),
            ]
        )

        let result = sut.grahamScanConvexHull()

        TestFixture.beginFixture(lineScale: 30, renderScale: 15) { fixture in
            let asLinePolygon = LinePolygon2(vertices: result.points)
            fixture.add(sut)
            fixture.add(asLinePolygon)

            fixture.assertEquals(result.points, [])
        }
    }

    func testGrahamScanConvexHull_strictlyColinearPointsExceptOne() {
        let sut = Sut(
            points: [
                .init(x: 3.0, y: -11.0),
                .init(x: 2.0, y: -10.0),
                .init(x: 1.0, y: -9.0),
                .init(x: 0.0, y: -8.0),
                .init(x: 10.0, y: -8.0),
            ]
        )

        let result = sut.grahamScanConvexHull()

        TestFixture.beginFixture(lineScale: 30, renderScale: 15) { fixture in
            let asLinePolygon = LinePolygon2(vertices: result.points)
            fixture.add(sut)
            fixture.add(asLinePolygon)

            fixture.assertEquals(result.points, [
                .init(x: 3.0, y: -11.0),
                .init(x: 0.0, y: -8.0),
                .init(x: 10.0, y: -8.0),
            ])
        }
    }

    #if GEOMETRIA_PERFORMANCE_TESTS

    // MARK: - Performance tests

    func testPerformance_grahamScanConvexHull() {
        let random = MersenneTwister(seed: 0x1234)
        let sut = PointCloud2<Vector2D>(
            points: random.randomVectors(
                count: 1_000,
                { random in random.randomScalar(range: 0...100) }
            )
        )

        measure {
            for _ in 0..<50 {
                _ = sut.grahamScanConvexHull()
            }
        }
    }

    #endif
}
