import XCTest
@testable import Geometria

class Matrix3x3Tests: XCTestCase {
    let accuracy: Double = 1e-16
    
    typealias Matrix = Matrix3x3<Double>
    
    func testIdentity() {
        let sut = Matrix.idendity
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 1, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testEquality() {
        XCTAssertEqual(
            Matrix(rows: (
                (0, 1, 3),
                (4, 5, 6),
                (7, 8, 9)
            )),
            Matrix(rows: (
                (0, 1, 3),
                (4, 5, 6),
                (7, 8, 9)
            ))
        )
    }
    
    func testUnequality() {
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((D, 1, 2), (4, 5, 6), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, D, 2), (4, 5, 6), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, D), (4, 5, 6), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (D, 5, 6), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (4, D, 6), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (4, 5, D), (8, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (D, 9, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, D, 10)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, 10))),
            Matrix(rows: ((0, 1, 2), (4, 5, 6), (8, 9, D)))
        )
    }
    
    func testRows() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        assertEqual(sut.r0, (0, 1, 2))
        assertEqual(sut.r1, (3, 4, 5))
        assertEqual(sut.r2, (6, 7, 8))
    }
    
    func testRows_set() {
        var sut = Matrix(repeating: 0)
        
        sut.r0 = (0, 1, 2)
        sut.r1 = (3, 4, 5)
        sut.r2 = (6, 7, 8)
        
        assertEqual(sut.r0, (0, 1, 2))
        assertEqual(sut.r1, (3, 4, 5))
        assertEqual(sut.r2, (6, 7, 8))
    }
    
    func testColumns() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        assertEqual(sut.c0, (0, 3, 6))
        assertEqual(sut.c1, (1, 4, 7))
        assertEqual(sut.c2, (2, 5, 8))
    }
    
    func testColumns_set() {
        var sut = Matrix(repeating: 0)
        
        sut.c0 = (0, 1, 2)
        sut.c1 = (3, 4, 5)
        sut.c2 = (6, 7, 8)
        
        assertEqual(sut.r0, (0, 3, 6))
        assertEqual(sut.r1, (1, 4, 7))
        assertEqual(sut.r2, (2, 5, 8))
    }
    
    func testRowsAsVectors() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        XCTAssertEqual(sut.r0Vec, Vector3D(x: 0, y: 1, z: 2))
        XCTAssertEqual(sut.r1Vec, Vector3D(x: 3, y: 4, z: 5))
        XCTAssertEqual(sut.r2Vec, Vector3D(x: 6, y: 7, z: 8))
    }
    
    func testColumnsAsVector() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        XCTAssertEqual(sut.c0Vec, Vector3D(x: 0, y: 3, z: 6))
        XCTAssertEqual(sut.c1Vec, Vector3D(x: 1, y: 4, z: 7))
        XCTAssertEqual(sut.c2Vec, Vector3D(x: 2, y: 5, z: 8))
    }
    
    func testSubscript() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        // Row 0
        XCTAssertEqual(sut[0, 0], 0)
        XCTAssertEqual(sut[1, 0], 1)
        XCTAssertEqual(sut[2, 0], 2)
        // Row 1
        XCTAssertEqual(sut[0, 1], 3)
        XCTAssertEqual(sut[1, 1], 4)
        XCTAssertEqual(sut[2, 1], 5)
        // Row 2
        XCTAssertEqual(sut[0, 2], 6)
        XCTAssertEqual(sut[1, 2], 7)
        XCTAssertEqual(sut[2, 2], 8)
    }
    
    func testSubscript_set() {
        var sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        // Row 0
        sut[0, 0] = 0 * 2 + 1
        sut[1, 0] = 1 * 2 + 1
        sut[2, 0] = 2 * 2 + 1
        // Row 1
        sut[0, 1] = 4 * 2 + 1
        sut[1, 1] = 5 * 2 + 1
        sut[2, 1] = 6 * 2 + 1
        // Row 2
        sut[0, 2] = 8 * 2 + 1
        sut[1, 2] = 9 * 2 + 1
        sut[2, 2] = 10 * 2 + 1
        
        assertEqual(sut.r0, ( 1,  3,  5))
        assertEqual(sut.r1, ( 9, 11, 13))
        assertEqual(sut.r2, (17, 19, 21))
    }
    
    func testDescription() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        XCTAssertEqual(
            sut.description,
            "Matrix3x3<Double>(rows: ((0.0, 1.0, 2.0), (3.0, 4.0, 5.0), (6.0, 7.0, 8.0)))"
        )
    }
    
    func testInit() {
        let sut = Matrix()
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 1, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testInitWithRows() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        assertEqual(sut.r0, (0, 1, 2))
        assertEqual(sut.r1, (3, 4, 5))
        assertEqual(sut.r2, (6, 7, 8))
    }
    
    func testInitRepeating() {
        let sut = Matrix(repeating: 1)
        
        assertEqual(sut.r0, (1, 1, 1))
        assertEqual(sut.r1, (1, 1, 1))
        assertEqual(sut.r2, (1, 1, 1))
    }
    
    func testDeterminant() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3),
            ( 5,  7, 11),
            (13, 17, 19)
        ))
        
        XCTAssertEqual(sut.determinant(), 24.0)
    }
    
    func testTransformPointVector3() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let vec = Vector3D(x: 0, y: 1, z: 2)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 5.0)
        XCTAssertEqual(result.y, 14.0)
        XCTAssertEqual(result.z, 23.0)
    }
    
    func testTransformPointVector2() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let vec = Vector2D(x: 0, y: 1)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 0.2)
        XCTAssertEqual(result.y, 0.6)
    }
    
    func testTransformPointVector2_translate() {
        let sut =
        Matrix(rows: (
            (1, 0,  4),
            (0, 1, -5),
            (0, 0,  1)
        ))
        let vec = Vector2D(x: 1, y: 2)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, -3)
    }
    
    func testTransposed() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        let result = sut.transposed()
        
        assertEqual(result.r0, (0, 3, 6))
        assertEqual(result.r1, (1, 4, 7))
        assertEqual(result.r2, (2, 5, 8))
    }
    
    func testTranspose() {
        var sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        sut.transpose()
        
        assertEqual(sut.r0, (0, 3, 6))
        assertEqual(sut.r1, (1, 4, 7))
        assertEqual(sut.r2, (2, 5, 8))
    }
    
    func testMakeScaleXY() {
        let sut = Matrix.makeScale(x: 1, y: 2)
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testMakeScaleVector() {
        let vec = Vector2D(x: 1, y: 2)
        let sut = Matrix.makeScale(vec)
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testMakeZRotation() {
        let sut = Matrix.makeRotation(.pi / 3)
        
        assertEqual(sut.r0, ( 0.5000000000000001, 0.8660254037844386, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-0.8660254037844386, 0.5000000000000001, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeZRotation_halfPi() {
        let sut = Matrix.makeRotation(.pi / 2)
        
        assertEqual(sut.r0, ( 0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, ( 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeZRotation_minusHalfPi() {
        let sut = Matrix.makeRotation(-.pi / 2)
        
        assertEqual(sut.r0, (0, -1, 0), accuracy: accuracy)
        assertEqual(sut.r1, (1,  0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0,  0, 1), accuracy: accuracy)
    }
    
    func testMakeTranslationXYZ() {
        let sut = Matrix.makeTranslation(x: 1, y: 2)
        
        assertEqual(sut.r0, (1, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeTranslationVector() {
        let vec = Vector2D(x: 1, y: 2)
        let sut = Matrix.makeTranslation(vec)
        
        assertEqual(sut.r0, (1, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func testMultiply() {
        let lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let rhs =
        Matrix(rows: (
            (9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        let result = lhs * rhs
        
        assertEqual(result.r0, ( 42.0,  45.0,  48.0))
        assertEqual(result.r1, (150.0, 162.0, 174.0))
        assertEqual(result.r2, (258.0, 279.0, 300.0))
    }
    
    func testMultiply_inPlace() {
        var lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let rhs =
        Matrix(rows: (
            (9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        lhs *= rhs
        
        assertEqual(lhs.r0, ( 42.0,  45.0,  48.0))
        assertEqual(lhs.r1, (150.0, 162.0, 174.0))
        assertEqual(lhs.r2, (258.0, 279.0, 300.0))
    }
}