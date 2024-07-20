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
