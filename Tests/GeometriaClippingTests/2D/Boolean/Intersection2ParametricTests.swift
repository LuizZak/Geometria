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

    func testIntersection_rhsOccludesLhsHole() {
        let radius: Double = 50.0
        let circles = [
            Circle2Parametric.makeTestCircle(center: .init(x: 110, y: 95), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: 63, y: 11), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: 158, y: 13), radius: radius),
        ]
        let lhs = union(circles)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 110, y: 40), radius: radius)
        let sut: Intersection2Parametric = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.add(lhs, category: "input 1")
            fixture.add(rhs, category: "input 2")

            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.4768080622098925), sweepAngle: Angle<Double>(radians: 0.23558091817479668)), startPeriod: 0.0, endPeriod: 0.17784752113040336)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 0.21253518486108167)), startPeriod: 0.17784752113040336, endPeriod: 0.3382970858633558)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 2.417440339497967), sweepAngle: Angle<Double>(radians: 0.42831624888451314)), startPeriod: 0.3382970858633558, endPeriod: 0.6616466326524686)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.33793510948140565), sweepAngle: Angle<Double>(radians: 0.44819065478466874)), startPeriod: 0.6616466326524686, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.7239568914585366), sweepAngle: Angle<Double>(radians: 0.20376152639733072)), startPeriod: 0.0, endPeriod: 0.029580950916893424)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.3352154086201007), sweepAngle: Angle<Double>(radians: 0.20333977272057271)), startPeriod: 0.029580950916893424, endPeriod: 0.059100674010106)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 2.708719915434198), sweepAngle: Angle<Double>(radians: 0.43287273815559496)), startPeriod: 0.059100674010106, endPeriod: 0.12194270040753713)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5385551813406726)), startPeriod: 0.12194270040753713, endPeriod: 0.34530147724268506)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 5.85031256902399), sweepAngle: Angle<Double>(radians: 0.13703667294828284)), startPeriod: 0.34530147724268506, endPeriod: 0.36519568969765537)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.479527763071199), sweepAngle: Angle<Double>(radians: 0.13723703091386882)), startPeriod: 0.36519568969765537, endPeriod: 0.3851189889937512)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.783234246162836), sweepAngle: Angle<Double>(radians: 1.4999510610167501)), startPeriod: 0.3851189889937512, endPeriod: 0.6028734370398371)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 0.4751721403952749)), startPeriod: 0.6028734370398371, endPeriod: 0.6718562524448357)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.6416415925730437), sweepAngle: Angle<Double>(radians: 0.14168991908293524)), startPeriod: 0.6718562524448357, endPeriod: 0.6924259969688237)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 5.55903299308776), sweepAngle: Angle<Double>(radians: 0.14178807622308356)), startPeriod: 0.6924259969688237, endPeriod: 0.7130099913936452)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.5823642378687435), sweepAngle: Angle<Double>(radians: 0.9884320889261534)), startPeriod: 0.7130099913936452, endPeriod: 0.8565049956968226)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 0.988432088926153)), startPeriod: 0.8565049956968226, endPeriod: 1.0))]]
                )
        }
    }

    func testIntersection_lhsOccludesRhsHole() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 90.0)
        let rhs1 = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs2 = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Compound2Parametric(contours: Subtraction2Parametric(rhs1, rhs2).allContours())
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 90.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 90.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.25, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 90.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.5, endPeriod: 0.75)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 90.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.75, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 6.283185307179586), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.25, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.5, endPeriod: 0.7499999999999999)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.7499999999999999, endPeriod: 1.0))]]
                )
        }
    }

    func testIntersection_lhsIntersectsRhsHole() {
        let lhs = Circle2Parametric.makeTestCircle(center: .init(x: -25, y: 30), radius: 90.0)
        let rhs1 = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs2 = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Compound2Parametric(contours: Subtraction2Parametric(rhs1, rhs2).allContours())
        let sut = Intersection2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.2733816824391754)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 0.24078002432419543)), startPeriod: 0.2733816824391754, endPeriod: 0.31528708228296365)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -25.0, y: 30.0), radius: 90.0, startAngle: Angle<Double>(radians: 3.782956891537647), sweepAngle: Angle<Double>(radians: 0.5300169060962322)), startPeriod: 0.31528708228296365, endPeriod: 0.39830689836879707)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 3.8643426603950917), sweepAngle: Angle<Double>(radians: -0.7227500068052987)), startPeriod: 0.39830689836879707, endPeriod: 0.498936933961773)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.498936933961773, endPeriod: 0.7176422799131134)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 80.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: -0.9040697812067885)), startPeriod: 0.7176422799131134, endPeriod: 0.8435178570902178)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -25.0, y: 30.0), radius: 90.0, startAngle: Angle<Double>(radians: 0.21809540834932092), sweepAngle: Angle<Double>(radians: 0.5300169060962318)), startPeriod: 0.8435178570902178, endPeriod: 0.9265376731760512)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 1.1486965280692114), sweepAngle: Angle<Double>(radians: 0.4220997987256852)), startPeriod: 0.9265376731760512, endPeriod: 1.0))]]
                )
        }
    }
}
