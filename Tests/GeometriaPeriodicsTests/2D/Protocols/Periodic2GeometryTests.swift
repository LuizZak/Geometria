import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class Periodic2GeometryTests: XCTestCase {
    func testClampedSimplexes_lines() {
        let sut = LinePolygon2Periodic.makeStar()

        let result = sut.clampedSimplexes(in: 0.3..<0.73)

        TestFixture.beginFixture { fixture in
            fixture.add(result)

            fixture.assertEquals(result, [
                .lineSegment2(
                    .init(
                        lineSegment: .init(start: .init(x: -12.360679774997894, y: 38.042260651806146),
                        end: .init(x: -80.90169943749473, y: 58.77852522924732)),
                        startPeriod: 0.3,
                        endPeriod: 0.4
                    )
                ),
                .lineSegment2(
                    .init(
                        lineSegment: .init(start: .init(x: -80.90169943749473, y: 58.77852522924732),
                        end: .init(x: -40.0, y: 7.105427357601002e-15)),
                        startPeriod: 0.4,
                        endPeriod: 0.5
                    )
                ),
                .lineSegment2(
                    .init(
                        lineSegment: .init(start: .init(x: -40.0, y: 4.898587196589413e-15),
                        end: .init(x: -80.90169943749476, y: -58.7785252292473)),
                        startPeriod: 0.5,
                        endPeriod: 0.6
                    )
                ),
                .lineSegment2(
                    .init(
                        lineSegment: .init(start: .init(x: -80.90169943749476, y: -58.7785252292473),
                        end: .init(x: -12.360679774997905, y: -38.04226065180614)),
                        startPeriod: 0.6,
                        endPeriod: 0.7000000000000001
                    )
                ),
                .lineSegment2(
                    .init(
                        lineSegment: .init(start: .init(x: -12.360679774997903, y: -38.04226065180614),
                        end: .init(x: 0.6180339887498502, y: -55.16127794511886)),
                        startPeriod: 0.7000000000000001,
                        endPeriod: 0.73
                    )
                ),
            ])
        }
    }
}
