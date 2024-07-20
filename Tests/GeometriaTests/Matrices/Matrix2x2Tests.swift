import XCTest
import Geometria
import TestCommons

class Matrix2x2Tests: XCTestCase {
    let accuracy: Double = 1e-16
    
    typealias Matrix = Matrix2x2<Double>
    
    func testIdentity() {
        let sut = Matrix.identity
        
        assertEqual(sut.r0, (1, 0))
        assertEqual(sut.r1, (0, 1))
    }
    
    func testEquality() {
        XCTAssertEqual(
            Matrix(rows: (
                (0, 1),
                (2, 3)
            )),
            Matrix(rows: (
                (0, 1),
                (2, 3)
            ))
        )
    }
    
    func testUnequality() {
        // cspell:disable-next-line
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((D, 1), (2, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, D), (2, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, 1), (D, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, 1), (2, D)))
        )
    }
    
    func testRows() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        assertEqual(sut.r0, (0, 1))
        assertEqual(sut.r1, (2, 3))
    }
    
    func testRows_set() {
        var sut = Matrix(repeating: 0)
        
        sut.r0 = (0, 1)
        sut.r1 = (2, 3)
        
        assertEqual(sut.r0, (0, 1))
        assertEqual(sut.r1, (2, 3))
    }
    
    func testColumns() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        assertEqual(sut.c0, (0, 2))
        assertEqual(sut.c1, (1, 3))
    }
    
    func testColumns_set() {
        var sut = Matrix(repeating: 0)
        
        sut.c0 = (0, 1)
        sut.c1 = (2, 3)
        
        assertEqual(sut.r0, (0, 2))
        assertEqual(sut.r1, (1, 3))
    }
    
    func testRowsAsVectors() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(sut.r0Vec, Vector2D(x: 0, y: 1))
        XCTAssertEqual(sut.r1Vec, Vector2D(x: 2, y: 3))
    }
    
    func testColumnsAsVector() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(sut.c0Vec, Vector2D(x: 0, y: 2))
        XCTAssertEqual(sut.c1Vec, Vector2D(x: 1, y: 3))
    }
    
    func testRowColumnCount() {
        let sut = Matrix()
        
        XCTAssertEqual(sut.rowCount, 2)
        XCTAssertEqual(sut.columnCount, 2)
    }
    
    func testSubscript() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        // Row 0
        XCTAssertEqual(sut[0, 0], 0)
        XCTAssertEqual(sut[1, 0], 1)
        // Row 1
        XCTAssertEqual(sut[0, 1], 2)
        XCTAssertEqual(sut[1, 1], 3)
    }
    
    func testSubscript_set() {
        var sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        // Row 0
        sut[0, 0] = 0 * 2 + 1
        sut[1, 0] = 1 * 2 + 1
        // Row 1
        sut[0, 1] = 2 * 2 + 1
        sut[1, 1] = 3 * 2 + 1
        
        assertEqual(sut.r0, (1.0, 3.0))
        assertEqual(sut.r1, (5.0, 7.0))
    }
    
    func testTrace() {
        let sut = Matrix(rows: (
            ( 1, 2),
            (-3, 4)
        ))
        
        XCTAssertEqual(sut.trace, 5)
    }
    
    func testDescription() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(
            sut.description,
            "Matrix2x2<Double>(rows: ((0.0, 1.0), (2.0, 3.0)))"
        )
    }
    
    func testInit() {
        let sut = Matrix()
        
        assertEqual(sut.r0, (1, 0))
        assertEqual(sut.r1, (0, 1))
    }
    
    func testInitWithRows() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        assertEqual(sut.r0, (0, 1))
        assertEqual(sut.r1, (2, 3))
    }
    
    func testInitWithVectorRows() {
        let sut = Matrix(rows: (
            Vector2D(x: 0, y: 1),
            Vector2D(x: 2, y: 3)
        ))
        
        assertEqual(sut.r0, (0, 1))
        assertEqual(sut.r1, (2, 3))
    }
    
    func testInitRepeating() {
        let sut = Matrix(repeating: 1)
        
        assertEqual(sut.r0, (1, 1))
        assertEqual(sut.r1, (1, 1))
    }
    
    func testInitWithDiagonal() {
        let sut = Matrix(diagonal: (1, 2))
        
        assertEqual(sut.r0, (1, 0))
        assertEqual(sut.r1, (0, 2))
    }
    
    func testInitWithScalarDiagonal() {
        let sut = Matrix(diagonal: 2)
        
        assertEqual(sut.r0, (2, 0))
        assertEqual(sut.r1, (0, 2))
    }
    
    func testDeterminant() {
        let sut = Matrix(rows: (
            (1, 2),
            (3, 5)
        ))
        
        XCTAssertEqual(sut.determinant(), -1)
    }
    
    func testTransformPointVector2() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let vec = Vector2D(x: 0, y: 1)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 1.0)
        XCTAssertEqual(result.y, 3.0)
    }
    
    func testTransposed() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        let result = sut.transposed()
        
        assertEqual(result.r0, (0, 2))
        assertEqual(result.r1, (1, 3))
    }
    
    func testTranspose() {
        var sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        sut.transpose()
        
        assertEqual(sut.r0, (0, 2))
        assertEqual(sut.r1, (1, 3))
    }
    
    func testInverted() throws {
        let sut = Matrix(rows: (
            ( 1, 2),
            (-7, 2)
        ))
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, ( 0.125, -0.125), accuracy: accuracy)
        assertEqual(result.r1, (0.4375, 0.0625), accuracy: accuracy)
    }
    
    func testInverted_identity_returnsIdentity() throws {
        let sut = Matrix.identity
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, Matrix.identity.r0, accuracy: accuracy)
        assertEqual(result.r1, Matrix.identity.r1, accuracy: accuracy)
    }
    
    func testInverted_0DeterminantMatrix_returnsNil() {
        let sut = Matrix(rows: (
            (1, 2),
            (2, 4)
        ))
        
        XCTAssertNil(sut.inverted())
    }
    
    func testAddition() {
        let lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        let result = lhs + rhs
        
        assertEqual(result.r0, (4,  6))
        assertEqual(result.r1, (8, 10))
    }
    
    func testAddition_inPlace() {
        var lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        lhs += rhs
        
        assertEqual(lhs.r0, (4,  6))
        assertEqual(lhs.r1, (8, 10))
    }
    
    func testSubtraction() {
        let lhs = Matrix(rows: (
            (1, 3),
            (2, 0)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        let result = lhs - rhs
        
        assertEqual(result.r0, (-3, -2))
        assertEqual(result.r1, (-4, -7))
    }
    
    func testSubtraction_inPlace() {
        var lhs = Matrix(rows: (
            (1, 3),
            (2, 0)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        lhs -= rhs
        
        assertEqual(lhs.r0, (-3, -2))
        assertEqual(lhs.r1, (-4, -7))
    }
    
    func testNegate() {
        let lhs = Matrix(rows: (
            (-0,  1),
            (-4,  5)
        ))
        
        let result = -lhs
        
        assertEqual(result.r0, (0,  -1))
        assertEqual(result.r1, (4,  -5))
    }
    
    func testMultiplication_withScalar() {
        let lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        let result = lhs * 2
        
        assertEqual(result.r0, (0, 2))
        assertEqual(result.r1, (4, 6))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        lhs *= 2
        
        assertEqual(lhs.r0, (0, 2))
        assertEqual(lhs.r1, (4, 6))
    }
    
    func testDivision_withScalar() {
        let lhs = Matrix(rows: (
            (0, 2),
            (4, 6)
        ))
        
        let result = lhs / 2
        
        assertEqual(result.r0, (0, 1))
        assertEqual(result.r1, (2, 3))
    }
    
    func testDivision_withScalar_inPlace() {
        var lhs = Matrix(rows: (
            (0, 2),
            (4, 6)
        ))
        
        lhs /= 2
        
        assertEqual(lhs.r0, (0, 1))
        assertEqual(lhs.r1, (2, 3))
    }
    
    func testMultiply() {
        let lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        let result = lhs * rhs
        
        assertEqual(result.r0, ( 6.0,  7.0))
        assertEqual(result.r1, (26.0, 31.0))
    }
    
    func testMultiply_inPlace() {
        var lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        lhs *= rhs
        
        assertEqual(lhs.r0, ( 6.0,  7.0))
        assertEqual(lhs.r1, (26.0, 31.0))
    }
}
