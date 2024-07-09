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
                .assertAllSimplexes([lhs.allSimplexes()])
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
                .assertAllSimplexes([
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
                ])
        }
    }

    func testSubtraction_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95)

        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2.0) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 94.52562418976665, y: -9.48189704305021),
                                    end: .init(x: 100.0, y: 0.0)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.267741951460104
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 100.0, y: 0.0),
                                    end: .init(x: 94.52562418976665, y: 9.481897043050221)
                                ),
                                startPeriod: 0.267741951460104,
                                endPeriod: 0.5354839029202083
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 0.09997590556877523),
                                    sweepAngle: Angle(radians: -0.09997590556877503)
                                ),
                                startPeriod: 0.5354839029202083,
                                endPeriod: 0.7677419514601037
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 6.283185307179586),
                                    sweepAngle: Angle(radians: -0.09997590556877538)
                                ),
                                startPeriod: 0.7677419514601037,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 55.47437581023338, y: 77.12064333539362),
                                    end: .init(x: 50.000000000000014, y: 86.60254037844386)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.26774195146010366
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.000000000000014, y: 86.60254037844386),
                                    end: .init(x: 39.051248379533256, y: 86.60254037844386)
                                ),
                                startPeriod: 0.26774195146010366,
                                endPeriod: 0.5354839029202078
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 1.1471734567653733),
                                    sweepAngle: Angle(radians: -0.19995181113755145)
                                ),
                                startPeriod: 0.5354839029202078,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -39.05124837953324, y: 86.60254037844388),
                                    end: .init(x: -49.999999999999986, y: 86.60254037844388)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.2677419514601041
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -49.99999999999998, y: 86.60254037844388),
                                    end: .init(x: -55.47437581023333, y: 77.12064333539367)
                                ),
                                startPeriod: 0.2677419514601041,
                                endPeriod: 0.5354839029202073
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 2.1943710079619714),
                                    sweepAngle: Angle(radians: -0.19995181113755145)
                                ),
                                startPeriod: 0.5354839029202073,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -94.52562418976665, y: 9.481897043050225),
                                    end: .init(x: -100.0, y: 1.4210854715202004e-14)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.2677419514601034
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -100.0, y: 1.2246467991473532e-14),
                                    end: .init(x: -94.52562418976665, y: -9.481897043050205)
                                ),
                                startPeriod: 0.2677419514601034,
                                endPeriod: 0.535483902920207
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 3.241568559158569),
                                    sweepAngle: Angle(radians: -0.09997590556877572)
                                ),
                                startPeriod: 0.535483902920207,
                                endPeriod: 0.7677419514601035
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 3.141592653589793),
                                    sweepAngle: Angle(radians: -0.09997590556877572)
                                ),
                                startPeriod: 0.7677419514601035,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -55.4743758102334, y: -77.12064333539362),
                                    end: .init(x: -50.00000000000004, y: -86.60254037844383)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.26774195146010343
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -50.00000000000004, y: -86.60254037844383),
                                    end: .init(x: -39.051248379533334, y: -86.60254037844383)
                                ),
                                startPeriod: 0.26774195146010343,
                                endPeriod: 0.5354839029202068
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 4.288766110355166),
                                    sweepAngle: Angle(radians: -0.19995181113755145)
                                ),
                                startPeriod: 0.5354839029202068,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 39.051248379533305, y: -86.60254037844386),
                                    end: .init(x: 50.000000000000014, y: -86.60254037844386)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.26774195146010404
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.000000000000014, y: -86.60254037844386),
                                    end: .init(x: 55.47437581023337, y: -77.12064333539365)
                                ),
                                startPeriod: 0.26774195146010404,
                                endPeriod: 0.5354839029202081
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 5.335963661551764),
                                    sweepAngle: Angle(radians: -0.19995181113755042)
                                ),
                                startPeriod: 0.5354839029202081,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                ])
        }
    }

    func testSubtraction_concaveShape() {
        let lhs = LinePolygon2Parametric.makeCShape()
        let rhs = LinePolygon2Parametric.makeRectangle(width: 10, height: 120)
        let sut = Subtraction2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -4.999999999999972, y: 50.0),
                                    end: .init(x: -50.0, y: 50.0)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.13235294117647065
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -50.0, y: 50.0),
                                    end: .init(x: -50.0, y: -50.0)
                                ),
                                startPeriod: 0.13235294117647065,
                                endPeriod: 0.42647058823529416
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -50.0, y: -50.0),
                                    end: .init(x: -4.999999999999999, y: -50.0)
                                ),
                                startPeriod: 0.42647058823529416,
                                endPeriod: 0.5588235294117647
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -5.0, y: -50.00000000000001),
                                    end: .init(x: -5.0, y: -29.999999999999993)
                                ),
                                startPeriod: 0.5588235294117647,
                                endPeriod: 0.6176470588235294
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -4.999999999999996, y: -30.0),
                                    end: .init(x: -30.0, y: -30.0)
                                ),
                                startPeriod: 0.6176470588235294,
                                endPeriod: 0.6911764705882354
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -30.0, y: -30.0),
                                    end: .init(x: -30.0, y: 30.0)
                                ),
                                startPeriod: 0.6911764705882354,
                                endPeriod: 0.8676470588235294
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -30.0, y: 30.0),
                                    end: .init(x: -5.000000000000022, y: 30.0)
                                ),
                                startPeriod: 0.8676470588235294,
                                endPeriod: 0.9411764705882353
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -5.0, y: 29.999999999999986),
                                    end: .init(x: -5.0, y: 49.999999999999986)
                                ),
                                startPeriod: 0.9411764705882353,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 5.000000000000004, y: -50.0),
                                    end: .init(x: 50.0, y: -50.0)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.3804394238170155
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.0, y: -50.0),
                                    end: .init(x: 30.0, y: -30.0)
                                ),
                                startPeriod: 0.3804394238170155,
                                endPeriod: 0.6195605761829842
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 30.0, y: -30.0),
                                    end: .init(x: 4.999999999999982, y: -30.0)
                                ),
                                startPeriod: 0.6195605761829842,
                                endPeriod: 0.8309158116368819
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 5.0, y: -29.999999999999986),
                                    end: .init(x: 5.0, y: -50.00000000000001)
                                ),
                                startPeriod: 0.8309158116368819,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 4.999999999999996, y: 30.0),
                                    end: .init(x: 30.0, y: 30.0)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.2113552354538976
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 30.0, y: 30.0),
                                    end: .init(x: 50.0, y: 50.0)
                                ),
                                startPeriod: 0.2113552354538976,
                                endPeriod: 0.45047638781986615
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.0, y: 50.0),
                                    end: .init(x: 4.999999999999977, y: 50.0)
                                ),
                                startPeriod: 0.45047638781986615,
                                endPeriod: 0.830915811636882
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 5.0, y: 50.0),
                                    end: .init(x: 5.0, y: 30.0)
                                ),
                                startPeriod: 0.830915811636882,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                ])
        }
    }
}
