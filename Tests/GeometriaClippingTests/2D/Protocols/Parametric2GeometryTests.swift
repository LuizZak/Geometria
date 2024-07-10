import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Parametric2GeometryTests: XCTestCase {
    func testClampedSimplexes_lines() {
        let sut = LinePolygon2Parametric.makeStar()

        let result = sut.clampedSimplexes(in: 0.3..<0.73)

        TestFixture.beginFixture { fixture in
            fixture.add(result)

            fixture.assertEquals(
                result,
                [
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -12.360679774997932, y: 38.04226065180616),
                                end: .init(x: -80.90169943749473, y: 58.77852522924732)
                            ),
                            startPeriod: 0.3,
                            endPeriod: 0.3999999999999999
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -80.90169943749473, y: 58.77852522924732),
                                end: .init(x: -40.0, y: 7.105427357601002e-15)
                            ),
                            startPeriod: 0.3999999999999999,
                            endPeriod: 0.49999999999999994
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -40.0, y: 4.898587196589413e-15),
                                end: .init(x: -80.90169943749476, y: -58.7785252292473)
                            ),
                            startPeriod: 0.49999999999999994,
                            endPeriod: 0.5999999999999999
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -80.90169943749476, y: -58.7785252292473),
                                end: .init(x: -12.360679774997905, y: -38.04226065180614)
                            ),
                            startPeriod: 0.5999999999999999,
                            endPeriod: 0.6999999999999998
                        )
                    ),
                    .lineSegment2(
                        .init(
                            lineSegment: .init(
                                start: .init(x: -12.360679774997903, y: -38.04226065180614),
                                end: .init(x: 0.6180339887499462, y: -55.16127794511899)
                            ),
                            startPeriod: 0.6999999999999998,
                            endPeriod: 0.73
                        )
                    ),
                ]
            )
        }
    }

    func testAllIntersectionPeriods_lines_lines() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = LinePolygon2Parametric.makeHexagon()

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: lhs)
                .assertIntersections(
                    rhs,
                    [
                        .pair(
                            (self: 0.811876808900308, other: 0.8017916329067885),
                            (self: 0.0, other: 0.0)
                        ),
                        .pair(
                            (self: 0.18812319109969183, other: 0.19820836709321155),
                            (self: 0.21490116711499505, other: 0.20924149997813613)
                        ),
                        .pair(
                            (self: 0.38157132764617224, other: 0.3942349983197353),
                            (self: 0.419826286868721, other: 0.4093080372427832)
                        ),
                        .pair(
                            (self: 0.5801737131312789, other: 0.5906919627572167),
                            (self: 0.6184286723538276, other: 0.6057650016802647)
                        ),
                        .singlePoint((self: 0.7850988328850047, other: 0.7907585000218638)),
                    ]
                )
        }
    }

    func testAllIntersectionPeriods_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = Circle2Parametric.makeTestCircle(radius: 80.0)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: lhs)
                .assertIntersections(
                    rhs,
                    [
                        .pair(
                            (self: 0.9699698691779199, other: 0.9859352679625649),
                            (self: 0.030030130822079993, other: 0.014064732037435027)
                        ),
                        .pair(
                            (self: 0.16996986917792, other: 0.18593526796256496),
                            (self: 0.2300301308220799, other: 0.21406473203743503)
                        ),
                        .pair(
                            (self: 0.36996986917791996, other: 0.385935267962565),
                            (self: 0.4300301308220799, other: 0.414064732037435)
                        ),
                        .pair(
                            (self: 0.5699698691779199, other: 0.5859352679625649),
                            (self: 0.6300301308220798, other: 0.614064732037435)
                        ),
                        .pair(
                            (self: 0.7699698691779199, other: 0.7859352679625649),
                            (self: 0.8300301308220798, other: 0.8140647320374349)
                        ),
                    ]
                )
        }
    }

    func testAllIntersectionPeriods_lines_arcs_vertexIntersections() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = Circle2Parametric.makeTestCircle()

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: lhs)
                .assertIntersections(
                    rhs,
                    [
                        .pair(
                            (self: 1.0, other: 0.0),
                            (self: 2.2204460492503132e-17, other: 8.308813937217956e-18)
                        ),
                        .pair(
                            (self: 0.19999999999999996, other: 0.2),
                            (self: 0.3999999999999999, other: 0.4)
                        ),
                        .pair(
                            (self: 0.5999999999999999, other: 0.6),
                            (self: 0.7999999999999998, other: 0.8)
                        ),
                    ]
                )
        }
    }

    func testAllIntersectionPeriods_lines_arcs_vertexIntersections_withTolerance() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = Circle2Parametric.makeTestCircle()

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: lhs)
                .assertIntersections(
                    rhs,
                    tolerance: 1e-14,
                    [
                        .pair(
                            (self: 1.0, other: 0.0),
                            (self: 2.2204460492503132e-17, other: 8.308813937217956e-18)
                        ),
                        .pair(
                            (self: 0.19999999999999996, other: 0.2),
                            (self: 0.3999999999999999, other: 0.4)
                        ),
                        .pair(
                            (self: 0.5999999999999999, other: 0.6),
                            (self: 0.7999999999999998, other: 0.8)
                        ),
                    ]
                )
        }
    }

    func testAllIntersectionPeriods_lines_arcs_vertexIntersections_infiniteTolerance() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = Circle2Parametric.makeTestCircle()

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: lhs)
                .assertIntersections(
                    rhs,
                    tolerance: .infinity,
                    [
                        .pair(
                            (self: 1.0, other: 0.0),
                            (self: 2.2204460492503132e-17, other: 8.308813937217956e-18)
                        ),
                        .pair(
                            (self: 0.19999999999999996, other: 0.2),
                            (self: 0.19999999999999996, other: 0.2)
                        ),
                        .pair(
                            (self: 0.3999999999999999, other: 0.4),
                            (self: 0.3999999999999999, other: 0.4)
                        ),
                        .pair(
                            (self: 0.5999999999999999, other: 0.6),
                            (self: 0.5999999999999999, other: 0.6)
                        ),
                        .pair(
                            (self: 0.7999999999999998, other: 0.8),
                            (self: 0.7999999999999998, other: 0.8)
                        ),
                    ]
                )
        }
    }
}
