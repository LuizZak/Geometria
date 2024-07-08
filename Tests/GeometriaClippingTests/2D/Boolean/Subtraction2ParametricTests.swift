import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Subtraction2ParametricTests: XCTestCase {
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
                                    start: .init(x: 74.97851895895208, y: -8.69746029233885),
                                    end: .init(x: 40.00000000000001, y: -69.28203230275508)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.4129005003979027
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 40.00000000000001, y: -69.28203230275508),
                                    end: .init(x: 31.427945012999697, y: -69.28203230275508)
                                ),
                                startPeriod: 0.4129005003979027,
                                endPeriod: 0.4634944920663939
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 31.427945012999693, y: -69.28203230275513),
                                    end: .init(x: 32.36067977499789, y: -23.511410091698934)
                                ),
                                startPeriod: 0.4634944920663939,
                                endPeriod: 0.7336979928665686
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 32.36067977499789, y: -23.511410091698934),
                                    end: .init(x: 74.97851895895208, y: -8.697460292338846)
                                ),
                                startPeriod: 0.7336979928665686,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 11.323626827162686, y: -69.28203230275508),
                                    end: .init(x: -40.000000000000036, y: -69.28203230275507)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.3340517174616258
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -40.000000000000036, y: -69.28203230275507),
                                    end: .init(x: -51.24444704133375, y: -49.80607872414752)
                                ),
                                startPeriod: 0.3340517174616258,
                                endPeriod: 0.48042589552637116
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -51.24444704133376, y: -49.80607872414752),
                                    end: .init(x: -12.360679774997905, y: -38.04226065180614)
                                ),
                                startPeriod: 0.48042589552637116,
                                endPeriod: 0.7448386470489565
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -12.360679774997903, y: -38.04226065180614),
                                    end: .init(x: 11.323626827162698, y: -69.28203230275508)
                                ),
                                startPeriod: 0.7448386470489565,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -61.861607448556654, y: -31.416617466728773),
                                    end: .init(x: -80.0, y: 1.4210854715202004e-14)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.24330102455602645
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -80.0, y: 9.797174393178826e-15),
                                    end: .init(x: -61.86160744855665, y: 31.41661746672877)
                                ),
                                startPeriod: 0.24330102455602645,
                                endPeriod: 0.48660204911205274
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -61.86160744855665, y: 31.41661746672879),
                                    end: .init(x: -40.0, y: 7.105427357601002e-15)
                                ),
                                startPeriod: 0.48660204911205274,
                                endPeriod: 0.7433010245560264
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -40.0, y: 4.898587196589413e-15),
                                    end: .init(x: -61.86160744855664, y: -31.416617466728745)
                                ),
                                startPeriod: 0.7433010245560264,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -51.24444704133373, y: 49.80607872414752),
                                    end: .init(x: -39.999999999999986, y: 69.2820323027551)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.14637417806474554
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -39.999999999999986, y: 69.2820323027551),
                                    end: .init(x: 11.323626827162721, y: 69.28203230275508)
                                ),
                                startPeriod: 0.14637417806474554,
                                endPeriod: 0.48042589552637127
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 11.323626827162714, y: 69.28203230275508),
                                    end: .init(x: -12.360679774997894, y: 38.042260651806146)
                                ),
                                startPeriod: 0.48042589552637127,
                                endPeriod: 0.7355872484774147
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -12.360679774997894, y: 38.042260651806146),
                                    end: .init(x: -51.244447041333736, y: 49.80607872414753)
                                ),
                                startPeriod: 0.7355872484774147,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 31.42794501299974, y: 69.28203230275508),
                                    end: .init(x: 40.000000000000014, y: 69.28203230275508)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.05059399166849101
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 40.00000000000001, y: 69.28203230275508),
                                    end: .init(x: 74.9785189589521, y: 8.697460292338839)
                                ),
                                startPeriod: 0.05059399166849101,
                                endPeriod: 0.463494492066394
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 74.97851895895208, y: 8.697460292338842),
                                    end: .init(x: 32.36067977499789, y: 23.511410091698927)
                                ),
                                startPeriod: 0.463494492066394,
                                endPeriod: 0.7297964991998255
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 32.3606797749979, y: 23.511410091698927),
                                    end: .init(x: 31.42794501299971, y: 69.28203230275507)
                                ),
                                startPeriod: 0.7297964991998255,
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
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 6.183209401610811),
                                    sweepAngle: Angle(radians: -0.8472457400590467)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.5075220249652559
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 55.47437581023337, y: -77.12064333539365),
                                    end: .init(x: 94.52562418976665, y: -9.48189704305021)
                                ),
                                startPeriod: 0.5075220249652559,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 5.136011850414214),
                                    sweepAngle: Angle(radians: -0.8472457400590481)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.507522024965256
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -39.051248379533334, y: -86.60254037844383),
                                    end: .init(x: 39.051248379533305, y: -86.60254037844386)
                                ),
                                startPeriod: 0.507522024965256,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 4.0888142992176135),
                                    sweepAngle: Angle(radians: -0.8472457400590453)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.5075220249652556
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -94.52562418976665, y: -9.481897043050205),
                                    end: .init(x: -55.4743758102334, y: -77.12064333539362)
                                ),
                                startPeriod: 0.5075220249652556,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 3.0416167480210174),
                                    sweepAngle: Angle(radians: -0.847245740059046)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.5075220249652556
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -55.47437581023333, y: 77.12064333539367),
                                    end: .init(x: -94.52562418976665, y: 9.481897043050225)
                                ),
                                startPeriod: 0.5075220249652556,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 1.9944191968244198),
                                    sweepAngle: Angle(radians: -0.8472457400590467)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.507522024965256
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 39.051248379533256, y: 86.60254037844386),
                                    end: .init(x: -39.05124837953324, y: 86.60254037844388)
                                ),
                                startPeriod: 0.507522024965256,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0),
                                    radius: 95.0,
                                    startAngle: Angle(radians: 0.9472216456278217),
                                    sweepAngle: Angle(radians: -0.8472457400590467)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.507522024965256
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 94.52562418976665, y: 9.481897043050221),
                                    end: .init(x: 55.47437581023338, y: 77.12064333539362)
                                ),
                                startPeriod: 0.507522024965256,
                                endPeriod: 1.0
                            )
                        ),
                    ],
                ])
        }
    }
}
