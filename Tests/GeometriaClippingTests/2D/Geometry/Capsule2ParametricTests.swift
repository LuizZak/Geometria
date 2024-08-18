import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Capsule2ParametricTests: XCTestCase {
    typealias Sut = Capsule2Parametric<Vector2D>
    let accuracy: Double = 1e-12

    func testEphemeral() {
        let sut = Sut(
            start: .init(x: -150, y: -30),
            startRadius: 60,
            end: .init(x: 70, y: 80),
            endRadius: 100,
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertions(on: sut)
                .assertSimplexes(
                    accuracy: accuracy,
                    [
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: -150.0, y: -30.0),
                                    radius: 60.00000000000001,
                                    startAngle: Angle(radians: 2.1977925247947656),
                                    sweepAngle: Angle(radians: 2.8148954755916673)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.16870660664537054
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -132.2516485101565, y: -87.31488479786879),
                                    end: .init(x: 99.5805858164058, y: -15.524807996447976)
                                ),
                                startPeriod: 0.16870660664537054,
                                endPeriod: 0.41113094230800334
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 70.0, y: 80.0),
                                    radius: 100.0,
                                    startAngle: Angle(radians: -1.2704973067931533),
                                    sweepAngle: Angle(radians: 3.468289831587919)
                                ),
                                startPeriod: 0.41113094230800334,
                                endPeriod: 0.7575756643373672
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 11.328505092685084, y: 160.97935345099341),
                                    end: .init(x: -185.20289694438895, y: 18.58761207059606)
                                ),
                                startPeriod: 0.7575756643373672,
                                endPeriod: 1.0
                            )
                        ),
                    ]
                )
        }
    }

    func testReversed() {
        let sut = Sut(
            start: .init(x: -150, y: -30),
            startRadius: 60,
            end: .init(x: 70, y: 80),
            endRadius: 100,
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertions(on: sut.reversed())
                .assertSimplexes(
                    accuracy: accuracy,
                    [
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: -185.20289694438895, y: 18.58761207059606),
                                    end: .init(x: 11.328505092685084, y: 160.97935345099341)
                                ),
                                startPeriod: 0.0,
                                endPeriod: 0.24242433566263277
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: 70.0, y: 80.0),
                                    radius: 100.0,
                                    startAngle: Angle(radians: 2.1977925247947656),
                                    sweepAngle: Angle(radians: -3.468289831587919)
                                ),
                                startPeriod: 0.24242433566263277,
                                endPeriod: 0.5888690576919966
                            )
                        ),
                        .lineSegment2(
                            .init(
                                lineSegment: .init(
                                    start: .init(x: 99.5805858164058, y: -15.524807996447976),
                                    end: .init(x: -132.2516485101565, y: -87.31488479786879)
                                ),
                                startPeriod: 0.5888690576919966,
                                endPeriod: 0.8312933933546295
                            )
                        ),
                        .circleArc2(
                            .init(
                                circleArc: .init(
                                    center: .init(x: -150.0, y: -30.0),
                                    radius: 60.00000000000001,
                                    startAngle: Angle(radians: 5.012688000386433),
                                    sweepAngle: Angle(radians: -2.8148954755916673)
                                ),
                                startPeriod: 0.8312933933546295,
                                endPeriod: 1.0
                            )
                        ),
                    ]
                )
        }
    }
}
