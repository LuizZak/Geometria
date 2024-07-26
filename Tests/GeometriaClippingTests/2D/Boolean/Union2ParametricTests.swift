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
                    ]
                )
        }
    }

    func testUnion_lines_arcs() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95)

        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2.0) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 0.0), end: Vector2<Double>(x: 94.52562418976665, y: 9.481897043050221)), startPeriod: 0.0, endPeriod: 0.017822696814540084)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 0.09997590556877552), sweepAngle: Angle<Double>(radians: 0.8472457400590464)), startPeriod: 0.017822696814540084, endPeriod: 0.14884396985212653)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 55.47437581023338, y: 77.12064333539362), end: Vector2<Double>(x: 50.000000000000014, y: 86.60254037844386)), startPeriod: 0.14884396985212653, endPeriod: 0.16666666666666663)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.000000000000014, y: 86.60254037844386), end: Vector2<Double>(x: 39.051248379533256, y: 86.60254037844386)), startPeriod: 0.16666666666666663, endPeriod: 0.1844893634812068)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 1.1471734567653735), sweepAngle: Angle<Double>(radians: 0.8472457400590461)), startPeriod: 0.1844893634812068, endPeriod: 0.31551063651879313)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -39.05124837953324, y: 86.60254037844388), end: Vector2<Double>(x: -49.99999999999998, y: 86.60254037844388)), startPeriod: 0.31551063651879313, endPeriod: 0.33333333333333326)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -49.99999999999998, y: 86.60254037844388), end: Vector2<Double>(x: -55.47437581023333, y: 77.12064333539367)), startPeriod: 0.33333333333333326, endPeriod: 0.35115603014787333)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 2.194371007961971), sweepAngle: Angle<Double>(radians: 0.8472457400590464)), startPeriod: 0.35115603014787333, endPeriod: 0.4821773031854597)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -94.52562418976665, y: 9.481897043050225), end: Vector2<Double>(x: -100.0, y: 1.2246467991473532e-14)), startPeriod: 0.4821773031854597, endPeriod: 0.49999999999999983)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: 1.2246467991473532e-14), end: Vector2<Double>(x: -94.52562418976665, y: -9.481897043050205)), startPeriod: 0.49999999999999983, endPeriod: 0.51782269681454)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 3.241568559158569), sweepAngle: Angle<Double>(radians: 0.8472457400590453)), startPeriod: 0.51782269681454, endPeriod: 0.6488439698521262)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -55.4743758102334, y: -77.12064333539362), end: Vector2<Double>(x: -50.00000000000004, y: -86.60254037844383)), startPeriod: 0.6488439698521262, endPeriod: 0.6666666666666663)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -50.00000000000004, y: -86.60254037844383), end: Vector2<Double>(x: -39.051248379533334, y: -86.60254037844383)), startPeriod: 0.6666666666666663, endPeriod: 0.6844893634812064)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 4.288766110355166), sweepAngle: Angle<Double>(radians: 0.8472457400590481)), startPeriod: 0.6844893634812064, endPeriod: 0.8155106365187931)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 39.051248379533305, y: -86.60254037844386), end: Vector2<Double>(x: 50.000000000000014, y: -86.60254037844386)), startPeriod: 0.8155106365187931, endPeriod: 0.8333333333333331)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 50.000000000000014, y: -86.60254037844386), end: Vector2<Double>(x: 55.47437581023337, y: -77.12064333539365)), startPeriod: 0.8333333333333331, endPeriod: 0.8511560301478732)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 95.0, startAngle: Angle<Double>(radians: 5.335963661551764), sweepAngle: Angle<Double>(radians: 0.8472457400590474)), startPeriod: 0.8511560301478732, endPeriod: 0.9821773031854599)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 94.52562418976665, y: -9.48189704305021), end: Vector2<Double>(x: 100.0, y: 0.0)), startPeriod: 0.9821773031854599, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_arcsArcs() {
        let lhs = Circle2Parametric.makeTestCircle(center: .init(x: -25.0, y: 5.0), radius: 115)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 25.0, y: -5.0), radius: 85)

        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [
                        [
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: -25.0, y: 5.0),
                                        radius: 115.0,
                                        startAngle: Angle(radians: 1.5707963267948966),
                                        sweepAngle: Angle(radians: 1.5707963267948966)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.24166701155392442
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: -25.0, y: 5.0),
                                        radius: 115.0,
                                        startAngle: Angle(radians: 3.141592653589793),
                                        sweepAngle: Angle(radians: 1.5707963267948966)
                                    ),
                                    startPeriod: 0.24166701155392442,
                                    endPeriod: 0.48333402310784884
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: -25.0, y: 5.0),
                                        radius: 114.99999999999997,
                                        startAngle: Angle(radians: -1.570796326794897),
                                        sweepAngle: Angle(radians: 0.8317784477809788)
                                    ),
                                    startPeriod: 0.48333402310784884,
                                    endPeriod: 0.6113031355390863
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: 25.0, y: -5.0),
                                        radius: 85.00000000000009,
                                        startAngle: Angle(radians: -1.14640661820171),
                                        sweepAngle: Angle(radians: 1.1464066182017099)
                                    ),
                                    startPeriod: 0.6113031355390863,
                                    endPeriod: 0.7416670115539244
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: 25.0, y: -5.0),
                                        radius: 85.00000000000001,
                                        startAngle: Angle(radians: -8.359326303060001e-17),
                                        sweepAngle: Angle(radians: 1.14640661820171)
                                    ),
                                    startPeriod: 0.7416670115539244,
                                    endPeriod: 0.8720308875687625
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: -25.0, y: -5.0),
                                        radius: 115.00000000000003,
                                        startAngle: Angle(radians: 0.7390178790139179),
                                        sweepAngle: Angle(radians: 0.8317784477809788)
                                    ),
                                    startPeriod: 0.8720308875687625,
                                    endPeriod: 1.0
                                )
                            ),
                        ]
                    ]
                )
        }
    }

    func testUnion_concaveShape() {
        let lhs = LinePolygon2Parametric.makeCShape()
        let rhs = LinePolygon2Parametric.makeRectangle(width: 10, height: 120)
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -4.999999999999972, y: 50.0),
                                        end: .init(x: -50.0, y: 50.0)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.08883299341559678
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -50.0, y: 50.0),
                                        end: .init(x: -50.0, y: -50.0)
                                    ),
                                    startPeriod: 0.08883299341559678,
                                    endPeriod: 0.28623964545025615
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -50.0, y: -50.0),
                                        end: .init(x: -4.999999999999999, y: -50.0)
                                    ),
                                    startPeriod: 0.28623964545025615,
                                    endPeriod: 0.3750726388658529
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: -49.999999999999986),
                                        end: .init(x: -5.0, y: -60.0)
                                    ),
                                    startPeriod: 0.3750726388658529,
                                    endPeriod: 0.39481330406931886
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: -60.0),
                                        end: .init(x: 5.0, y: -60.0)
                                    ),
                                    startPeriod: 0.39481330406931886,
                                    endPeriod: 0.4145539692727848
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: -60.0),
                                        end: .init(x: 5.0, y: -50.0)
                                    ),
                                    startPeriod: 0.4145539692727848,
                                    endPeriod: 0.4342946344762508
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.000000000000004, y: -50.0),
                                        end: .init(x: 50.0, y: -50.0)
                                    ),
                                    startPeriod: 0.4342946344762508,
                                    endPeriod: 0.5231276278918475
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 50.0, y: -50.0),
                                        end: .init(x: 30.0, y: -30.0)
                                    ),
                                    startPeriod: 0.5231276278918475,
                                    endPeriod: 0.5789626608138638
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 30.0, y: -30.0),
                                        end: .init(x: 4.999999999999982, y: -30.0)
                                    ),
                                    startPeriod: 0.5789626608138638,
                                    endPeriod: 0.6283143238225286
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: -30.0),
                                        end: .init(x: 5.0, y: 29.999999999999986)
                                    ),
                                    startPeriod: 0.6283143238225286,
                                    endPeriod: 0.7467583150433242
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 4.999999999999996, y: 30.0),
                                        end: .init(x: 30.0, y: 30.0)
                                    ),
                                    startPeriod: 0.7467583150433242,
                                    endPeriod: 0.7961099780519891
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 30.0, y: 30.0),
                                        end: .init(x: 50.0, y: 50.0)
                                    ),
                                    startPeriod: 0.7961099780519891,
                                    endPeriod: 0.8519450109740054
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 50.0, y: 50.0),
                                        end: .init(x: 4.999999999999977, y: 50.0)
                                    ),
                                    startPeriod: 0.8519450109740054,
                                    endPeriod: 0.9407780043896021
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: 50.00000000000001),
                                        end: .init(x: 5.0, y: 60.0)
                                    ),
                                    startPeriod: 0.9407780043896021,
                                    endPeriod: 0.9605186695930681
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 5.0, y: 60.0),
                                        end: .init(x: -5.0, y: 60.0)
                                    ),
                                    startPeriod: 0.9605186695930681,
                                    endPeriod: 0.980259334796534
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: 60.0),
                                        end: .init(x: -5.0, y: 50.00000000000001)
                                    ),
                                    startPeriod: 0.980259334796534,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                        [
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -4.999999999999996, y: -30.0),
                                        end: .init(x: -30.0, y: -30.0)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.14705882352941183
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -30.0, y: -30.0),
                                        end: .init(x: -30.0, y: 30.0)
                                    ),
                                    startPeriod: 0.14705882352941183,
                                    endPeriod: 0.5000000000000002
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -30.0, y: 30.0),
                                        end: .init(x: -5.000000000000022, y: 30.0)
                                    ),
                                    startPeriod: 0.5000000000000002,
                                    endPeriod: 0.6470588235294118
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -5.0, y: 29.999999999999993),
                                        end: .init(x: -5.0, y: -29.999999999999986)
                                    ),
                                    startPeriod: 0.6470588235294118,
                                    endPeriod: 1.0
                                )
                            ),
                        ],
                    ]
                )
        }
    }

    func testUnion_intersectionOnStartPeriod() {
        let lhs = Circle2Parametric.makeTestCircle()
        let rhs = LinePolygon2Parametric.makeRectangle(
            width: 220,
            height: 220,
            center: .init(x: 0.0, y: -110.0)
        )
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture(renderScale: 2) { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [
                        [
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: 0.0, y: 0.0),
                                        radius: 100.0,
                                        startAngle: Angle(radians: 7.105427357601002e-17),
                                        sweepAngle: Angle(radians: 1.5707963267948966)
                                    ),
                                    startPeriod: 0.0,
                                    endPeriod: 0.158002483256815
                                )
                            ),
                            .circleArc2(
                                .init(
                                    circleArc: .init(
                                        center: .init(x: 0.0, y: 0.0),
                                        radius: 100.0,
                                        startAngle: Angle(radians: 1.5707963267948966),
                                        sweepAngle: Angle(radians: 1.5707963267948966)
                                    ),
                                    startPeriod: 0.158002483256815,
                                    endPeriod: 0.31600496651363
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -100.0, y: 1.2246467991473532e-14),
                                        end: .init(x: -110.0, y: 0.0)
                                    ),
                                    startPeriod: 0.31600496651363,
                                    endPeriod: 0.32606371700607667
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -110.0, y: 0.0),
                                        end: .init(x: -110.0, y: -220.0)
                                    ),
                                    startPeriod: 0.32606371700607667,
                                    endPeriod: 0.5473562278399022
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: -110.0, y: -220.0),
                                        end: .init(x: 110.0, y: -220.0)
                                    ),
                                    startPeriod: 0.5473562278399022,
                                    endPeriod: 0.7686487386737278
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 110.0, y: -220.0),
                                        end: .init(x: 110.0, y: 0.0)
                                    ),
                                    startPeriod: 0.7686487386737278,
                                    endPeriod: 0.9899412495075534
                                )
                            ),
                            .lineSegment2(
                                .init(
                                    lineSegment: .init(
                                        start: .init(x: 110.0, y: 0.0),
                                        end: .init(x: 100.0, y: 0.0)
                                    ),
                                    startPeriod: 0.9899412495075534,
                                    endPeriod: 1.0
                                )
                            ),
                        ]
                    ]
                )
        }
    }

    func testUnion_rhsOccludesLhsHole() {
        let radius: Double = 50.0
        let circles = [
            Circle2Parametric.makeTestCircle(center: .init(x: 110, y: 95), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: 63, y: 11), radius: radius),
            Circle2Parametric.makeTestCircle(center: .init(x: 158, y: 13), radius: radius),
        ]
        let lhs = union(circles)
        let rhs = Circle2Parametric.makeTestCircle(center: .init(x: 110, y: 40), radius: radius)
        let sut: Union2Parametric = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.11823023429846431)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.11823023429846431, endPeriod: 0.23646046859692862)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 0.5823642378687436)), startPeriod: 0.23646046859692862, endPeriod: 0.28029368816573047)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 2.5592284157210496), sweepAngle: Angle<Double>(radians: 0.1494914997131486)), startPeriod: 0.28029368816573047, endPeriod: 0.2915455702431337)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5385551813406735), sweepAngle: Angle<Double>(radians: 0.03224114545422309)), startPeriod: 0.2915455702431337, endPeriod: 0.2939722872630809)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.2939722872630809, endPeriod: 0.41220252156154524)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.41220252156154524, endPeriod: 0.5304327558600096)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 63.0, y: 11.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 1.1379235886393009)), startPeriod: 0.5304327558600096, endPeriod: 0.6160816526670752)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.680147834930466), sweepAngle: Angle<Double>(radians: 0.1030864112323703)), startPeriod: 0.6160816526670752, endPeriod: 0.6238407302413522)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 3.616764793985068), sweepAngle: Angle<Double>(radians: 1.095624186399622)), startPeriod: 0.6238407302413522, endPeriod: 0.7063058481254771)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.7063058481254771, endPeriod: 0.8245360824239414)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.8245360824239414, endPeriod: 0.9427663167224056)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 158.0, y: 13.0), radius: 50.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 0.07084526577814707)), startPeriod: 0.9427663167224056, endPeriod: 0.9480986772767356)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 40.0), radius: 50.0, startAngle: Angle<Double>(radians: 0.4751721403952749), sweepAngle: Angle<Double>(radians: 0.10719209747346853)), startPeriod: 0.9480986772767356, endPeriod: 0.9561667804311981)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 110.0, y: 95.0), radius: 50.0, startAngle: Angle<Double>(radians: 5.700821069310844), sweepAngle: Angle<Double>(radians: 0.5823642378687433)), startPeriod: 0.9561667804311981, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_lhsOccludesRhsHole() {
        let lhs = Circle2Parametric.makeTestCircle(radius: 90.0)
        let rhs1 = Circle2Parametric.makeTestCircle(radius: 100.0)
        let rhs2 = Circle2Parametric.makeTestCircle(radius: 80.0)
        let rhs = Compound2Parametric(contours: Subtraction2Parametric(rhs1, rhs2).allContours())
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.25, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.5, endPeriod: 0.75)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 0.0), radius: 100.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.75, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_interference_containment_edge_sameDirection() {
        // •>-----•
        // |      •---•
        // |  1   v 2 |
        // |      •---•
        // •------•
        let lhs = LinePolygon2Parametric.makeRectangle(width: 200, height: 200, center: .zero)
        let rhs = LinePolygon2Parametric
            .makeRectangle(width: 100, height: 100, center: .init(x: 150, y: 0))
            .reversed()
        let sut = Union2Parametric(lhs, rhs, tolerance: 1e-14)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: -100.0)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: -50.0)), startPeriod: 0.25, endPeriod: 0.3125)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -50.0), end: Vector2<Double>(x: 100.0, y: 49.99999999999999)), startPeriod: 0.3125, endPeriod: 0.4375)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 49.99999999999999), end: Vector2<Double>(x: 100.0, y: 100.0)), startPeriod: 0.4375, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 100.0), end: Vector2<Double>(x: -100.0, y: 100.0)), startPeriod: 0.5, endPeriod: 0.75)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: 100.0), end: Vector2<Double>(x: -100.0, y: -100.0)), startPeriod: 0.75, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_interference_containment_edge_opposing() {
        // •>-----•
        // |      •>--•
        // |  1   | 2 |
        // |      •---•
        // •------•
        let lhs = LinePolygon2Parametric.makeRectangle(width: 200, height: 200, center: .zero)
        let rhs = LinePolygon2Parametric.makeRectangle(width: 100, height: 100, center: .init(x: 150, y: 0))
        let sut = Union2Parametric(lhs, rhs, tolerance: 1e-14)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: -100.0)), startPeriod: 0.0, endPeriod: 0.2)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: -50.0)), startPeriod: 0.2, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -50.0), end: Vector2<Double>(x: 200.0, y: -50.0)), startPeriod: 0.25, endPeriod: 0.35)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: -50.0), end: Vector2<Double>(x: 200.0, y: 50.0)), startPeriod: 0.35, endPeriod: 0.45)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: 50.0), end: Vector2<Double>(x: 100.0, y: 50.0)), startPeriod: 0.45, endPeriod: 0.55)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 50.0), end: Vector2<Double>(x: 100.0, y: 100.0)), startPeriod: 0.55, endPeriod: 0.6)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 100.0), end: Vector2<Double>(x: -100.0, y: 100.0)), startPeriod: 0.6, endPeriod: 0.8)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: 100.0), end: Vector2<Double>(x: -100.0, y: -100.0)), startPeriod: 0.8, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_interference_containment_edge_opposing_multiple() {
        // •>-----•
        // |      •>--•
        // |  1   | 2 |
        // |      •---•
        // |      |
        // |      •>--•
        // |      | 2 |
        // |      •---•
        // •------•
        let lhs = LinePolygon2Parametric.makeRectangle(width: 200, height: 500, center: .zero)
        let rhs1 = LinePolygon2Parametric.makeRectangle(width: 100, height: 100, center: .init(x: 150, y: -150))
        let rhs2 = LinePolygon2Parametric.makeRectangle(width: 100, height: 100, center: .init(x: 150, y: 150))
        let rhs = Union2Parametric.union(rhs1, rhs2)
        let sut = Union2Parametric(lhs, rhs, tolerance: 1e-14)

        TestFixture.beginFixture { fixture in
            fixture.add(lhs, category: "input")
            fixture.add(rhs1, category: "input")
            fixture.add(rhs2, category: "input")
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [[GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: -250.0), end: Vector2<Double>(x: 100.0, y: -250.0)), startPeriod: 0.0, endPeriod: 0.1111111111111111)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -250.0), end: Vector2<Double>(x: 100.0, y: -200.0)), startPeriod: 0.1111111111111111, endPeriod: 0.1388888888888889)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -200.0), end: Vector2<Double>(x: 200.0, y: -200.0)), startPeriod: 0.1388888888888889, endPeriod: 0.19444444444444445)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: -200.0), end: Vector2<Double>(x: 200.0, y: -100.0)), startPeriod: 0.19444444444444445, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: -100.0)), startPeriod: 0.25, endPeriod: 0.3055555555555556)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: -100.0), end: Vector2<Double>(x: 100.0, y: 100.00000000000001)), startPeriod: 0.3055555555555556, endPeriod: 0.4166666666666667)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 100.00000000000001), end: Vector2<Double>(x: 200.0, y: 100.0)), startPeriod: 0.4166666666666667, endPeriod: 0.4722222222222222)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: 100.0), end: Vector2<Double>(x: 200.0, y: 200.0)), startPeriod: 0.4722222222222222, endPeriod: 0.5277777777777778)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 200.0, y: 200.0), end: Vector2<Double>(x: 100.0, y: 200.0)), startPeriod: 0.5277777777777778, endPeriod: 0.5833333333333334)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 200.0), end: Vector2<Double>(x: 100.0, y: 250.0)), startPeriod: 0.5833333333333334, endPeriod: 0.6111111111111112)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: 100.0, y: 250.0), end: Vector2<Double>(x: -100.0, y: 250.0)), startPeriod: 0.6111111111111112, endPeriod: 0.7222222222222222)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.lineSegment2(GeometriaClipping.LineSegment2Simplex<Geometria.Vector2<Swift.Double>>(lineSegment: LineSegment<Vector2<Double>>(start: Vector2<Double>(x: -100.0, y: 250.0), end: Vector2<Double>(x: -100.0, y: -250.0)), startPeriod: 0.7222222222222222, endPeriod: 1.0))]]
                )
        }
    }

    func testUnion_interference_total() {
        let lhs = Circle2Parametric.makeTestCircle()
        let rhs = Circle2Parametric.makeTestCircle()
        let sut = Union2Parametric(lhs, rhs)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertAllSimplexes(
                    accuracy: 1e-14,
                    [lhs.allSimplexes()]
                )
        }
    }
}
