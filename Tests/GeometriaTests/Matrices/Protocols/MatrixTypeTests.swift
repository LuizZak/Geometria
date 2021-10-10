import XCTest
import Geometria

class MatrixTypeTests: XCTestCase {
    func testRowMajorValues() {
        let sut = TestMatrix4x4()

        let result = sut.rowMajorValues()

        XCTAssertEqual(
            result, [
                0.0,   1.0,  2.0,  3.0,
                4.0,   5.0,  6.0,  7.0,
                8.0,   9.0, 10.0, 11.0,
                12.0, 13.0, 14.0, 15.0,
            ]
        )
    }

    func testColumnMajorValues() {
        let sut = TestMatrix4x4()

        let result = sut.columnMajorValues()

        XCTAssertEqual(
            result, [
                0.0, 4.0,  8.0, 12.0,
                1.0, 5.0,  9.0, 13.0,
                2.0, 6.0, 10.0, 14.0,
                3.0, 7.0, 11.0, 15.0,
            ]
        )
    }
}

private struct TestMatrix4x4: MatrixType {
    typealias Scalar = Double

    static var identity: Self = Self()

    var rowCount: Int = 4
    var columnCount: Int = 4

    subscript(column: Int, row: Int) -> Scalar {
        get {
            return Double(column + row * columnCount)
        }
        set {
            
        }
    }

    init() {

    }

    prefix static func - (operand: Self) -> Self {
        Self()
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        Self()
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        Self()
    }

    static func * (lhs: Self, rhs: Scalar) -> Self {
        Self()
    }

    static func / (lhs: Self, rhs: Scalar) -> Self {
        Self()
    }
}
