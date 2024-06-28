import XCTest
import Geometria
import TestCommons

class MatrixTypeTests: XCTestCase {
    func testInitWithRowMajorValues() {
        let values = [
            0.0, 1.0,  2.0,  3.0,
            4.0, 5.0,  6.0,  7.0,
            8.0, 9.0, 10.0, 11.0,
        ]
        let sut = TestMatrix4x4(rowMajorValues: values)

        XCTAssertEqual(
            sut.values, [
                0.0, 1.0,  2.0,  3.0,
                4.0, 5.0,  6.0,  7.0,
                8.0, 9.0, 10.0, 11.0,
            ]
        )
    }

    func testInitWithColumnMajorValues() {
        let values = [
            0.0, 4.0,  8.0,
            1.0, 5.0,  9.0,
            2.0, 6.0, 10.0,
            3.0, 7.0, 11.0,
        ]
        let sut = TestMatrix4x4(columnMajorValues: values)

        XCTAssertEqual(
            sut.values, [
                0.0, 1.0,  2.0,  3.0,
                4.0, 5.0,  6.0,  7.0,
                8.0, 9.0, 10.0, 11.0,
            ]
        )
    }

    func testRowMajorValues() {
        let sut = TestMatrix4x4()

        let result = sut.rowMajorValues()

        XCTAssertEqual(
            result, [
                0.0, 1.0,  2.0,  3.0,
                4.0, 5.0,  6.0,  7.0,
                8.0, 9.0, 10.0, 11.0,
            ]
        )
    }

    func testColumnMajorValues() {
        let sut = TestMatrix4x4()

        let result = sut.columnMajorValues()

        XCTAssertEqual(
            result, [
                 0.0, 4.0,  8.0,
                 1.0, 5.0,  9.0,
                 2.0, 6.0, 10.0,
                 3.0, 7.0, 11.0,
            ]
        )
    }
}

private struct TestMatrix4x4: MatrixType {
    typealias Scalar = Double

    static var identity: Self = Self()

    var rowCount: Int = 3
    var columnCount: Int = 4

    var values: [Double]

    subscript(column: Int, row: Int) -> Scalar {
        get {
            return values[column + row * columnCount]
        }
        set {
            values[column + row * columnCount] = newValue
        }
    }

    init() {
        values = (0..<12).map(Double.init)
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
