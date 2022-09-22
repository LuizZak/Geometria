import XCTest
@testable import Geometria

class Matrix4x4Tests: XCTestCase {
    let accuracy: Double = 1e-16
    
    typealias Matrix = Matrix4x4<Double>
    
    func testIdentity() {
        let sut = Matrix.identity
        
        assertEqual(sut.r0, (1, 0, 0, 0))
        assertEqual(sut.r1, (0, 1, 0, 0))
        assertEqual(sut.r2, (0, 0, 1, 0))
        assertEqual(sut.r3, (0, 0, 0, 1))
    }
    
    func testEquality() {
        let sut = Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        XCTAssertEqual(sut, sut)
    }
    
    func testUnequality() {
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((D, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, D, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, D, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, D), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (D, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, D, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, D, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, D), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (D, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, D, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, D, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, D), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (D, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, D, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, D, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, D)))
        )
    }
    
    func testRows() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        assertEqual(sut.r0, ( 0,  1,  2,  3))
        assertEqual(sut.r1, ( 4,  5,  6,  7))
        assertEqual(sut.r2, ( 8,  9, 10, 11))
        assertEqual(sut.r3, (12, 13, 14, 15))
    }
    
    func testRows_set() {
        var sut = Matrix(repeating: 0)
        
        sut.r0 = ( 0,  1,  2,  3)
        sut.r1 = ( 4,  5,  6,  7)
        sut.r2 = ( 8,  9, 10, 11)
        sut.r3 = (12, 13, 14, 15)
        
        assertEqual(sut.r0, ( 0,  1,  2,  3))
        assertEqual(sut.r1, ( 4,  5,  6,  7))
        assertEqual(sut.r2, ( 8,  9, 10, 11))
        assertEqual(sut.r3, (12, 13, 14, 15))
    }
    
    func testColumns() {
        let sut = Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        assertEqual(sut.c0, (0, 4,  8, 12))
        assertEqual(sut.c1, (1, 5,  9, 13))
        assertEqual(sut.c2, (2, 6, 10, 14))
        assertEqual(sut.c3, (3, 7, 11, 15))
    }
    
    func testColumns_set() {
        var sut = Matrix(repeating: 0)
        
        sut.c0 = ( 0,  1,  2,  3)
        sut.c1 = ( 4,  5,  6,  7)
        sut.c2 = ( 8,  9, 10, 11)
        sut.c3 = (12, 13, 14, 15)
        
        assertEqual(sut.r0, (0, 4,  8, 12))
        assertEqual(sut.r1, (1, 5,  9, 13))
        assertEqual(sut.r2, (2, 6, 10, 14))
        assertEqual(sut.r3, (3, 7, 11, 15))
    }
    
    func testRowsAsVectors() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        XCTAssertEqual(sut.r0Vec, Vector4D(x: 0, y: 1, z: 2, w: 3))
        XCTAssertEqual(sut.r1Vec, Vector4D(x: 4, y: 5, z: 6, w: 7))
        XCTAssertEqual(sut.r2Vec, Vector4D(x: 8, y: 9, z: 10, w: 11))
        XCTAssertEqual(sut.r3Vec, Vector4D(x: 12, y: 13, z: 14, w: 15))
    }
    
    func testColumnsAsVector() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        XCTAssertEqual(sut.c0Vec, Vector4D(x: 0.0, y: 4.0, z: 8.0, w: 12.0))
        XCTAssertEqual(sut.c1Vec, Vector4D(x: 1.0, y: 5.0, z: 9.0, w: 13.0))
        XCTAssertEqual(sut.c2Vec, Vector4D(x: 2.0, y: 6.0, z: 10.0, w: 14.0))
        XCTAssertEqual(sut.c3Vec, Vector4D(x: 3.0, y: 7.0, z: 11.0, w: 15.0))
    }
    
    func testRowColumnCount() {
        let sut = Matrix()
        
        XCTAssertEqual(sut.rowCount, 4)
        XCTAssertEqual(sut.columnCount, 4)
    }
    
    func testSubscript() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        // Row 0
        XCTAssertEqual(sut[0, 0], 0)
        XCTAssertEqual(sut[1, 0], 1)
        XCTAssertEqual(sut[2, 0], 2)
        XCTAssertEqual(sut[3, 0], 3)
        // Row 1
        XCTAssertEqual(sut[0, 1], 4)
        XCTAssertEqual(sut[1, 1], 5)
        XCTAssertEqual(sut[2, 1], 6)
        XCTAssertEqual(sut[3, 1], 7)
        // Row 2
        XCTAssertEqual(sut[0, 2], 8)
        XCTAssertEqual(sut[1, 2], 9)
        XCTAssertEqual(sut[2, 2], 10)
        XCTAssertEqual(sut[3, 2], 11)
        // Row 3
        XCTAssertEqual(sut[0, 3], 12)
        XCTAssertEqual(sut[1, 3], 13)
        XCTAssertEqual(sut[2, 3], 14)
        XCTAssertEqual(sut[3, 3], 15)
    }
    
    func testSubscript_set() {
        var sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        // Row 0
        sut[0, 0] = 0 * 2 + 1
        sut[1, 0] = 1 * 2 + 1
        sut[2, 0] = 2 * 2 + 1
        sut[3, 0] = 3 * 2 + 1
        // Row 1
        sut[0, 1] = 4 * 2 + 1
        sut[1, 1] = 5 * 2 + 1
        sut[2, 1] = 6 * 2 + 1
        sut[3, 1] = 7 * 2 + 1
        // Row 2
        sut[0, 2] = 8 * 2 + 1
        sut[1, 2] = 9 * 2 + 1
        sut[2, 2] = 10 * 2 + 1
        sut[3, 2] = 11 * 2 + 1
        // Row 3
        sut[0, 3] = 12 * 2 + 1
        sut[1, 3] = 13 * 2 + 1
        sut[2, 3] = 14 * 2 + 1
        sut[3, 3] = 15 * 2 + 1
        
        assertEqual(sut.r0, ( 1,  3,  5,  7))
        assertEqual(sut.r1, ( 9, 11, 13, 15))
        assertEqual(sut.r2, (17, 19, 21, 23))
        assertEqual(sut.r3, (25, 27, 29, 31))
    }
    
    func testTrace() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        XCTAssertEqual(sut.trace, 30)
    }
    
    func testDescription() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        XCTAssertEqual(
            sut.description,
            "Matrix4x4<Double>(rows: ((0.0, 1.0, 2.0, 3.0), (4.0, 5.0, 6.0, 7.0), (8.0, 9.0, 10.0, 11.0), (12.0, 13.0, 14.0, 15.0)))"
        )
    }
    
    func testInit() {
        let sut = Matrix()
        
        assertEqual(sut.r0, (1, 0, 0, 0))
        assertEqual(sut.r1, (0, 1, 0, 0))
        assertEqual(sut.r2, (0, 0, 1, 0))
        assertEqual(sut.r3, (0, 0, 0, 1))
    }
    
    func testInitWithRows() {
        let sut =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        assertEqual(sut.r0, ( 0,  1,  2,  3))
        assertEqual(sut.r1, ( 4,  5,  6,  7))
        assertEqual(sut.r2, ( 8,  9, 10, 11))
        assertEqual(sut.r3, (12, 13, 14, 15))
    }
    
    func testInitWithVectorRows() {
        let sut =
        Matrix(rows: (
            Vector4D(x:  0, y:  1, z:  2, w:  3),
            Vector4D(x:  4, y:  5, z:  6, w:  7),
            Vector4D(x:  8, y:  9, z: 10, w: 11),
            Vector4D(x: 12, y: 13, z: 14, w: 15)
        ))
        
        assertEqual(sut.r0, ( 0,  1,  2,  3))
        assertEqual(sut.r1, ( 4,  5,  6,  7))
        assertEqual(sut.r2, ( 8,  9, 10, 11))
        assertEqual(sut.r3, (12, 13, 14, 15))
    }
    
    func testInitRepeating() {
        let sut = Matrix(repeating: 1)
        
        assertEqual(sut.r0, (1, 1, 1, 1))
        assertEqual(sut.r1, (1, 1, 1, 1))
        assertEqual(sut.r2, (1, 1, 1, 1))
        assertEqual(sut.r3, (1, 1, 1, 1))
    }
    
    func testInitWithDiagonal() {
        let sut = Matrix(diagonal: (1, 2, 3, 4))
        
        assertEqual(sut.r0, (1, 0, 0, 0))
        assertEqual(sut.r1, (0, 2, 0, 0))
        assertEqual(sut.r2, (0, 0, 3, 0))
        assertEqual(sut.r3, (0, 0, 0, 4))
    }
    
    func testInitWithScalarDiagonal() {
        let sut = Matrix(diagonal: 2)
        
        assertEqual(sut.r0, (2, 0, 0, 0))
        assertEqual(sut.r1, (0, 2, 0, 0))
        assertEqual(sut.r2, (0, 0, 2, 0))
        assertEqual(sut.r3, (0, 0, 0, 2))
    }
    
    func testDeterminant() {
        let sut =
        Matrix(rows: (
            ( 2,  3,  5,  7),
            (11, 13, 17, 19),
            (23, 29, 31, 37),
            (41, 43, 47, 51)
        ))
        
        XCTAssertEqual(sut.determinant(), 740)
    }
    
    func testTransformPoint_vector4() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        let vec = Vector4D(x: 0, y: 1, z: 2, w: 3)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 20.0)
        XCTAssertEqual(result.y, 44.0)
        XCTAssertEqual(result.z, 68.0)
        XCTAssertEqual(result.w, 92.0)
    }
    
    func testTransformPoint_vector3() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        let vec = Vector3D(x: 0, y: 1, z: 2)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 0.2)
        XCTAssertEqual(result.y, 0.4666666666666667)
        XCTAssertEqual(result.z, 0.7333333333333333)
    }
    
    func testTransformPoint_vector3_translate() {
        let sut =
        Matrix(rows: (
            (1, 0, 0,  4),
            (0, 1, 0, -5),
            (0, 0, 1,  6),
            (0, 0, 0,  1)
        ))
        let vec = Vector3D(x: 1, y: 2, z: 3)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, -3)
        XCTAssertEqual(result.z, 9)
    }
    
    func testTransformVector_vector3() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        let vec = Vector3D(x: 0, y: 1, z: 2)
        
        let result = sut.transformVector(vec)
        
        XCTAssertEqual(result.x, 12.0)
        XCTAssertEqual(result.y, 28.0)
        XCTAssertEqual(result.z, 44.0)
    }
    
    func testTransposed() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        
        let result = sut.transposed()
        
        assertEqual(result.r0, (1, 5,  9, 13))
        assertEqual(result.r1, (2, 6, 10, 14))
        assertEqual(result.r2, (3, 7, 11, 15))
        assertEqual(result.r3, (4, 8, 12, 16))
    }
    
    func testTranspose() {
        var sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        
        sut.transpose()
        
        assertEqual(sut.r0, (1, 5,  9, 13))
        assertEqual(sut.r1, (2, 6, 10, 14))
        assertEqual(sut.r2, (3, 7, 11, 15))
        assertEqual(sut.r3, (4, 8, 12, 16))
    }
    
    func testInverted() throws {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  1,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15,  1)
        ))
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, (-0.754166666666666727,  0.100000000000000008,  0.187500000000000015, -0.033333333333333336), accuracy: accuracy)
        assertEqual(result.r1, ( 0.100000000000000008, -0.200000000000000016,  0.100000000000000008,  0                   ), accuracy: accuracy)
        assertEqual(result.r2, ( 0.562500000000000045,  0.100000000000000008, -0.262500000000000021,  0.100000000000000008), accuracy: accuracy)
        assertEqual(result.r3, (-0.033333333333333336,  0                   ,  0.100000000000000008, -0.066666666666666672), accuracy: accuracy)
    }
    
    func testInverted_zerosOnDiagonal() throws {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  0,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15,  0)
        ))
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, (-0.7447916666666665904,  0.0833333333333333248,  0.1927083333333333136, -0.0312499999999999968), accuracy: accuracy)
        assertEqual(result.r1, ( 0.0833333333333333248, -0.1666666666666666496,  0.0833333333333333248,  0                    ), accuracy: accuracy)
        assertEqual(result.r2, ( 0.5677083333333332752,  0.0833333333333333248, -0.2447916666666666416,  0.0937499999999999904), accuracy: accuracy)
        assertEqual(result.r3, (-0.0312499999999999968,  0                    ,  0.0937499999999999904, -0.0624999999999999936), accuracy: accuracy)
    }
    
    func testInverted_identity_returnsIdentity() throws {
        let sut = Matrix.identity
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, Matrix.identity.r0, accuracy: accuracy)
        assertEqual(result.r1, Matrix.identity.r1, accuracy: accuracy)
        assertEqual(result.r2, Matrix.identity.r2, accuracy: accuracy)
        assertEqual(result.r3, Matrix.identity.r3, accuracy: accuracy)
    }
    
    func testInverted_0DeterminantMatrix_returnsNil() {
        let sut =
        Matrix(rows: (
            ( 1,  2,  3,  4),
            ( 5,  6,  7,  8),
            ( 9, 10, 11, 12),
            (13, 14, 15, 16)
        ))
        
        XCTAssertNil(sut.inverted())
    }
    
    func testMakeScaleXYZ() {
        let sut = Matrix.makeScale(x: 1, y: 2, z: 3)
        
        assertEqual(sut.r0, (1, 0, 0, 0))
        assertEqual(sut.r1, (0, 2, 0, 0))
        assertEqual(sut.r2, (0, 0, 3, 0))
        assertEqual(sut.r3, (0, 0, 0, 1))
    }
    
    func testMakeScaleVector() {
        let vec = Vector3D(x: 1, y: 2, z: 3)
        let sut = Matrix.makeScale(vec)
        
        assertEqual(sut.r0, (1, 0, 0, 0))
        assertEqual(sut.r1, (0, 2, 0, 0))
        assertEqual(sut.r2, (0, 0, 3, 0))
        assertEqual(sut.r3, (0, 0, 0, 1))
    }
    
    func testMakeXRotation() {
        let sut = Matrix.makeXRotation(.pi / 3)
        
        assertEqual(sut.r0, (1, 0, 0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (0,  0.5000000000000001, 0.8660254037844386, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, -0.8660254037844386, 0.5000000000000001, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeXRotation_halfPi() {
        let sut = Matrix.makeXRotation(.pi / 2)
        
        assertEqual(sut.r0, (1,  0, 0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (0,  0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, -1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0,  0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeXRotation_minusHalfPi() {
        let sut = Matrix.makeXRotation(-.pi / 2)
        
        assertEqual(sut.r0, (1, 0,  0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (0, 0, -1, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, 1,  0, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0,  0, 1), accuracy: accuracy)
    }
    
    func testMakeYRotation() {
        let sut = Matrix.makeYRotation(.pi / 3)
        
        assertEqual(sut.r0, (0.5000000000000001, 0, -0.8660254037844386, 0), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0.8660254037844386, 0, 0.5000000000000001, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeYRotation_halfPi() {
        let sut = Matrix.makeYRotation(.pi / 2)
        
        assertEqual(sut.r0, (0, 0, -1, 0), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1,  0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (1, 0,  0, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0,  0, 1), accuracy: accuracy)
    }
    
    func testMakeYRotation_minusHalfPi() {
        let sut = Matrix.makeYRotation(-.pi / 2)
        
        assertEqual(sut.r0, ( 0, 0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r1, ( 0, 1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (-1, 0, 0, 0), accuracy: accuracy)
        assertEqual(sut.r3, ( 0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeZRotation() {
        let sut = Matrix.makeZRotation(.pi / 3)
        
        assertEqual(sut.r0, ( 0.5000000000000001, 0.8660254037844386, 0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-0.8660254037844386, 0.5000000000000001, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeZRotation_halfPi() {
        let sut = Matrix.makeZRotation(.pi / 2)
        
        assertEqual(sut.r0, ( 0, 1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-1, 0, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, ( 0, 0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r3, ( 0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeZRotation_minusHalfPi() {
        let sut = Matrix.makeZRotation(-.pi / 2)
        
        assertEqual(sut.r0, (0, -1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r1, (1,  0, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0,  0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r3, (0,  0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeTranslationXYZ() {
        let sut = Matrix.makeTranslation(x: 1, y: 2, z: 3)
        
        assertEqual(sut.r0, (1, 0, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 0, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1, 3), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testMakeTranslationVector() {
        let vec = Vector3D(x: 1, y: 2, z: 3)
        let sut = Matrix.makeTranslation(vec)
        
        assertEqual(sut.r0, (1, 0, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 0, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1, 3), accuracy: accuracy)
        assertEqual(sut.r3, (0, 0, 0, 1), accuracy: accuracy)
    }
    
    func testAddition() {
        let lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        let result = lhs + rhs
        
        assertEqual(result.r0, (16, 18, 20, 22))
        assertEqual(result.r1, (24, 26, 28, 30))
        assertEqual(result.r2, (32, 34, 36, 38))
        assertEqual(result.r3, (40, 42, 44, 46))
    }
    
    func testAddition_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        lhs += rhs
        
        assertEqual(lhs.r0, (16, 18, 20, 22))
        assertEqual(lhs.r1, (24, 26, 28, 30))
        assertEqual(lhs.r2, (32, 34, 36, 38))
        assertEqual(lhs.r3, (40, 42, 44, 46))
    }
    
    func testSubtraction() {
        let lhs =
        Matrix(rows: (
            ( 8, 10,  9, 11),
            ( 4,  6,  5,  7),
            (12, 14, 13, 15),
            ( 0,  2,  1,  3)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        let result = lhs - rhs
        
        assertEqual(result.r0, ( -8,  -7,  -9,  -8))
        assertEqual(result.r1, (-16, -15, -17, -16))
        assertEqual(result.r2, (-12, -11, -13, -12))
        assertEqual(result.r3, (-28, -27, -29, -28))
    }
    
    func testSubtraction_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 8, 10,  9, 11),
            ( 4,  6,  5,  7),
            (12, 14, 13, 15),
            ( 0,  2,  1,  3)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        lhs -= rhs
        
        assertEqual(lhs.r0, ( -8,  -7,  -9,  -8))
        assertEqual(lhs.r1, (-16, -15, -17, -16))
        assertEqual(lhs.r2, (-12, -11, -13, -12))
        assertEqual(lhs.r3, (-28, -27, -29, -28))
    }
    
    func testNegate() {
        let lhs =
        Matrix(rows: (
            (-0,  1,   2,   3),
            (-4,  5,  -6,   7),
            ( 8, -9,  10, -11),
            (12, 13, -14,  15)
        ))
        
        let result = -lhs
        
        assertEqual(result.r0, (  0,  -1,  -2,  -3))
        assertEqual(result.r1, (  4,  -5,   6,  -7))
        assertEqual(result.r2, ( -8,   9, -10,  11))
        assertEqual(result.r3, (-12, -13,  14, -15))
    }
    
    func testMultiplication_withScalar() {
        let lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        let result = lhs * 2
        
        assertEqual(result.r0, ( 0,  2,  4,  6))
        assertEqual(result.r1, ( 8, 10, 12, 14))
        assertEqual(result.r2, (16, 18, 20, 22))
        assertEqual(result.r3, (24, 26, 28, 30))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        
        lhs *= 2
        
        assertEqual(lhs.r0, ( 0,  2,  4,  6))
        assertEqual(lhs.r1, ( 8, 10, 12, 14))
        assertEqual(lhs.r2, (16, 18, 20, 22))
        assertEqual(lhs.r3, (24, 26, 28, 30))
    }
    
    func testDivision_withScalar() {
        let lhs =
        Matrix(rows: (
            ( 0,  2,  4,  6),
            ( 8, 10, 12, 14),
            (16, 18, 20, 22),
            (24, 26, 28, 30)
        ))
        
        let result = lhs / 2
        
        assertEqual(result.r0, ( 0,  1,  2,  3))
        assertEqual(result.r1, ( 4,  5,  6,  7))
        assertEqual(result.r2, ( 8,  9, 10, 11))
        assertEqual(result.r3, (12, 13, 14, 15))
    }
    
    func testDivision_withScalar_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 0,  2,  4,  6),
            ( 8, 10, 12, 14),
            (16, 18, 20, 22),
            (24, 26, 28, 30)
        ))
        
        lhs /= 2
        
        assertEqual(lhs.r0, ( 0,  1,  2,  3))
        assertEqual(lhs.r1, ( 4,  5,  6,  7))
        assertEqual(lhs.r2, ( 8,  9, 10, 11))
        assertEqual(lhs.r3, (12, 13, 14, 15))
    }
    
    func testMultiply() {
        let lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        let result = lhs * rhs
        
        assertEqual(result.r0, ( 152.0,  158.0,  164.0,  170.0))
        assertEqual(result.r1, ( 504.0,  526.0,  548.0,  570.0))
        assertEqual(result.r2, ( 856.0,  894.0,  932.0,  970.0))
        assertEqual(result.r3, (1208.0, 1262.0, 1316.0, 1370.0))
    }
    
    func testMultiply_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 0,  1,  2,  3),
            ( 4,  5,  6,  7),
            ( 8,  9, 10, 11),
            (12, 13, 14, 15)
        ))
        let rhs =
        Matrix(rows: (
            (16, 17, 18, 19),
            (20, 21, 22, 23),
            (24, 25, 26, 27),
            (28, 29, 30, 31)
        ))
        
        lhs *= rhs
        
        assertEqual(lhs.r0, ( 152.0,  158.0,  164.0,  170.0))
        assertEqual(lhs.r1, ( 504.0,  526.0,  548.0,  570.0))
        assertEqual(lhs.r2, ( 856.0,  894.0,  932.0,  970.0))
        assertEqual(lhs.r3, (1208.0, 1262.0, 1316.0, 1370.0))
    }
}
