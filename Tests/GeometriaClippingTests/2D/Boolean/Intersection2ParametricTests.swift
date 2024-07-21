import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Intersection2ParametricTests: XCTestCase {
    func testIntersection_lhsContainsRhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([rhs.allSimplexes()])
        }
    }

    func testIntersection_rhsContainsLhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([lhs.allSimplexes()])
        }
    }

    func testIntersection_noIntersectionOrContainment() {
        let lhs = Circle2Parametric.makeTestCircle(center: .init(x: -100, y: 0), radius: 50.0)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 100, y: 0), radius: 50.0)
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([])
        }
    }

    func testIntersection_lines_lines() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = LinePolygon2Parametric.makeHexagon(radius: 80.0)
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2.0) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 74.97851895895208, y: -8.697460292338846),
                                        end: .init(x: 80.0, y: 0.0)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.019285015693457187
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 80.0, y: 0.0),
                                        end: .init(x: 74.9785189589521, y: 8.697460292338839)
                                    ),
                                    startPeriod: 0.019285015693457187,
                                    endPeriod: 0.038570031386914345
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 74.9785189589521, y: 8.697460292338837),
                                        end: .init(x: 32.36067977499789, y: 23.511410091698927)
                                    ),
                                    startPeriod: 0.038570031386914345,
                                    endPeriod: 0.12521006592062212
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 32.3606797749979, y: 23.511410091698927),
                                        end: .init(x: 31.42794501299971, y: 69.28203230275507)
                                    ),
                                    startPeriod: 0.12521006592062212,
                                    endPeriod: 0.21311943202887662
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 31.427945012999707, y: 69.28203230275508),
                                        end: .init(x: 11.323626827162727, y: 69.28203230275508)
                                    ),
                                    startPeriod: 0.21311943202887662,
                                    endPeriod: 0.2517247845683749
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 11.323626827162714, y: 69.28203230275508),
                                        end: .init(x: -12.360679774997894, y: 38.042260651806146)
                                    ),
                                    startPeriod: 0.2517247845683749,
                                    endPeriod: 0.32700427999958576
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -12.360679774997894, y: 38.042260651806146),
                                        end: .init(x: -51.244447041333736, y: 49.80607872414753)
                                    ),
                                    startPeriod: 0.32700427999958576,
                                    endPeriod: 0.405013188049299
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -51.24444704133373, y: 49.806078724147525),
                                        end: .init(x: -61.86160744855664, y: 31.416617466728784)
                                    ),
                                    startPeriod: 0.405013188049299,
                                    endPeriod: 0.4457884301341555
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -61.86160744855665, y: 31.41661746672879),
                                        end: .init(x: -40.0, y: 7.105427357601002e-15)
                                    ),
                                    startPeriod: 0.4457884301341555,
                                    endPeriod: 0.5192850156934571
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -40.0, y: 4.898587196589413e-15),
                                        end: .init(x: -61.86160744855664, y: -31.416617466728745)
                                    ),
                                    startPeriod: 0.5192850156934571,
                                    endPeriod: 0.5927816012527586
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -61.86160744855667, y: -31.41661746672875),
                                        end: .init(x: -51.24444704133375, y: -49.806078724147525)
                                    ),
                                    startPeriod: 0.5927816012527586,
                                    endPeriod: 0.6335568433376151
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -51.24444704133376, y: -49.80607872414752),
                                        end: .init(x: -12.360679774997905, y: -38.04226065180614)
                                    ),
                                    startPeriod: 0.6335568433376151,
                                    endPeriod: 0.7115657513873282
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -12.360679774997903, y: -38.04226065180614),
                                        end: .init(x: 11.323626827162698, y: -69.28203230275508)
                                    ),
                                    startPeriod: 0.7115657513873282,
                                    endPeriod: 0.7868452468185392
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 11.323626827162663, y: -69.28203230275508),
                                        end: .init(x: 31.427945012999675, y: -69.28203230275508)
                                    ),
                                    startPeriod: 0.7868452468185392,
                                    endPeriod: 0.8254505993580376
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 31.427945012999693, y: -69.28203230275513),
                                        end: .init(x: 32.36067977499789, y: -23.511410091698934)
                                    ),
                                    startPeriod: 0.8254505993580376,
                                    endPeriod: 0.9133599654662922
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 32.36067977499789, y: -23.511410091698934),
                                        end: .init(x: 74.97851895895208, y: -8.697460292338846)
                                    ),
                                    startPeriod: 0.9133599654662922,
                                    endPeriod: 1.0
                                )
                            ),
                        ]
                    ]
                )
        }
    }

    func testIntersection_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95)

        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2.0) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 0.09997590556877552)), startPeriod: 0.0, endPeriod: 0.01630263405700258)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 94.52562418976665, y: 9.481897043050221), end: Vector2<Double>(x: 55.47437581023338, y: 77.12064333539362)), startPeriod: 0.01630263405700258, endPeriod: 0.150364032609664)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 0.947221645627822), sweepAngle: Angle<Double>(radians: 0.19995181113755164)), startPeriod: 0.150364032609664, endPeriod: 0.18296930072366926)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 39.051248379533256, y: 86.60254037844386), end: Vector2<Double>(x: -39.05124837953324, y: 86.60254037844388)), startPeriod: 0.18296930072366926, endPeriod: 0.31703069927633065)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 1.9944191968244196), sweepAngle: Angle<Double>(radians: 0.19995181113755145)), startPeriod: 0.31703069927633065, endPeriod: 0.3496359673903359)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -55.47437581023333, y: 77.12064333539367), end: Vector2<Double>(x: -94.52562418976665, y: 9.481897043050225)), startPeriod: 0.3496359673903359, endPeriod: 0.48369736594299745)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 3.0416167480210174), sweepAngle: Angle<Double>(radians: 0.1999518111375514)), startPeriod: 0.48369736594299745, endPeriod: 0.5163026340570027)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -94.52562418976665, y: -9.481897043050205), end: Vector2<Double>(x: -55.4743758102334, y: -77.12064333539362)), startPeriod: 0.5163026340570027, endPeriod: 0.6503640326096641)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 4.088814299217614), sweepAngle: Angle<Double>(radians: 0.19995181113755148)), startPeriod: 0.6503640326096641, endPeriod: 0.6829693007236693)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -39.051248379533334, y: -86.60254037844383), end: Vector2<Double>(x: 39.051248379533305, y: -86.60254037844386)), startPeriod: 0.6829693007236693, endPeriod: 0.817030699276331)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 5.136011850414214), sweepAngle: Angle<Double>(radians: 0.19995181113755003)), startPeriod: 0.817030699276331, endPeriod: 0.849635967390336)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 55.47437581023337, y: -77.12064333539365), end: Vector2<Double>(x: 94.52562418976665, y: -9.48189704305021)), startPeriod: 0.849635967390336, endPeriod: 0.9836973659429974)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 6.183209401610812), sweepAngle: Angle<Double>(radians: 0.09997590556877499)), startPeriod: 0.9836973659429974, endPeriod: 1.0))]]
                )
        }
    }

    func testIntersection_concaveShape() {
        let lhs = LinePolygon2Parametric.makeCShape()
        let rhs = LinePolygon2Parametric.makeRectangle(width: 10, height: 120)
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: 50.00000000000001),
                                        end: .init(x: -5.0, y: 29.999999999999993)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.33333333333333354
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.000000000000022, y: 30.0),
                                        end: .init(x: 4.999999999999996, y: 30.0)
                                    ),
                                    startPeriod: 0.33333333333333354,
                                    endPeriod: 0.5000000000000004
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: 29.999999999999986),
                                        end: .init(x: 5.0, y: 50.00000000000001)
                                    ),
                                    startPeriod: 0.5000000000000004,
                                    endPeriod: 0.8333333333333341
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 4.999999999999977, y: 50.0),
                                        end: .init(x: -4.999999999999972, y: 50.0)
                                    ),
                                    startPeriod: 0.8333333333333341,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: -29.999999999999986),
                                        end: .init(x: -5.0, y: -49.999999999999986)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.3333333333333334
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -4.999999999999999, y: -50.0),
                                        end: .init(x: 5.000000000000004, y: -50.0)
                                    ),
                                    startPeriod: 0.3333333333333334,
                                    endPeriod: 0.5000000000000002
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: -50.0),
                                        end: .init(x: 5.0, y: -30.0)
                                    ),
                                    startPeriod: 0.5000000000000002,
                                    endPeriod: 0.8333333333333336
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 4.999999999999982, y: -30.0),
                                        end: .init(x: -4.999999999999996, y: -30.0)
                                    ),
                                    startPeriod: 0.8333333333333336,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                    ]
                )
        }
    }
}