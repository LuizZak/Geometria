import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class LinePolygon2PeriodicTests: XCTestCase {
    typealias Sut = LinePolygon2Periodic<Vector2D>

    func testEphemeral() {
        let sut = Sut.makeStar()

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertSimplexes([
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: 100.0, y: 0.0),
                                end: .init(x: 32.3606797749979, y: 23.511410091698927)
                            ),
                            startPeriod: 0.0,
                            endPeriod: 0.10000000000000002
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: 32.3606797749979, y: 23.511410091698927),
                                end: .init(x: 30.901699437494745, y: 95.10565162951535)
                            ),
                            startPeriod: 0.10000000000000002,
                            endPeriod: 0.2
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: 30.901699437494745, y: 95.10565162951535),
                                end: .init(x: -12.360679774997894, y: 38.042260651806146)
                            ),
                            startPeriod: 0.2,
                            endPeriod: 0.3
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -12.360679774997894, y: 38.042260651806146),
                                end: .init(x: -80.90169943749473, y: 58.77852522924732)
                            ),
                            startPeriod: 0.3,
                            endPeriod: 0.4
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -80.90169943749473, y: 58.77852522924732),
                                end: .init(x: -40.0, y: 4.898587196589413e-15)
                            ),
                            startPeriod: 0.4,
                            endPeriod: 0.5
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -40.0, y: 4.898587196589413e-15),
                                end: .init(x: -80.90169943749476, y: -58.7785252292473)
                            ),
                            startPeriod: 0.5,
                            endPeriod: 0.6
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -80.90169943749476, y: -58.7785252292473),
                                end: .init(x: -12.360679774997903, y: -38.04226065180614)
                            ),
                            startPeriod: 0.6,
                            endPeriod: 0.7000000000000001
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -12.360679774997903, y: -38.04226065180614),
                                end: .init(x: 30.901699437494724, y: -95.10565162951536)
                            ),
                            startPeriod: 0.7000000000000001,
                            endPeriod: 0.8
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: 30.901699437494724, y: -95.10565162951536),
                                end: .init(x: 32.36067977499789, y: -23.511410091698934)
                            ),
                            startPeriod: 0.8,
                            endPeriod: 0.8999999999999999
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: 32.36067977499789, y: -23.511410091698934),
                                end: .init(x: 100.0, y: 0.0)
                            ),
                            startPeriod: 0.8999999999999999,
                            endPeriod: 1.0
                        )
                    ),
                ])
        }
    }
}
