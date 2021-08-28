import XCTest
import Geometria

class Matrix2Tests: XCTestCase {
    typealias Matrix = Matrix2D
    
    func testIdentity() {
        XCTAssertEqual(Matrix.identity.m11, 1)
        XCTAssertEqual(Matrix.identity.m12, 0)
        XCTAssertEqual(Matrix.identity.m21, 0)
        XCTAssertEqual(Matrix.identity.m22, 1)
        XCTAssertEqual(Matrix.identity.m31, 0)
        XCTAssertEqual(Matrix.identity.m32, 0)
    }
    
    func testRow1() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.row1, [1, 2])
    }
    
    func testRow2() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.row2, [3, 4])
    }
    
    func testRow3() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.row3, [5, 6])
    }
    
    func testColumn1() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.column1, [1, 3, 5])
    }
    
    func testColumn2() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.column2, [2, 4, 6])
    }
    
    func testTranslationVector() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.translationVector, .init(x: 5, y: 6))
    }
    
    func testScaleVector() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.scaleVector, .init(x: 1, y: 4))
    }
    
    func testIsIdentity() {
        let sut = makeSut()
        
        XCTAssertFalse(sut.isIdentity)
        XCTAssertTrue(Matrix.identity.isIdentity)
    }
    
    func testSubscriptIndex() {
        let sut = makeSut()
        
        XCTAssertEqual(sut[index: 0], sut.m11)
        XCTAssertEqual(sut[index: 1], sut.m12)
        XCTAssertEqual(sut[index: 2], sut.m21)
        XCTAssertEqual(sut[index: 3], sut.m22)
        XCTAssertEqual(sut[index: 4], sut.m31)
        XCTAssertEqual(sut[index: 5], sut.m32)
    }
    
    func testSubscriptRowColumn() {
        let sut = makeSut()
        
        XCTAssertEqual(sut[row: 0, column: 0], sut.m11)
        XCTAssertEqual(sut[row: 0, column: 1], sut.m12)
        XCTAssertEqual(sut[row: 1, column: 0], sut.m21)
        XCTAssertEqual(sut[row: 1, column: 1], sut.m22)
        XCTAssertEqual(sut[row: 2, column: 0], sut.m31)
        XCTAssertEqual(sut[row: 2, column: 1], sut.m32)
    }
    
    func testDescription() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.description,
                       "[M11:1.0 M12:2.0] [M21:3.0 M22:4.0] [M31:5.0 M32:6.0]")
    }
    
    func testInitWithValue() {
        let sut = Matrix(value: 1)
        
        XCTAssertEqual(sut.m11, 1)
        XCTAssertEqual(sut.m12, 1)
        XCTAssertEqual(sut.m21, 1)
        XCTAssertEqual(sut.m22, 1)
        XCTAssertEqual(sut.m31, 1)
        XCTAssertEqual(sut.m32, 1)
    }
    
    func testInitWithValues() {
        let sut = Matrix(values: [
            1, 2,
            3, 4,
            5, 6
        ])
        
        XCTAssertEqual(sut.m11, 1)
        XCTAssertEqual(sut.m12, 2)
        XCTAssertEqual(sut.m21, 3)
        XCTAssertEqual(sut.m22, 4)
        XCTAssertEqual(sut.m31, 5)
        XCTAssertEqual(sut.m32, 6)
    }
    
    func testToArray() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.toArray(), [1, 2, 3, 4, 5, 6])
    }
    
    func testDeterminant() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.determinant(), -2)
    }
    
    func testInverted() {
        let result = makeSut().inverted()
        
        XCTAssertEqual(result.m11, -2)
        XCTAssertEqual(result.m12, 1)
        XCTAssertEqual(result.m21, 1.5)
        XCTAssertEqual(result.m22, -0.5)
        XCTAssertEqual(result.m31, 1)
        XCTAssertEqual(result.m32, -2)
    }
    
    func testAdd() {
        let result = Matrix.add(makeSut(), makeSut())
        
        XCTAssertEqual(result.m11, 2)
        XCTAssertEqual(result.m12, 4)
        XCTAssertEqual(result.m21, 6)
        XCTAssertEqual(result.m22, 8)
        XCTAssertEqual(result.m31, 10)
        XCTAssertEqual(result.m32, 12)
    }
    
    func testSubtract() {
        let result = Matrix.subtract(makeSut(), makeSut())
        
        XCTAssertEqual(result.m11, 0)
        XCTAssertEqual(result.m12, 0)
        XCTAssertEqual(result.m21, 0)
        XCTAssertEqual(result.m22, 0)
        XCTAssertEqual(result.m31, 0)
        XCTAssertEqual(result.m32, 0)
    }
    
    func testMultiplyScalar() {
        let result = Matrix.multiply(makeSut(), 3)
        
        XCTAssertEqual(result.m11, 3)
        XCTAssertEqual(result.m12, 6)
        XCTAssertEqual(result.m21, 9)
        XCTAssertEqual(result.m22, 12)
        XCTAssertEqual(result.m31, 15)
        XCTAssertEqual(result.m32, 18)
    }
    
    func testMultiplyMatrix() {
        let result = Matrix.multiply(makeSut(), makeSut())
        
        XCTAssertEqual(result.m11, 7)
        XCTAssertEqual(result.m12, 10)
        XCTAssertEqual(result.m21, 15)
        XCTAssertEqual(result.m22, 22)
        XCTAssertEqual(result.m31, 28)
        XCTAssertEqual(result.m32, 40)
    }
    
    func testDivideScalar() {
        let result = Matrix.divide(makeSut(), 3)
        
        XCTAssertEqual(result.m11, 0.3333333333333333, accuracy: 1e-15)
        XCTAssertEqual(result.m12, 0.6666666666666666, accuracy: 1e-15)
        XCTAssertEqual(result.m21, 1.0, accuracy: 1e-15)
        XCTAssertEqual(result.m22, 1.3333333333333333, accuracy: 1e-15)
        XCTAssertEqual(result.m31, 1.6666666666666665, accuracy: 1e-15)
        XCTAssertEqual(result.m32, 2.0, accuracy: 1e-15)
    }
    
    func testDivideMatrix() {
        let result = Matrix.divide(makeSut(), makeSut())
        
        XCTAssertEqual(result.m11, 1)
        XCTAssertEqual(result.m12, 1)
        XCTAssertEqual(result.m21, 1)
        XCTAssertEqual(result.m22, 1)
        XCTAssertEqual(result.m31, 1)
        XCTAssertEqual(result.m32, 1)
    }
    
    func testNegate() {
        let result = Matrix.negate(makeSut())
        
        XCTAssertEqual(result.m11, -1)
        XCTAssertEqual(result.m12, -2)
        XCTAssertEqual(result.m21, -3)
        XCTAssertEqual(result.m22, -4)
        XCTAssertEqual(result.m31, -5)
        XCTAssertEqual(result.m32, -6)
    }
    
    func testLerp_0() {
        let start = makeSut()
        let end = makePrimesSut()
        
        let result = Matrix.lerp(start: start, end: end, amount: 0)
        
        XCTAssertEqual(result, start)
    }
    
    func testLerp_1() {
        let start = makeSut()
        let end = makePrimesSut()
        
        let result = Matrix.lerp(start: start, end: end, amount: 1)
        
        XCTAssertEqual(result, end)
    }
    
    func testLerp() {
        let start = makeSut()
        let end = makePrimesSut()
        
        let result = Matrix.lerp(start: start, end: end, amount: 0.5)
        
        XCTAssertEqual(result.m11, 1.5, accuracy: 1e-15)
        XCTAssertEqual(result.m12, 2.5, accuracy: 1e-15)
        XCTAssertEqual(result.m21, 4, accuracy: 1e-15)
        XCTAssertEqual(result.m22, 5.5, accuracy: 1e-15)
        XCTAssertEqual(result.m31, 8, accuracy: 1e-15)
        XCTAssertEqual(result.m32, 9.5, accuracy: 1e-15)
    }
    
    func testLerp_negative() {
        let start = makeSut()
        let end = makePrimesSut()
        
        let result = Matrix.lerp(start: start, end: end, amount: -1)
        
        XCTAssertEqual(result.m11, 0)
        XCTAssertEqual(result.m12, 1)
        XCTAssertEqual(result.m21, 1)
        XCTAssertEqual(result.m22, 1)
        XCTAssertEqual(result.m31, -1)
        XCTAssertEqual(result.m32, -1)
    }
    
    func testLerp_positivePast1() {
        let start = makeSut()
        let end = makePrimesSut()
        
        let result = Matrix.lerp(start: start, end: end, amount: 2)
        
        XCTAssertEqual(result.m11, 3)
        XCTAssertEqual(result.m12, 4)
        XCTAssertEqual(result.m21, 7)
        XCTAssertEqual(result.m22, 10)
        XCTAssertEqual(result.m31, 17)
        XCTAssertEqual(result.m32, 20)
    }
    
    func testScalingVector() {
        let sut = Matrix.scaling(scale: .init(x: 2, y: 3))
        
        XCTAssertEqual(sut.m11, 2)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 3)
        XCTAssertEqual(sut.m31, 0)
        XCTAssertEqual(sut.m32, 0)
    }
    
    func testScalingXY() {
        let sut = Matrix.scaling(x: 2, y: 3)
        
        XCTAssertEqual(sut.m11, 2)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 3)
        XCTAssertEqual(sut.m31, 0)
        XCTAssertEqual(sut.m32, 0)
    }
    
    func testScalingScalar() {
        let sut = Matrix.scaling(scale: 2)
        
        XCTAssertEqual(sut.m11, 2)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 2)
        XCTAssertEqual(sut.m31, 0)
        XCTAssertEqual(sut.m32, 0)
    }
    
    func testScalingXYCenter() {
        let sut = Matrix.scaling(x: 2, y: 3, center: .init(x: 4, y: 5))
        
        XCTAssertEqual(sut.m11, 2)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 3)
        XCTAssertEqual(sut.m31, -4)
        XCTAssertEqual(sut.m32, -10)
    }
    
    func testRotationAngle() {
        let sut = Matrix.rotation(angle: .pi / 2)
        
        XCTAssertEqual(sut.m11, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m12, 1, accuracy: 1e-15)
        XCTAssertEqual(sut.m21, -1, accuracy: 1e-15)
        XCTAssertEqual(sut.m22, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m31, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m32, 0, accuracy: 1e-15)
    }
    
    func testRotationAngleCenter() {
        let sut = Matrix.rotation(angle: .pi / 2, center: .init(x: 2, y: 3))
        
        XCTAssertEqual(sut.m11, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m12, 1, accuracy: 1e-15)
        XCTAssertEqual(sut.m21, -1, accuracy: 1e-15)
        XCTAssertEqual(sut.m22, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m31, 5, accuracy: 1e-15)
        XCTAssertEqual(sut.m32, 1, accuracy: 1e-15)
    }
    
    func testTranslationByVector() {
        let sut = Matrix.translation(.init(x: 2, y: 3))
        
        XCTAssertEqual(sut.m11, 1)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 1)
        XCTAssertEqual(sut.m31, 2)
        XCTAssertEqual(sut.m32, 3)
    }
    
    func testTranslationByXY() {
        let sut = Matrix.translation(x: 2, y: 3)
        
        XCTAssertEqual(sut.m11, 1)
        XCTAssertEqual(sut.m12, 0)
        XCTAssertEqual(sut.m21, 0)
        XCTAssertEqual(sut.m22, 1)
        XCTAssertEqual(sut.m31, 2)
        XCTAssertEqual(sut.m32, 3)
    }
    
    func testTransformation() {
        let sut = Matrix
            .transformation(xScale: 2,
                            yScale: 3,
                            angle: .pi / 2,
                            xOffset: 4,
                            yOffset: 5)
        
        XCTAssertEqual(sut.m11, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m12, 2, accuracy: 1e-15)
        XCTAssertEqual(sut.m21, -3, accuracy: 1e-15)
        XCTAssertEqual(sut.m22, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m31, 4, accuracy: 1e-15)
        XCTAssertEqual(sut.m32, 5, accuracy: 1e-15)
    }
    
    func testTransformPoint() {
        let sut = makeTransformSut()
        
        let result = Matrix.transformPoint(matrix: sut, point: .init(x: 13, y: 17))
        
        XCTAssertEqual(result.x, -47, accuracy: 1e-15)
        XCTAssertEqual(result.y, 31, accuracy: 1e-14)
    }
    
    func testSkew() {
        let sut = Matrix.skew(angleX: .pi / 4, angleY: -.pi / 4)
        
        XCTAssertEqual(sut.m11, 1, accuracy: 1e-15)
        XCTAssertEqual(sut.m12, 1, accuracy: 1e-15)
        XCTAssertEqual(sut.m21, -1, accuracy: 1e-15)
        XCTAssertEqual(sut.m22, 1, accuracy: 1e-15)
        XCTAssertEqual(sut.m31, 0, accuracy: 1e-15)
        XCTAssertEqual(sut.m32, 0, accuracy: 1e-15)
    }
    
    func testInvert() {
        let result = Matrix.invert(makeSut())
        
        XCTAssertEqual(result.m11, -2)
        XCTAssertEqual(result.m12, 1)
        XCTAssertEqual(result.m21, 1.5)
        XCTAssertEqual(result.m22, -0.5)
        XCTAssertEqual(result.m31, 1)
        XCTAssertEqual(result.m32, -2)
    }
    
    func testInvert_zeroDeterminant() {
        let sut = Matrix2(m11: 0, m12: 0, m21: 0, m22: 0, m31: 0, m32: 0)
        
        XCTAssertEqual(sut.inverted(), .identity)
    }
    
    func testAdd_operator() {
        let result = makeSut() + makeSut()
        
        XCTAssertEqual(result.m11, 2)
        XCTAssertEqual(result.m12, 4)
        XCTAssertEqual(result.m21, 6)
        XCTAssertEqual(result.m22, 8)
        XCTAssertEqual(result.m31, 10)
        XCTAssertEqual(result.m32, 12)
    }
    
    func testAssert_operator() {
        let result = +makeSut()
        
        XCTAssertEqual(result.m11, 1)
        XCTAssertEqual(result.m12, 2)
        XCTAssertEqual(result.m21, 3)
        XCTAssertEqual(result.m22, 4)
        XCTAssertEqual(result.m31, 5)
        XCTAssertEqual(result.m32, 6)
    }
    
    func testSubtract_operator() {
        let result = makeSut() - makeSut()
        
        XCTAssertEqual(result.m11, 0)
        XCTAssertEqual(result.m12, 0)
        XCTAssertEqual(result.m21, 0)
        XCTAssertEqual(result.m22, 0)
        XCTAssertEqual(result.m31, 0)
        XCTAssertEqual(result.m32, 0)
    }
    
    func testNegate_operator() {
        let result = -makeSut()
        
        XCTAssertEqual(result.m11, -1)
        XCTAssertEqual(result.m12, -2)
        XCTAssertEqual(result.m21, -3)
        XCTAssertEqual(result.m22, -4)
        XCTAssertEqual(result.m31, -5)
        XCTAssertEqual(result.m32, -6)
    }
    
    func testMultiplyScalar_operator() {
        let result = makeSut() * 3
        
        XCTAssertEqual(result.m11, 3)
        XCTAssertEqual(result.m12, 6)
        XCTAssertEqual(result.m21, 9)
        XCTAssertEqual(result.m22, 12)
        XCTAssertEqual(result.m31, 15)
        XCTAssertEqual(result.m32, 18)
    }
    
    func testMultiplyScalar_operator_reversed() {
        let result = 3 * makeSut()
        
        XCTAssertEqual(result.m11, 3)
        XCTAssertEqual(result.m12, 6)
        XCTAssertEqual(result.m21, 9)
        XCTAssertEqual(result.m22, 12)
        XCTAssertEqual(result.m31, 15)
        XCTAssertEqual(result.m32, 18)
    }
    
    func testMultiplyMatrix_operator() {
        let result = makeSut() * makeSut()
        
        XCTAssertEqual(result.m11, 7)
        XCTAssertEqual(result.m12, 10)
        XCTAssertEqual(result.m21, 15)
        XCTAssertEqual(result.m22, 22)
        XCTAssertEqual(result.m31, 28)
        XCTAssertEqual(result.m32, 40)
    }
    
    func testDivideScalar_operator() {
        let result = makeSut() / 3.0
        
        XCTAssertEqual(result.m11, 0.3333333333333333, accuracy: 1e-15)
        XCTAssertEqual(result.m12, 0.6666666666666666, accuracy: 1e-15)
        XCTAssertEqual(result.m21, 1.0, accuracy: 1e-15)
        XCTAssertEqual(result.m22, 1.3333333333333333, accuracy: 1e-15)
        XCTAssertEqual(result.m31, 1.6666666666666665, accuracy: 1e-15)
        XCTAssertEqual(result.m32, 2.0, accuracy: 1e-15)
    }
    
    func testDivideMatrix_operator() {
        let result = makeSut() / makeSut()
        
        XCTAssertEqual(result.m11, 1)
        XCTAssertEqual(result.m12, 1)
        XCTAssertEqual(result.m21, 1)
        XCTAssertEqual(result.m22, 1)
        XCTAssertEqual(result.m31, 1)
        XCTAssertEqual(result.m32, 1)
    }
    
    func testTransformRect() {
        let sut = makeTransformSut()
        let rect = Rectangle2D(x: 3, y: 4, width: 10, height: 12)
        
        let result = sut.transform(rect)
        
        XCTAssertEqual(result.x, -44, accuracy: 1e-15)
        XCTAssertEqual(result.y, 11, accuracy: 1e-15)
        XCTAssertEqual(result.width, 36, accuracy: 1e-15)
        XCTAssertEqual(result.height, 20, accuracy: 1e-14)
    }
    
    func testTransformPoint_instance() {
        let sut = makeTransformSut()
        
        let result = sut.transform(Vector2D(x: 13, y: 17))
        
        XCTAssertEqual(result.x, -47, accuracy: 1e-15)
        XCTAssertEqual(result.y, 31, accuracy: 1e-14)
    }
    
    func testTransformPoints() {
        let sut = makeTransformSut()
        
        let result = sut.transform(points: [
            Vector2D(x: 13, y: 17),
            Vector2D(x: 3, y: 5),
            Vector2D(x: 15, y: 8)
        ])
        
        assertEqual(result[0], .init(x: -47, y: 31), accuracy: 1e-14)
        assertEqual(result[1], .init(x: -11, y: 11), accuracy: 1e-14)
        assertEqual(result[2], .init(x: -20, y: 35), accuracy: 1e-14)
    }
    
    func testTransformPoints_emptyArray() {
        let sut = makeSut()
        
        let result = sut.transform(points: [Vector2D]())
        
        XCTAssertEqual(result, [])
    }
}

extension Matrix2Tests {
    /// Creates a test `Matrix` with `Matrix(m11: 1, m12: 2, m21: 3, m22: 4, m31: 5, m32: 6)`
    func makeSut() -> Matrix {
        return Matrix(m11: 1, m12: 2, m21: 3, m22: 4, m31: 5, m32: 6)
    }
    
    /// Creates a test `Matrix` with `Matrix(m11: 2, m12: 3, m21: 5, m22: 7, m31: 11, m32: 13)`
    func makePrimesSut() -> Matrix {
        return Matrix(m11: 2, m12: 3, m21: 5, m22: 7, m31: 11, m32: 13)
    }

    /// Creates a test `Matrix` with `Matrix.transformation(xScale: 2, yScale: 3, angle: .pi / 2, xOffset: 4, yOffset: 5)`
    func makeTransformSut() -> Matrix {
        return Matrix
            .transformation(xScale: 2,
                            yScale: 3,
                            angle: .pi / 2,
                            xOffset: 4,
                            yOffset: 5)
    }
}
