import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class Circle2PeriodicTests: XCTestCase {
    typealias Sut = Circle2Periodic<Vector2D>

    func testEphemeral() {
        let sut = Sut(
            center: .init(x: 10, y: 20),
            radius: 150.0,
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertSimplexes([
                    .circleArc2(
                        .init(
                            circleArc: .init(center: .init(x: 10.0, y: 20.0),
                            radius: 150.0,
                            startAngle: .init(radians: 0.0),
                            sweepAngle: .init(radians: 3.141592653589793)),
                            startPeriod: 0.0,
                            endPeriod: 0.5
                        )
                    ),
                    .circleArc2(
                        .init(
                            circleArc: .init(center: .init(x: 10.0, y: 20.0),
                            radius: 150.0,
                            startAngle: .init(radians: 3.141592653589793),
                            sweepAngle: .init(radians: 3.141592653589793)),
                            startPeriod: 0.5,
                            endPeriod: 1.0
                        )
                    ),
                ])
        }
    }

    func testClamped() {
        let sut = Sut(
            center: .zero,
            radius: 100,
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let result = sut.clampedSimplexes(in: 0.3..<0.7)

        TestFixture.beginFixture { fixture in
            fixture.assertEquals(result, [
                .circleArc2(
                    .init(
                        circleArc: .init(center: .init(x: 0.0, y: 0.0),
                            radius: 100.0,
                            startAngle: Angle(radians: 1.8849555921538759),
                            sweepAngle: Angle(radians: 1.2566370614359172)
                        ),
                        startPeriod: 0.3,
                        endPeriod: 0.5
                    )
                ),
                .circleArc2(
                    .init(
                        circleArc: .init(
                            center: .init(x: 0.0, y: 0.0),
                            radius: 100.0,
                            startAngle: Angle(radians: 3.141592653589793),
                            sweepAngle: Angle(radians: 1.256637061435917)
                        ),
                        startPeriod: 0.5,
                        endPeriod: 0.7
                    )
                ),
            ])
        }
    }
}
