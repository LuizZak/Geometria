import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Union2ParametricTests: XCTestCase {
    func testUnion_lhsContainsRhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([lhs.allSimplexes()])
        }
    }

    func testUnion_rhsContainsLhs() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Circle2Parametric.makeTestCircle(radius: 100.0)
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([rhs.allSimplexes()])
        }
    }

    func testUnion_noIntersectionOrContainment() {
        let lhs = Circle2Parametric.makeTestCircle(center: .init(x: -100, y: 0), radius: 50.0)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 100, y: 0), radius: 50.0)
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes([lhs.allSimplexes(), rhs.allSimplexes()])
        }
    }

    func testUnion_lines_lines() {
        let lhs = LinePolygon2Parametric.makeStar()
        let rhs = LinePolygon2Parametric.makeHexagon(radius: 80.0)
        let sut = Union2Parametric(lhs, rhs)

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
                                endPeriod: 0.039225505630241526
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 100.0, y: 0.0),
                                    end: .init(x: 74.9785189589521, y: 8.697460292338837)
                                ),
                                startPeriod: 0.039225505630241526,
                                endPeriod: 0.07845101126048304
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 74.9785189589521, y: 8.697460292338839),
                                    end: .init(x: 40.00000000000001, y: 69.28203230275508)
                                ),
                                startPeriod: 0.07845101126048304,
                                endPeriod: 0.18204103530428004
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 40.00000000000001, y: 69.28203230275508),
                                    end: .init(x: 31.427945012999707, y: 69.28203230275508)
                                ),
                                startPeriod: 0.18204103530428004,
                                endPeriod: 0.19473424543204687
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 31.42794501299971, y: 69.28203230275507),
                                    end: .init(x: 30.901699437494745, y: 95.10565162951536)
                                ),
                                startPeriod: 0.19473424543204687,
                                endPeriod: 0.23298092971827175
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 30.901699437494745, y: 95.10565162951535),
                                    end: .init(x: 11.323626827162714, y: 69.28203230275508)
                                ),
                                startPeriod: 0.23298092971827175,
                                endPeriod: 0.2809669029647308
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 11.323626827162727, y: 69.28203230275508),
                                    end: .init(x: -39.99999999999999, y: 69.2820323027551)
                                ),
                                startPeriod: 0.2809669029647308,
                                endPeriod: 0.356965199852026
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -39.999999999999986, y: 69.2820323027551),
                                    end: .init(x: -51.24444704133373, y: 49.806078724147525)
                                ),
                                startPeriod: 0.356965199852026,
                                endPeriod: 0.3902659962847707
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -51.244447041333736, y: 49.80607872414753),
                                    end: .init(x: -80.90169943749473, y: 58.77852522924732)
                                ),
                                startPeriod: 0.3902659962847707,
                                endPeriod: 0.43614723395134614
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -80.90169943749473, y: 58.77852522924732),
                                    end: .init(x: -61.86160744855665, y: 31.41661746672879)
                                ),
                                startPeriod: 0.43614723395134614,
                                endPeriod: 0.4855080648568105
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -61.86160744855664, y: 31.416617466728784),
                                    end: .init(x: -80.0, y: 1.4210854715202004e-14)
                                ),
                                startPeriod: 0.4855080648568105,
                                endPeriod: 0.5392255056302416
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -80.0, y: 9.797174393178826e-15),
                                    end: .init(x: -61.86160744855667, y: -31.41661746672875)
                                ),
                                startPeriod: 0.5392255056302416,
                                endPeriod: 0.5929429464036726
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -61.86160744855664, y: -31.416617466728745),
                                    end: .init(x: -80.90169943749476, y: -58.7785252292473)
                                ),
                                startPeriod: 0.5929429464036726,
                                endPeriod: 0.642303777309137
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -80.90169943749476, y: -58.7785252292473),
                                    end: .init(x: -51.24444704133376, y: -49.80607872414752)
                                ),
                                startPeriod: 0.642303777309137,
                                endPeriod: 0.6881850149757125
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -51.24444704133375, y: -49.806078724147525),
                                    end: .init(x: -40.000000000000036, y: -69.28203230275507)
                                ),
                                startPeriod: 0.6881850149757125,
                                endPeriod: 0.7214858114084571
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -40.000000000000036, y: -69.28203230275507),
                                    end: .init(x: 11.323626827162663, y: -69.28203230275508)
                                ),
                                startPeriod: 0.7214858114084571,
                                endPeriod: 0.7974841082957523
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 11.323626827162698, y: -69.28203230275508),
                                    end: .init(x: 30.90169943749472, y: -95.10565162951536)
                                ),
                                startPeriod: 0.7974841082957523,
                                endPeriod: 0.8454700815422114
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 30.901699437494724, y: -95.10565162951536),
                                    end: .init(x: 31.427945012999693, y: -69.28203230275513)
                                ),
                                startPeriod: 0.8454700815422114,
                                endPeriod: 0.8837167658284362
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 31.427945012999675, y: -69.28203230275508),
                                    end: .init(x: 40.00000000000001, y: -69.28203230275508)
                                ),
                                startPeriod: 0.8837167658284362,
                                endPeriod: 0.8964099759562031
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 40.00000000000001, y: -69.28203230275508),
                                    end: .init(x: 74.97851895895208, y: -8.697460292338846)
                                ),
                                startPeriod: 0.8964099759562031,
                                endPeriod: 1.0
                            )
                        ),
                    ]
                ])
        }
    }

    func testUnion_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95)

        let sut = Union2Parametric(lhs, rhs)

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
                                endPeriod: 0.01782269681454007)
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 100.0, y: 0.0),
                                    end: .init(x: 94.52562418976665, y: 9.481897043050221)
                                ),
                                startPeriod: 0.01782269681454007, endPeriod: 0.03564539362908016
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 0.09997590556877552),
                                    sweepAngle: Angle<Double>(radians: 0.8472457400590464)
                                ),
                                startPeriod: 0.03564539362908016, endPeriod: 0.16666666666666663
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 55.47437581023338, y: 77.12064333539362),
                                    end: .init(x: 50.000000000000014, y: 86.60254037844386)
                                ),
                                startPeriod: 0.16666666666666663, endPeriod: 0.18448936348120673
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.000000000000014, y: 86.60254037844386),
                                    end: .init(x: 39.051248379533256, y: 86.60254037844386)
                                ),
                                startPeriod: 0.18448936348120673, endPeriod: 0.2023120602957469
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 1.1471734567653735),
                                    sweepAngle: Angle<Double>(radians: 0.847245740059046)
                                ),
                                startPeriod: 0.2023120602957469, endPeriod: 0.3333333333333333
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -39.05124837953324, y: 86.60254037844388),
                                    end: .init(x: -49.999999999999986, y: 86.60254037844388)
                                ),
                                startPeriod: 0.3333333333333333, endPeriod: 0.35115603014787344
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -49.99999999999998, y: 86.60254037844388),
                                    end: .init(x: -55.47437581023333, y: 77.12064333539367)
                                ),
                                startPeriod: 0.35115603014787344, endPeriod: 0.36897872696241346
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 2.194371007961971),
                                    sweepAngle: Angle<Double>(radians: 0.8472457400590464)
                                ),
                                startPeriod: 0.36897872696241346, endPeriod: 0.4999999999999999
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -94.52562418976665, y: 9.481897043050225),
                                    end: .init(x: -100.0, y: 1.4210854715202004e-14)
                                ),
                                startPeriod: 0.4999999999999999, endPeriod: 0.5178226968145401
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -100.0, y: 1.2246467991473532e-14),
                                    end: .init(x: -94.52562418976665, y: -9.481897043050205)
                                ),
                                startPeriod: 0.5178226968145401, endPeriod: 0.5356453936290801
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 3.241568559158569),
                                    sweepAngle: Angle<Double>(radians: 0.8472457400590453)
                                ),
                                startPeriod: 0.5356453936290801, endPeriod: 0.6666666666666664
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -55.4743758102334, y: -77.12064333539362),
                                    end: .init(x: -50.00000000000004, y: -86.60254037844383)
                                ),
                                startPeriod: 0.6666666666666664, endPeriod: 0.6844893634812065
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -50.00000000000004, y: -86.60254037844383),
                                    end: .init(x: -39.051248379533334, y: -86.60254037844383)
                                ),
                                startPeriod: 0.6844893634812065, endPeriod: 0.7023120602957467
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 4.288766110355166),
                                    sweepAngle: Angle<Double>(radians: 0.8472457400590481)
                                ),
                                startPeriod: 0.7023120602957467, endPeriod: 0.8333333333333334
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 39.051248379533305, y: -86.60254037844386),
                                    end: .init(x: 50.000000000000014, y: -86.60254037844386)
                                ),
                                startPeriod: 0.8333333333333334, endPeriod: 0.8511560301478734
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 50.000000000000014, y: -86.60254037844386),
                                    end: .init(x: 55.47437581023337, y: -77.12064333539365)),
                                startPeriod: 0.8511560301478734, endPeriod: 0.8689787269624135
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 0.0, y: 0.0), radius: 95.0,
                                    startAngle: Angle<Double>(radians: 5.335963661551764),
                                    sweepAngle: Angle<Double>(radians: 0.8472457400590467)
                                ),
                                startPeriod: 0.8689787269624135, endPeriod: 1.0
                            )
                        ),
                    ]
                ])
        }
    }
}
