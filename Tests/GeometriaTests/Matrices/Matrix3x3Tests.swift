import XCTest
@testable import Geometria
import TestCommons

class Matrix3x3Tests: XCTestCase {
    let accuracy: Double = 1e-16
    
    typealias Matrix = Matrix3x3<Double>
    
    func testIdentity() {
        let sut = Matrix.identity
        
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
    
    func testRowColumnCount() {
        let sut = Matrix()
        
        XCTAssertEqual(sut.rowCount, 3)
        XCTAssertEqual(sut.columnCount, 3)
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
    
    func testTrace() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        XCTAssertEqual(sut.trace, 12)
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
    
    func testInitWithVectorRows() {
        let sut =
        Matrix(rows: (
            Vector3D(x: 0, y: 1, z: 2),
            Vector3D(x: 3, y: 4, z: 5),
            Vector3D(x: 6, y: 7, z: 8)
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
    
    func testInitWithDiagonal() {
        let sut = Matrix(diagonal: (1, 2, 3))
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 3))
    }
    
    func testInitWithScalarDiagonal() {
        let sut = Matrix(diagonal: 2)
        
        assertEqual(sut.r0, (2, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 2))
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
    
    func testTransformPoint_vector3() {
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
    
    func testTransformPoint_vector2() {
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
    
    func testTransformPoint_vector2_translate() {
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
    
    func testTransformVector_vector2() {
        let sut =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let vec = Vector2D(x: 0, y: 1)
        
        let result = sut.transformVector(vec)
        
        XCTAssertEqual(result.x, 3.0)
        XCTAssertEqual(result.y, 9.0)
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
    
    func testInverted() throws {
        let sut =
        Matrix(rows: (
            ( 1, 2, 1),
            (-7, 2, 4),
            ( 5, 0, 3)
        ))
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, (0.07692307692307692, -0.07692307692307692,  0.07692307692307692), accuracy: accuracy)
        assertEqual(result.r1, (0.52564102564102562, -0.02564102564102564, -0.14102564102564102), accuracy: accuracy)
        assertEqual(result.r2, (-0.1282051282051282,  0.1282051282051282,   0.20512820512820512), accuracy: accuracy)
    }
    
    func testInverted_identity_returnsIdentity() throws {
        let sut = Matrix.identity
        
        let result = try XCTUnwrap(sut.inverted())
        
        assertEqual(result.r0, Matrix.identity.r0, accuracy: accuracy)
        assertEqual(result.r1, Matrix.identity.r1, accuracy: accuracy)
        assertEqual(result.r2, Matrix.identity.r2, accuracy: accuracy)
    }
    
    func testInverted_0DeterminantMatrix_returnsNil() {
        let sut =
        Matrix(rows: (
            (1, 2, 3),
            (4, 5, 6),
            (7, 8, 9)
        ))
        
        XCTAssertNil(sut.inverted())
    }
    
    func testMake2DScaleXY() {
        let sut = Matrix.make2DScale(x: 1, y: 2)
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testMake2DScaleVector() {
        let vec = Vector2D(x: 1, y: 2)
        let sut = Matrix.make2DScale(vec)
        
        assertEqual(sut.r0, (1, 0, 0))
        assertEqual(sut.r1, (0, 2, 0))
        assertEqual(sut.r2, (0, 0, 1))
    }
    
    func testMake2DRotation() {
        let sut = Matrix.make2DRotation(.pi / 3)
        
        assertEqual(sut.r0, ( 0.5000000000000001, 0.8660254037844386, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-0.8660254037844386, 0.5000000000000001, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func testMake2DRotation_halfPi() {
        let sut = Matrix.make2DRotation(.pi / 2)
        
        assertEqual(sut.r0, ( 0, 1, 0), accuracy: accuracy)
        assertEqual(sut.r1, (-1, 0, 0), accuracy: accuracy)
        assertEqual(sut.r2, ( 0, 0, 1), accuracy: accuracy)
    }
    
    func testMake2DRotation_minusHalfPi() {
        let sut = Matrix.make2DRotation(-.pi / 2)
        
        assertEqual(sut.r0, (0, -1, 0), accuracy: accuracy)
        assertEqual(sut.r1, (1,  0, 0), accuracy: accuracy)
        assertEqual(sut.r2, (0,  0, 1), accuracy: accuracy)
    }
    
    func testMake2DTranslationXYZ() {
        let sut = Matrix.make2DTranslation(x: 1, y: 2)
        
        assertEqual(sut.r0, (1, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func testMake2DTranslationVector() {
        let vec = Vector2D(x: 1, y: 2)
        
        let sut = Matrix.make2DTranslation(vec)
        
        assertEqual(sut.r0, (1, 0, 1), accuracy: accuracy)
        assertEqual(sut.r1, (0, 1, 2), accuracy: accuracy)
        assertEqual(sut.r2, (0, 0, 1), accuracy: accuracy)
    }
    
    func test3DMakeSkewSymmetricCrossProduct_rightHanded() {
        let a = Vector3D(x: 1, y: 2, z: 3)

        let sut = Matrix.make3DSkewSymmetricCrossProduct(a, orientation: .rightHanded)

        assertEqual(sut.r0, ( 0, -3,  2), accuracy: accuracy)
        assertEqual(sut.r1, ( 3,  0, -1), accuracy: accuracy)
        assertEqual(sut.r2, (-2,  1,  0), accuracy: accuracy)
    }
    
    func test3DMakeSkewSymmetricCrossProduct_leftHanded() {
        let a = Vector3D(x: 1, y: 2, z: 3)

        let sut = Matrix.make3DSkewSymmetricCrossProduct(a, orientation: .leftHanded)

        assertEqual(sut.r0, ( 0,  3, -2), accuracy: accuracy)
        assertEqual(sut.r1, (-3,  0,  1), accuracy: accuracy)
        assertEqual(sut.r2, ( 2, -1,  0), accuracy: accuracy)
    }
    
    func test3DMakeSkewSymmetricCrossProduct_multiplyingProducesCrossProduct_rightHanded() {
        let a = Vector3D(x: 1, y: 0, z: 0)
        let b = Vector3D(x: 0, y: 1, z: 0)
        let cross = a.cross(b)
        let sut = Matrix.make3DSkewSymmetricCrossProduct(a, orientation: .rightHanded)

        let result = sut.transformPoint(b)

        XCTAssertEqual(result.x, cross.x)
        XCTAssertEqual(result.y, cross.y)
        XCTAssertEqual(result.z, cross.z)
    }
    
    func test3DMakeSkewSymmetricCrossProduct_multiplyingProducesCrossProduct_leftHanded() {
        let a = Vector3D(x: 1, y: 0, z: 0)
        let b = Vector3D(x: 0, y: 1, z: 0)
        let cross = -a.cross(b)
        let sut = Matrix.make3DSkewSymmetricCrossProduct(a, orientation: .leftHanded)

        let result = sut.transformPoint(b)

        XCTAssertEqual(result.x, cross.x)
        XCTAssertEqual(result.y, cross.y)
        XCTAssertEqual(result.z, cross.z)
    }

    func testAddition() {
        let lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let rhs =
        Matrix(rows: (
            ( 9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        let result = lhs + rhs
        
        assertEqual(result.r0, ( 9, 11, 13))
        assertEqual(result.r1, (15, 17, 19))
        assertEqual(result.r2, (21, 23, 25))
    }
    
    func testAddition_inPlace() {
        var lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        let rhs =
        Matrix(rows: (
            ( 9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        lhs += rhs
        
        assertEqual(lhs.r0, ( 9, 11, 13))
        assertEqual(lhs.r1, (15, 17, 19))
        assertEqual(lhs.r2, (21, 23, 25))
    }
    
    func testSubtraction() {
        let lhs =
        Matrix(rows: (
            (3, 5, 4),
            (0, 2, 1),
            (6, 8, 7)
        ))
        let rhs =
        Matrix(rows: (
            ( 9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        let result = lhs - rhs
        
        assertEqual(result.r0, ( -6,  -5,  -7))
        assertEqual(result.r1, (-12, -11, -13))
        assertEqual(result.r2, ( -9,  -8, -10))
    }
    
    func testSubtraction_inPlace() {
        var lhs =
        Matrix(rows: (
            (3, 5, 4),
            (0, 2, 1),
            (6, 8, 7)
        ))
        let rhs =
        Matrix(rows: (
            ( 9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        lhs -= rhs
        
        assertEqual(lhs.r0, ( -6,  -5,  -7))
        assertEqual(lhs.r1, (-12, -11, -13))
        assertEqual(lhs.r2, ( -9,  -8, -10))
    }
    
    func testNegate() {
        let lhs =
        Matrix(rows: (
            (-0,  1,   2),
            (-4,  5,  -6),
            ( 8, -9,  10)
        ))
        
        let result = -lhs
        
        assertEqual(result.r0, (  0,  -1,  -2))
        assertEqual(result.r1, (  4,  -5,   6))
        assertEqual(result.r2, ( -8,   9, -10))
    }
    
    func testMultiplication_withScalar() {
        let lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        let result = lhs * 2
        
        assertEqual(result.r0, ( 0,  2,  4))
        assertEqual(result.r1, ( 6,  8, 10))
        assertEqual(result.r2, (12, 14, 16))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var lhs =
        Matrix(rows: (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8)
        ))
        
        lhs *= 2
        
        assertEqual(lhs.r0, ( 0,  2,  4))
        assertEqual(lhs.r1, ( 6,  8, 10))
        assertEqual(lhs.r2, (12, 14, 16))
    }
    
    func testDivision_withScalar() {
        let lhs =
        Matrix(rows: (
            ( 0,  2,  4),
            ( 6,  8, 10),
            (12, 14, 16)
        ))
        
        let result = lhs / 2
        
        assertEqual(result.r0, (0, 1, 2))
        assertEqual(result.r1, (3, 4, 5))
        assertEqual(result.r2, (6, 7, 8))
    }
    
    func testDivision_withScalar_inPlace() {
        var lhs =
        Matrix(rows: (
            ( 0,  2,  4),
            ( 6,  8, 10),
            (12, 14, 16)
        ))
        
        lhs /= 2
        
        assertEqual(lhs.r0, (0, 1, 2))
        assertEqual(lhs.r1, (3, 4, 5))
        assertEqual(lhs.r2, (6, 7, 8))
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
            ( 9, 10, 11),
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
            ( 9, 10, 11),
            (12, 13, 14),
            (15, 16, 17)
        ))
        
        lhs *= rhs
        
        assertEqual(lhs.r0, ( 42.0,  45.0,  48.0))
        assertEqual(lhs.r1, (150.0, 162.0, 174.0))
        assertEqual(lhs.r2, (258.0, 279.0, 300.0))
    }
}
