import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Subtraction2ParametricTests: XCTestCase {
    func testSubtraction_lhsContainsRhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([lhs.allSimplexes(), rhs.allSimplexes()])
        }
    }

    func testSubtraction_rhsContainsLhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([])
        }
    }

    func testSubtraction_noIntersectionOrContainment() {
        let lhs = Circle2Parametric.makeTestCircle(center: .init(x: -100, y: 0), radius: 50.0)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 100, y: 0), radius: 50.0)
        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([lhs.allSimplexes()])
        }
    }

    func testSubtraction_lines_lines() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = LinePolygon2Parametric.makeHexagon(radius: 80.0)
        let sut = Subtraction2Parametric(lhs, rhs)

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
                                        end: .init(x: 100.0, y: 0.0)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.36254932092322967
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 100.0, y: 0.0),
                                        end: .init(x: 74.97851895895208, y: 8.697460292338842)
                                    ),
                                    startPeriod: 0.36254932092322967,
                                    endPeriod: 0.7250986418464593
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 74.9785189589521, y: 8.697460292338839),
                                        end: .init(x: 80.0, y: 0.0)
                                    ),
                                    startPeriod: 0.7250986418464593,
                                    endPeriod: 0.8625493209232296
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 80.0, y: 0.0),
                                        end: .init(x: 74.97851895895208, y: -8.69746029233885)
                                    ),
                                    startPeriod: 0.8625493209232296,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 31.42794501299971, y: 69.28203230275507),
                                        end: .init(x: 30.901699437494745, y: 95.10565162951536)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.32970581961304946
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 30.901699437494745, y: 95.10565162951535),
                                        end: .init(x: 11.323626827162714, y: 69.28203230275508)
                                    ),
                                    startPeriod: 0.32970581961304946,
                                    endPeriod: 0.7433692504284606
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 11.323626827162721, y: 69.28203230275508),
                                        end: .init(x: 31.42794501299974, y: 69.28203230275508)
                                    ),
                                    startPeriod: 0.7433692504284606,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -51.244447041333736, y: 49.80607872414753),
                                        end: .init(x: -80.90169943749473, y: 58.77852522924732)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.36216749184802843
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -80.90169943749473, y: 58.77852522924732),
                                        end: .init(x: -61.86160744855665, y: 31.41661746672879)
                                    ),
                                    startPeriod: 0.36216749184802843,
                                    endPeriod: 0.7518014519098778
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -61.86160744855665, y: 31.41661746672877),
                                        end: .init(x: -51.24444704133373, y: 49.80607872414752)
                                    ),
                                    startPeriod: 0.7518014519098778,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -61.86160744855664, y: -31.416617466728745),
                                        end: .init(x: -80.90169943749476, y: -58.7785252292473)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.38963396006184975
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -80.90169943749476, y: -58.7785252292473),
                                        end: .init(x: -51.24444704133376, y: -49.80607872414752)
                                    ),
                                    startPeriod: 0.38963396006184975,
                                    endPeriod: 0.7518014519098781
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -51.24444704133375, y: -49.80607872414752),
                                        end: .init(x: -61.861607448556654, y: -31.416617466728773)
                                    ),
                                    startPeriod: 0.7518014519098781,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 11.323626827162698, y: -69.28203230275508),
                                        end: .init(x: 30.90169943749472, y: -95.10565162951536)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.4136634308154115
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 30.901699437494724, y: -95.10565162951536),
                                        end: .init(x: 31.427945012999693, y: -69.28203230275513)
                                    ),
                                    startPeriod: 0.4136634308154115,
                                    endPeriod: 0.7433692504284606
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 31.427945012999697, y: -69.28203230275508),
                                        end: .init(x: 11.323626827162686, y: -69.28203230275508)
                                    ),
                                    startPeriod: 0.7433692504284606,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                    ]
                )
        }
    }

    func testSubtraction_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95)

        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2.0) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 0.0), end: Vector2<Double>(x: 94.52562418976665, y: 9.481897043050221)), startPeriod: 0.0, endPeriod: 0.26774195146010393)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.00000000000004, startAngle: Angle<Double>(radians: 0.09997590556877452), sweepAngle: Angle<Double>(radians: -0.09997590556877572)), startPeriod: 0.26774195146010393, endPeriod: 0.5000000000000009)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 94.99999999999997, startAngle: Angle<Double>(radians: 6.338998133474957e-16), sweepAngle: Angle<Double>(radians: -0.0999759055687752)), startPeriod: 0.5000000000000009, endPeriod: 0.7322580485398963)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 94.52562418976665, y: -9.48189704305021), end: Vector2<Double>(x: 100.0, y: 0.0)), startPeriod: 0.7322580485398963, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 55.47437581023338, y: 77.12064333539362), end: Vector2<Double>(x: 50.000000000000014, y: 86.60254037844386)), startPeriod: 0.0, endPeriod: 0.26774195146010366)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.000000000000014, y: 86.60254037844386), end: Vector2<Double>(x: 39.051248379533256, y: 86.60254037844386)), startPeriod: 0.26774195146010366, endPeriod: 0.5354839029202078)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.00000000000001, startAngle: Angle<Double>(radians: 1.1471734567653737), sweepAngle: Angle<Double>(radians: -0.19995181113755148)), startPeriod: 0.5354839029202078, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -39.05124837953324, y: 86.60254037844388), end: Vector2<Double>(x: -49.99999999999998, y: 86.60254037844388)), startPeriod: 0.0, endPeriod: 0.2677419514601042)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -49.99999999999998, y: 86.60254037844388), end: Vector2<Double>(x: -55.47437581023333, y: 77.12064333539367)), startPeriod: 0.2677419514601042, endPeriod: 0.5354839029202076)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 94.99999999999982, startAngle: Angle<Double>(radians: 2.1943710079619705), sweepAngle: Angle<Double>(radians: -0.19995181113755145)), startPeriod: 0.5354839029202076, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -94.52562418976665, y: 9.481897043050225), end: Vector2<Double>(x: -100.0, y: 1.2246467991473532e-14)), startPeriod: 0.0, endPeriod: 0.26774195146010377)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: 1.2246467991473532e-14), end: Vector2<Double>(x: -94.52562418976665, y: -9.481897043050205)), startPeriod: 0.26774195146010377, endPeriod: 0.5354839029202078)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 94.99999999999977, startAngle: Angle<Double>(radians: -3.041616748021019), sweepAngle: Angle<Double>(radians: -0.09997590556877572)), startPeriod: 0.5354839029202078, endPeriod: 0.7677419514601039)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 94.9999999999997, startAngle: Angle<Double>(radians: -3.1415926535897922), sweepAngle: Angle<Double>(radians: -0.09997590556877574)), startPeriod: 0.7677419514601039, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -55.4743758102334, y: -77.12064333539362), end: Vector2<Double>(x: -50.00000000000004, y: -86.60254037844383)), startPeriod: 0.0, endPeriod: 0.2677419514601039)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -50.00000000000004, y: -86.60254037844383), end: Vector2<Double>(x: -39.051248379533334, y: -86.60254037844383)), startPeriod: 0.2677419514601039, endPeriod: 0.5354839029202076)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 94.99999999999967, startAngle: Angle<Double>(radians: -1.9944191968244198), sweepAngle: Angle<Double>(radians: -0.19995181113755148)), startPeriod: 0.5354839029202076, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 39.051248379533305, y: -86.60254037844386), end: Vector2<Double>(x: 50.000000000000014, y: -86.60254037844386)), startPeriod: 0.0, endPeriod: 0.2677419514601039)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.000000000000014, y: -86.60254037844386), end: Vector2<Double>(x: 55.47437581023337, y: -77.12064333539365)), startPeriod: 0.2677419514601039, endPeriod: 0.5354839029202078)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.00000000000018, startAngle: Angle<Double>(radians: -0.9472216456278225), sweepAngle: Angle<Double>(radians: -0.1999518111375504)), startPeriod: 0.5354839029202078, endPeriod: 1.0))]]
                )
        }
    }

    func testSubtraction_concaveShape() {
        let lhs = LinePolygon2Parametric.makeCShape()
        let rhs = LinePolygon2Parametric.makeRectangle(width: 10, height: 120)
        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.0, y: -50.0), end: Vector2<Double>(x: 30.0, y: -30.0)), startPeriod: 0.0, endPeriod: 0.23912115236596865)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 30.0, y: -30.0), end: Vector2<Double>(x: 4.999999999999982, y: -30.0)), startPeriod: 0.23912115236596865, endPeriod: 0.4504763878198664)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 4.999999999999982, y: -30.0), end: Vector2<Double>(x: 5.000000000000004, y: -50.0)), startPeriod: 0.4504763878198664, endPeriod: 0.6195605761829844)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 5.000000000000004, y: -50.0), end: Vector2<Double>(x: 50.0, y: -50.0)), startPeriod: 0.6195605761829844, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -30.0, y: -30.0), end: Vector2<Double>(x: -30.0, y: 30.0)), startPeriod: 0.0, endPeriod: 0.17647058823529413)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -30.0, y: 30.0), end: Vector2<Double>(x: -5.000000000000022, y: 30.0)), startPeriod: 0.17647058823529413, endPeriod: 0.24999999999999992)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -5.000000000000022, y: 30.0), end: Vector2<Double>(x: -4.999999999999972, y: 50.0)), startPeriod: 0.24999999999999992, endPeriod: 0.3088235294117646)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -4.999999999999972, y: 50.0), end: Vector2<Double>(x: -50.0, y: 50.0)), startPeriod: 0.3088235294117646, endPeriod: 0.4411764705882353)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -50.0, y: 50.0), end: Vector2<Double>(x: -50.0, y: -50.0)), startPeriod: 0.4411764705882353, endPeriod: 0.7352941176470589)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -50.0, y: -50.0), end: Vector2<Double>(x: -4.999999999999999, y: -50.0)), startPeriod: 0.7352941176470589, endPeriod: 0.8676470588235294)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -4.999999999999999, y: -50.0), end: Vector2<Double>(x: -4.999999999999996, y: -30.0)), startPeriod: 0.8676470588235294, endPeriod: 0.9264705882352942)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -4.999999999999996, y: -30.0), end: Vector2<Double>(x: -30.0, y: -30.0)), startPeriod: 0.9264705882352942, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 30.0, y: 30.0), end: Vector2<Double>(x: 50.0, y: 50.0)), startPeriod: 0.0, endPeriod: 0.2391211523659686)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.0, y: 50.0), end: Vector2<Double>(x: 4.999999999999977, y: 50.0)), startPeriod: 0.2391211523659686, endPeriod: 0.6195605761829844)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 4.999999999999977, y: 50.0), end: Vector2<Double>(x: 4.999999999999996, y: 30.0)), startPeriod: 0.6195605761829844, endPeriod: 0.7886447645461024)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 4.999999999999996, y: 30.0), end: Vector2<Double>(x: 30.0, y: 30.0)), startPeriod: 0.7886447645461024, endPeriod: 1.0))]]
                )
        }
    }

    func testSubtraction_rhsOccludesLhsHole() {
        let radius: Double = 50.0
        let circles = [
            Circle2Parametric.makeTestCircle(center: .init(x: 0, y: 55), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: -47, y: -29), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: 48, y: -27), radius: radius),
        ]
        let lhs = union(circles)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 0, y: 0), radius: radius)
        let sut: Subtraction2Parametric = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture(lineScale: 5.0, renderScale: 2.5) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 49.999999999999986, startAngle: Angle<Double>(radians: -4.580921805575008e-16), sweepAngle: Angle<Double>(radians: -1.4999510610167501)), startPeriod: 0.0, endPeriod: 0.23872462575674885)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 48.0, y: -27.0), radius: 49.99999999999998, startAngle: Angle<Double>(radians: -2.6664205131945193), sweepAngle: Angle<Double>(radians: 1.0956241863996228)), startPeriod: 0.23872462575674885, endPeriod: 0.41309863079328485)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 48.0, y: -27.0), radius: 50.00000000000001, startAngle: Angle<Double>(radians: -1.5707963267948968), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.41309863079328485, endPeriod: 0.6630986307932849)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 48.0, y: -27.0), radius: 49.99999999999993, startAngle: Angle<Double>(radians: -7.815970093361113e-16), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.6630986307932849, endPeriod: 0.9130986307932847)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 48.0, y: -27.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948946), sweepAngle: Angle<Double>(radians: 0.07084526577814866)), startPeriod: 0.9130986307932847, endPeriod: 0.924374005036536)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 50.000000000000064, startAngle: Angle<Double>(radians: 0.4751721403952742), sweepAngle: Angle<Double>(radians: -0.4751721403952737)), startPeriod: 0.924374005036536, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 55.0), radius: 50.00000000000003, startAngle: Angle<Double>(radians: 3.141592653589791), sweepAngle: Angle<Double>(radians: 0.5823642378687454)), startPeriod: 0.0, endPeriod: 0.09268614713675519)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 49.99999999999999, startAngle: Angle<Double>(radians: 2.5592284157210496), sweepAngle: Angle<Double>(radians: -0.9884320889261541)), startPeriod: 0.09268614713675519, endPeriod: 0.2500000000000004)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: -0.9884320889261533)), startPeriod: 0.2500000000000004, endPeriod: 0.4073138528632455)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 55.0), radius: 50.00000000000001, startAngle: Angle<Double>(radians: -0.5823642378687431), sweepAngle: Angle<Double>(radians: 0.5823642378687435)), startPeriod: 0.4073138528632455, endPeriod: 0.5000000000000003)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 55.0), radius: 50.00000000000001, startAngle: Angle<Double>(radians: 1.4210854715202002e-16), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.5000000000000003, endPeriod: 0.7500000000000003)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 55.0), radius: 49.99999999999996, startAngle: Angle<Double>(radians: 1.5707963267948954), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.7500000000000003, endPeriod: 1.0))], [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 49.999999999999986, startAngle: Angle<Double>(radians: -3.1415926535897927), sweepAngle: Angle<Double>(radians: -0.4328727381555911)), startPeriod: 0.0, endPeriod: 0.06889383600718606)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -47.0, y: -29.0), radius: 50.00000000000555, startAngle: Angle<Double>(radians: 1.5385551813405673), sweepAngle: Angle<Double>(radians: 0.0322411454542177)), startPeriod: 0.06889383600718606, endPeriod: 0.07402517367717017)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -47.0, y: -29.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.07402517367717017, endPeriod: 0.3240251736771704)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -47.0, y: -29.0), radius: 50.00000000000001, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.3240251736771704, endPeriod: 0.5740251736771707)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: -47.0, y: -29.0), radius: 49.99999999999999, startAngle: Angle<Double>(radians: -1.5707963267948968), sweepAngle: Angle<Double>(radians: 1.1379235886393013)), startPeriod: 0.5740251736771707, endPeriod: 0.7551313376699841)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 50.00000000000001, startAngle: Angle<Double>(radians: -1.6030374722491199), sweepAngle: Angle<Double>(radians: -1.5385551813406737)), startPeriod: 0.7551313376699841, endPeriod: 1.0))]]
                )
        }
    }
}
