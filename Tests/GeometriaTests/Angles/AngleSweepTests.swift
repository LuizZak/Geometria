import XCTest

@testable import Geometria

class AngleSweepTests: XCTestCase {
    typealias Sut = AngleSweep<Double>

    func testIsEquivalent_equal() {
        assertIsEquivalent(
            .init(start: .pi, sweep: .pi / 2),
            .init(start: .pi, sweep: .pi / 2)
        )
        assertIsEquivalent(
            .init(start: 0.0, sweep: .pi / 2),
            .init(start: 0.0, sweep: .pi / 2)
        )
        assertNotIsEquivalent(
            .init(start: .pi, sweep: .pi / 2),
            .init(start: .pi / 2, sweep: .pi / 2)
        )
    }

    func testIsEquivalent_equivalentSweep() {
        assertIsEquivalent(
            .init(start: .pi / 2, sweep: .pi / 2),
            .init(start: .pi, sweep: -.pi / 2)
        )
        assertIsEquivalent(
            .init(start: -.pi / 2, sweep: .pi),
            .init(start: .pi / 2, sweep: -.pi)
        )
    }

    func testRatioOfAngle() {
        let sut = Sut(
            start: Angle.pi * 0.2,
            sweep: Angle.pi * 0.5
        )

        XCTAssertEqual(
            sut.ratioOfAngle(.zero),
            -0.4
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.2),
            0.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.5),
            0.6
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.7),
            1.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.0),
            1.6
        )
    }

    func testRatioOfAngle_negativeSweep() {
        let sut = Sut(
            start: Angle.pi * 0.7,
            sweep: Angle.pi * -0.5
        )

        XCTAssertEqual(
            sut.ratioOfAngle(.zero),
            1.4
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.2),
            1.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.5),
            0.4
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.7),
            0.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.0),
            -0.6,
            accuracy: 1e-14
        )
    }

    func testRatioOfAngle_stopsAtOrigin() {
        let sut = Sut(
            start: Angle.pi * 1.8,
            sweep: Angle.pi * 0.2
        )

        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.7),
            -0.5
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.8),
            0.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.zero),
            1.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.4),
            -7.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.6),
            -6.0
        )
    }

    func testRatioOfAngle_acrossOrigin() {
        let sut = Sut(
            start: Angle.pi * 1.8,
            sweep: Angle.pi * 0.4
        )

        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.7),
            -0.25
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 1.8),
            0.0
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.zero),
            0.5
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.4),
            -3.5
        )
        XCTAssertEqual(
            sut.ratioOfAngle(.pi * 0.6),
            -3.0
        )
    }
}

// MARK: - Test internals

private func assertIsEquivalent(
    _ lhs: AngleSweep<Double>,
    _ rhs: AngleSweep<Double>,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard !lhs.isEquivalent(to: rhs) else {
        return
    }

    XCTFail("\(lhs) is not equivalent to \(rhs)", file: file, line: line)
}

private func assertNotIsEquivalent(
    _ lhs: AngleSweep<Double>,
    _ rhs: AngleSweep<Double>,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard lhs.isEquivalent(to: rhs) else {
        return
    }

    XCTFail("\(lhs) is equivalent to \(rhs)", file: file, line: line)
}
