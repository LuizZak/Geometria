import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class CircleArc2SimplexTests: XCTestCase {
    typealias Sut = CircleArc2Simplex<Vector2D>

    func testLengthSquared() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        XCTAssertEqual(sut.lengthSquared, 986.9604401089358)
    }

    func testClampedIn_positiveSweep() throws {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let result = try XCTUnwrap(sut.clamped(in: 0..<0.5))

        assertEqual(result.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testClampedIn_negativeSweep() throws {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.pi,
                sweepAngle: -Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let result = try XCTUnwrap(sut.clamped(in: 0.3..<0.5))

        assertEqual(result.circleArc.startAngle, Angle(radians: 2.199114857512855), accuracy: 1e-14)
        assertEqual(result.circleArc.sweepAngle, Angle(radians: -0.6283185307179586), accuracy: 1e-14)
        assertEqual(result.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testComputeAt_positiveSweep() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        assertEqual(sut.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testComputeAt_negativeSweep() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.pi,
                sweepAngle: -Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        assertEqual(sut.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testSplittingArcSegments_fullCircle_zeroStartAngle_halfPiMaxSweep_positiveSweep() {
        let arc = CircleArc2D(
            center: .init(x: 50, y: 70),
            radius: 200,
            startAngle: 0,
            sweepAngle: Angle.pi * 2.0
        )
        let sut = Sut.splittingArcSegments(
            arc,
            startPeriod: 0.0,
            endPeriod: 1.0,
            maxAbsoluteSweepAngle: .pi / 2.0
        )

        TestFixture.beginFixture { fixture in
            let asSimplexes = sut.map(Parametric2GeometrySimplex.circleArc2)
            fixture.add(asSimplexes, category: "result")

            fixture.assertEquals(
                sut.reduce(0.0, { $0 + $1.sweepAngle.radians }),
                arc.sweepAngle.radians,
                accuracy: 1e-13
            )

            fixture.assertEquals(
                asSimplexes,
                accuracy: 1e-13,
                [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 1.5707963267948966), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.25, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 3.141592653589793), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.5, endPeriod: 0.75)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 4.71238898038469), sweepAngle: Angle<Double>(radians: 1.5707963267948966)), startPeriod: 0.75, endPeriod: 1.0))]
            )
        }
    }

    func testSplittingArcSegments_fullCircle_zeroStartAngle_halfPiMaxSweep_negativeSweep() {
        let arc = CircleArc2D(
            center: .init(x: 50, y: 70),
            radius: 200,
            startAngle: 0,
            sweepAngle: -Angle.pi * 2.0
        )
        let sut = Sut.splittingArcSegments(
            arc,
            startPeriod: 0.0,
            endPeriod: 1.0,
            maxAbsoluteSweepAngle: .pi / 2.0
        )

        TestFixture.beginFixture { fixture in
            let asSimplexes = sut.map(Parametric2GeometrySimplex.circleArc2)
            fixture.add(asSimplexes, category: "result")

            fixture.assertEquals(
                sut.reduce(0.0, { $0 + $1.sweepAngle.radians }),
                arc.sweepAngle.radians,
                accuracy: 1e-13
            )

            fixture.assertEquals(
                asSimplexes,
                accuracy: 1e-13,
                [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 0.0), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.0, endPeriod: 0.25)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: -1.5707963267948966), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.25, endPeriod: 0.5)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: -3.141592653589793), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.5, endPeriod: 0.75)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: -4.71238898038469), sweepAngle: Angle<Double>(radians: -1.5707963267948966)), startPeriod: 0.75, endPeriod: 1.0))]
            )
        }
    }

    func testSplittingArcSegments_twoThirdsCircle_fifthStartAngle_ninthPiMaxSweep_positiveSweep() {
        let arc = CircleArc2D(
            center: .init(x: 50, y: 70),
            radius: 200,
            startAngle: .pi / 5.0,
            sweepAngle: Angle.pi * (3.0 / 2.0)
        )
        let sut = Sut.splittingArcSegments(
            arc,
            startPeriod: 0.0,
            endPeriod: 1.0,
            maxAbsoluteSweepAngle: .pi / 9.0
        )

        TestFixture.beginFixture { fixture in
            let asSimplexes = sut.map(Parametric2GeometrySimplex.circleArc2)
            fixture.add(asSimplexes, category: "result")

            fixture.assertEquals(
                sut.reduce(0.0, { $0 + $1.sweepAngle.radians }),
                arc.sweepAngle.radians,
                accuracy: 1e-13
            )

            fixture.assertEquals(
                asSimplexes,
                accuracy: 1e-13,
                [GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 0.6283185307179586), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.0, endPeriod: 0.07407407407407407)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 0.9773843811168246), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.07407407407407407, endPeriod: 0.14814814814814814)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 1.3264502315156905), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.14814814814814814, endPeriod: 0.2222222222222222)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 1.6755160819145563), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.2222222222222222, endPeriod: 0.2962962962962963)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 2.0245819323134224), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.2962962962962963, endPeriod: 0.37037037037037035)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 2.373647782712288), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.37037037037037035, endPeriod: 0.4444444444444444)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 2.722713633111154), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.4444444444444444, endPeriod: 0.5185185185185185)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 3.07177948351002), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.5185185185185185, endPeriod: 0.5925925925925926)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 3.420845333908886), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.5925925925925926, endPeriod: 0.6666666666666666)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 3.7699111843077517), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.6666666666666666, endPeriod: 0.7407407407407407)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 4.118977034706617), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.7407407407407407, endPeriod: 0.8148148148148149)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 4.468042885105484), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.8148148148148149, endPeriod: 0.8888888888888888)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 4.817108735504349), sweepAngle: Angle<Double>(radians: 0.3490658503988659)), startPeriod: 0.8888888888888888, endPeriod: 0.9629629629629628)), GeometriaClipping.Parametric2GeometrySimplex<Geometria.Vector2<Swift.Double>>.circleArc2(GeometriaClipping.CircleArc2Simplex<Geometria.Vector2<Swift.Double>>(circleArc: CircleArc2<Vector2<Double>>(center: Vector2<Double>(x: 50.0, y: 70.0), radius: 200.0, startAngle: Angle<Double>(radians: 5.166174585903215), sweepAngle: Angle<Double>(radians: 0.17453292519943325)), startPeriod: 0.9629629629629628, endPeriod: 1.0))]
            )
        }
    }
}
