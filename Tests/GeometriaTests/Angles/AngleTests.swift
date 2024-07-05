import XCTest

@testable import Geometria

class AngleTests: XCTestCase {
    private var _failureCount: Int = 0

    override func setUp() {
        super.setUp()

        _failureCount = 0
    }

    func testNormalizeRadians() {
        self.continueAfterFailure = false

        let twopi: Double = 2 * .pi

        for a: Double in stride(from: -15.0, through: 15.0, by: 0.1) {
            for b: Double in stride(from: -15.0, through: 15.0, by: 0.2) {
                let c = Angle(radians: a).normalized(from: b)

                assertLessThanOrEqual(b, c)
                assertLessThanOrEqual(c, b + twopi)

                let twoK = rint((a - c) / .pi)
                assertEqual(c, a - twoK * .pi, accuracy: 1e-14)
            }
        }
    }

    func testNormalizeAroundZero() {
        let value: Double = 5 * .pi / 4
        let expected: Double = .pi * (1 / 4 - 1)
        let actual: Double = Angle(radians: value).normalized(from: -.pi) //Angle.Rad.WITHIN_MINUS_PI_AND_PI.applyAsDouble(value)
        let tol: Double = expected.ulp

        assertEqual(expected, actual, accuracy: tol)
    }

    func testNormalizeVeryCloseToBounds() {
        let nZero = { (a: Double) -> Double in
            Angle(radians: a).normalized(from: -.pi)
        }
        let nPi = { (a: Double) -> Double in
            Angle(radians: a).normalized(from: 0)
        }

        // arrange
        let pi = Double.pi
        let small = (pi * 2).ulp
        let tiny: Double = 5e-17 // pi + tiny = pi (the value is too small to add to pi)

        // act/assert
        assertEqual((.pi * 2) - small, nPi(-small))
        assertEqual(small, nPi(small))

        assertEqual(pi - small, nZero(-pi - small))
        assertEqual(-pi + small, nZero(pi + small))

        assertEqual(0, nPi(-tiny))
        assertEqual(tiny, nPi(tiny))

        assertEqual(-pi, nZero(-pi - tiny))
        assertEqual(-pi, nZero(pi + tiny))
    }

    func testNormalizeRetainsInputPrecision() {
        let nZero = { (a: Double) -> Double in
            Angle(radians: a).normalized(from: -.pi)
        }
        let nPi = { (a: Double) -> Double in
            Angle(radians: a).normalized(from: 0)
        }

        let aboveZero: Double = (0.0).nextUp
        let belowZero: Double = (0.0).nextDown

        assertEqual(aboveZero, nZero(aboveZero))
        assertEqual(aboveZero, nPi(aboveZero))

        assertEqual(belowZero, nZero(belowZero))
        assertEqual(0, nPi(belowZero))
    }

    func testRelativeAngles_unequal() {
        let angle1 = Angle(radians: .pi * 0.3)
        let angle2 = Angle(radians: .pi * 0.6)

        let (low, high) = angle1.relativeAngles(to: angle2)

        assertEqual(low.radians, .pi * 0.3)
        assertEqual(high.radians, -.pi * 1.7)
    }

    func testRelativeAngles_unequal_greaterAngle1() {
        let angle1 = Angle(radians: .pi * 0.6)
        let angle2 = Angle(radians: .pi * 0.3)

        let (low, high) = angle1.relativeAngles(to: angle2)

        assertEqual(low.radians, -.pi * 0.3)
        assertEqual(high.radians, .pi * 1.7)
    }

    func testRelativeAngles_equal() {
        let angle1 = Angle(radians: .pi * 0.3)
        let angle2 = Angle(radians: .pi * 0.3)

        let (low, high) = angle1.relativeAngles(to: angle2)

        assertEqual(low.radians, 0.0)
        assertEqual(high.radians, -.pi * 2)
    }

    func testRelativeAngles_nonNormalized() {
        let angle1 = Angle(radians: -.pi * 20.3)
        let angle2 = Angle(radians: .pi * 6.3)

        let (low, high) = angle1.relativeAngles(to: angle2)

        assertEqual(low.radians, 1.8849555921538723)
        assertEqual(high.radians, -4.398229715025714)
    }

    // MARK: - Test internals

    private func assertLessThanOrEqual<T: Comparable>(
        _ lhs: T,
        _ rhs: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard _failureCount < 10 else { return }
        if lhs <= rhs { return }

        XCTAssertLessThanOrEqual(lhs, rhs, file: file, line: line)
        _failureCount += 1
    }

    private func assertEqual<T: FloatingPoint>(
        _ lhs: T,
        _ rhs: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard _failureCount < 10 else { return }
        if lhs == rhs { return }

        XCTFail("\(lhs) != \(rhs)", file: file, line: line)
        _failureCount += 1
    }

    private func assertEqual<T: FloatingPoint>(
        _ lhs: T,
        _ rhs: T,
        accuracy: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard _failureCount < 10 else { return }
        if rhs.isApproximatelyEqual(to: rhs, absoluteTolerance: accuracy) { return }

        XCTFail("\(lhs) != \(rhs) +/- \(accuracy)", file: file, line: line)
        _failureCount += 1
    }
}
