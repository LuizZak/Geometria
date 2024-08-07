#if ENABLE_SIMD
#if canImport(simd)

import XCTest
import Geometria
import TestCommons

class SIMD2_DoubleTests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = SIMD2<Double>
    
    func testInitRepeating() {
        let result = Vector(repeating: 1.0)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 1)
    }
    
    func testMinimalComponentIndex() {
        XCTAssertEqual(Vector(x: -1, y: 2).minimalComponentIndex, 0)
        XCTAssertEqual(Vector(x: 1, y: -2).minimalComponentIndex, 1)
    }
    
    func testMinimalComponentIndex_equalXY() {
        XCTAssertEqual(Vector(x: 1, y: 1).minimalComponentIndex, 1)
    }
    
    func testMaximalComponentIndex() {
        XCTAssertEqual(Vector(x: -1, y: 2).maximalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 1, y: -2).maximalComponentIndex, 0)
    }
    
    func testMaximalComponentIndex_equalXY() {
        XCTAssertEqual(Vector(x: 1, y: 1).maximalComponentIndex, 1)
    }
    
    func testMinimalComponent() {
        XCTAssertEqual(Vector(x: -1, y: 2).minimalComponent, -1)
        XCTAssertEqual(Vector(x: 1, y: -2).minimalComponent, -2)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(Vector(x: -1, y: 2).maximalComponent, 2)
        XCTAssertEqual(Vector(x: 1, y: -2).maximalComponent, 1)
    }
    
    func testEquatable() {
        XCTAssertEqual(Vector(x: 0, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 0), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 0, y: 0), Vector(x: 0, y: 1))
    }
    
    func testHashable() {
        XCTAssertEqual(Vector(x: 0, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 0, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
    }
    
    func testPointwiseMin() {
        let vec1 = Vector(x: 2, y: -3)
        let vec2 = Vector(x: -1, y: 4)
        
        XCTAssertEqual(Vector.pointwiseMin(vec1, vec2), Vector(x: -1, y: -3))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector(x: 2, y: -3)
        let vec2 = Vector(x: -1, y: 4)
        
        XCTAssertEqual(Vector.pointwiseMax(vec1, vec2), Vector(x: 2, y: 4))
    }
    
    func testGreaterThan() {
        XCTAssertTrue(Vector(x: 1, y: 1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: -1) > Vector(x: 0, y: 0))
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(Vector(x: 1, y: 1) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 1) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 1, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: -1) >= Vector(x: 0, y: 0))
    }
    
    func testLessThan() {
        XCTAssertFalse(Vector(x: 1, y: 1) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) < Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: -1) < Vector(x: 0, y: 0))
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(Vector(x: 1, y: 1) <= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) <= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: -1) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: -1) <= Vector(x: 0, y: 0))
    }
    
    func testLengthSquared() {
        XCTAssertEqual(Vector(x: 3, y: 2).lengthSquared, 13)
        XCTAssertEqual(Vector(x: 3.0, y: 2.0).lengthSquared, 13.0)
    }
    
    func testDistanceSquared() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.distanceSquared(to: v2), 800)
    }
    
    func testDistanceSquared_zeroDistance() {
        let vec = Vector(x: 10, y: 20)
        
        XCTAssertEqual(vec.distanceSquared(to: vec), 0.0)
    }
    
    func testDot() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.dot(v2), 1100)
    }
    
    func testCross() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.cross(v2), -200)
    }
    
    func testPerpendicular() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.perpendicular(), Vector(x: -1, y: 5))
    }
    
    func testFormPerpendicular() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formPerpendicular()
        
        XCTAssertEqual(vec, Vector(x: -1, y: 5))
    }
    
    func testLeftRotated() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.leftRotated(), Vector(x: -1, y: 5))
    }
    
    func testFormLeftRotated() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formLeftRotated()
        
        XCTAssertEqual(vec, Vector(x: -1, y: 5))
    }
    
    func testRightRotated() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.rightRotated(), Vector(x: 1, y: -5))
    }
    
    func testFormRightRotated() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formRightRotated()
        
        XCTAssertEqual(vec, Vector(x: 1, y: -5))
    }
    
    func testNegate() {
        XCTAssertEqual(-Vector(x: 1, y: 2), Vector(x: -1, y: -2))
    }
    
    func testNegate_doubleNegateEqualsIdentity() {
        let vec = Vector(x: 1, y: 2)
        
        XCTAssertEqual(-(-vec), vec)
    }
    
    func testAddingProduct() {
        let a = Vector(x: 0.5, y: 0.6)
        let b = Vector(x: 1, y: 2)
        let c = Vector(x: 3, y: 5)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 3.5)
        XCTAssertEqual(result.y, 10.6)
    }
    
    func testAddingProductScalarVector() {
        let a = Vector(x: 0.5, y: 0.6)
        let b = 2.0
        let c = Vector(x: 3, y: 5)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 6.5)
        XCTAssertEqual(result.y, 10.6)
    }
    
    func testAddingProductVectorScalar() {
        let a = Vector(x: 0.5, y: 0.6)
        let b = Vector(x: 1, y: 2)
        let c = 2.0
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 4.6)
    }
    
    func testRoundedWithRoundingRule() {
        let vec = Vector(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(.up), Vector(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.down), Vector(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.toNearestOrAwayFromZero), Vector(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.toNearestOrEven), Vector(x: 0, y: 2))
        XCTAssertEqual(vec.rounded(.towardZero), Vector(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.awayFromZero), Vector(x: 1, y: 2))
    }
    
    func testRounded() {
        let vec = Vector(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(), Vector(x: 1, y: 2))
    }
    
    func testModuloOperator_vector() {
        let vec = Vector(x: 3, y: 10)
        let mod = Vector(x: 4, y: 3)
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
    }
    
    func testModuloOperator_scalar() {
        let vec = Vector(x: 3, y: 10)
        let mod = 4.0
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 2)
    }
    
    func testFloatingPointInitWithBinaryInteger() {
        let vecInt = Vector2<Int>(x: 1, y: 2)
        
        let vec = Vector(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
    }
    
    // Ensure the original overloaded init from simd module still works without
    // ambiguities
    func testFloatingPointInitWithBinaryInteger_simd() {
        let vecInt = SIMD2<Int>(x: 1, y: 2)
        
        let vec = SIMD2<Double>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
    }
    
    func testAngle() {
        let vec = Vector(x: -10, y: 10)
        
        XCTAssertEqual(vec.angle, .pi * (3.0 / 4.0))
    }
    
    func testLength() {
        XCTAssertEqual(Vector(x: 3, y: 2).length, 3.605551275463989)
    }
    
    func testPowFactor_double() {
        let vec = Vector(x: 2, y: 3)
        
        let result = Vector.pow(vec, 5.0)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 243)
    }
    
    func testPowFactor_double_negativeBase() {
        let vec = Vector(x: -1, y: -2)
        
        let result = Vector.pow(vec, 3.0)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
    }
    
    func testPowFactor_integer() {
        let vec = Vector(x: 2, y: 3)
        
        let result = Vector.pow(vec, 5)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 243)
    }
    
    func testPowFactor_integer_negativeBase() {
        let vec = Vector(x: -1, y: -2)
        
        let result = Vector.pow(vec, 3)
        
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, -8)
    }
    
    func testPowVector() {
        let vec = Vector(x: 2, y: 3)
        let power = Vector(x: 5, y: 6)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 729)
    }
    
    func testPowVector_negativeBase() {
        let vec = Vector(x: -2, y: -3)
        let power = Vector(x: 5, y: 6)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
    }
    
    func testRotatedBy() {
        let vec = Vector(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2)
        
        XCTAssertEqual(result.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotateBy() {
        var vec = Vector(x: 5, y: 0)
        
        vec.rotate(by: .pi / 2)
        
        XCTAssertEqual(vec.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(vec.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotatedByAround() {
        let vec = Vector(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2, around: Vector(x: 5, y: 5))
        
        XCTAssertEqual(result.x, 10, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testDistanceTo() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.distance(to: v2), 28.284271247461902, accuracy: accuracy)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector(x: 10, y: 20)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testNormalize() {
        var vec = Vector(x: -10, y: 20)
        
        vec.normalize()
        
        assertEqual(
            vec,
            Vector(x: -0.4472135954999579, y: 0.8944271909999159),
            accuracy: accuracy
        )
    }
    
    func testNormalize_zero() {
        var vec = Vector(x: 0, y: 0)
        
        vec.normalize()
        
        XCTAssertEqual(vec, .zero)
    }
    
    func testNormalized() {
        let vec = Vector(x: -10, y: 20)
        
        assertEqual(
            vec.normalized(),
            Vector(x: -0.4472135954999579, y: 0.8944271909999159),
            accuracy: accuracy
        )
    }
    
    func testNormalized_zero() {
        let vec = Vector(x: 0, y: 0)
        
        XCTAssertEqual(vec.normalized(), .zero)
    }
    
    func testMatrix_identity() {
        let matrix = Vector.matrix()
        
        assertEqual(matrix.column1, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_translate() {
        let matrix = Vector.matrix(translate: Vector(x: 10, y: -20))
        
        assertEqual(matrix.column1, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scale() {
        let matrix = Vector.matrix(scale: Vector(x: 10, y: -20))
        
        assertEqual(matrix.column1, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -20.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotate() {
        let matrix = Vector.matrix(rotate: .pi)
        
        assertEqual(matrix.column1, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0, -1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_scalePrecedesRotation() {
        let matrix = Vector.matrix(
            scale: Vector(x: 0.5, y: 0.75),
            rotate: .pi
        )
        
        assertEqual(matrix.column1, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotationPrecedesTranslation() {
        let matrix = Vector.matrix(
            rotate: .pi,
            translate: Vector(x: 10, y: -20)
        )
        
        assertEqual(matrix.column1, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scaleRotateTranslate() {
        let matrix = Vector.matrix(
            scale: Vector(x: 0.5, y: 0.75),
            rotate: .pi,
            translate: Vector(x: 10, y: -20)
        )
        
        assertEqual(matrix.column1, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, -20.0], accuracy: accuracy)
    }
    
    func testMultiplyMatrix() {
        let matrix = Matrix3x2D(m11: 2, m12: 3, m21: 4, m22: 5, m31: 6, m32: 7)
        let vec = Vector(x: 1, y: 2)
        
        assertEqual(vec * matrix, Vector(x: 16.0, y: 20.0), accuracy: accuracy)
    }
    
    func testMultiplyMatrix_inPlace() {
        let matrix = Matrix3x2D.translation(x: 10, y: 20)
        var vec = Vector(x: 1, y: 2)
        
        vec *= matrix
        
        XCTAssertEqual(vec, Vector(x: 11.0, y: 22.0))
    }
    
    func testAverageVector() {
        let list = [
            Vector(x: -1, y: -1),
            Vector(x: 0, y: 0),
            Vector(x: 10, y: 7)
        ]
        
        XCTAssertEqual(list.averageVector(), Vector(x: 3, y: 2))
    }
    
    func testAverageVector_emptyCollection() {
        let list: [Vector] = []
        
        XCTAssertEqual(list.averageVector(), Vector.zero)
    }
    
    func testFloor() {
        let vec = Vector(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.floor(), Vector(x: 0, y: 1))
    }
    
    func testCeil() {
        let vec = Vector(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.ceil(), Vector(x: 1, y: 2))
    }
    
    func testAbsolute() {
        let vec = Vector(x: -1, y: -2)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector(x: -1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2))
    }
    
    func testAbsolute_positive() {
        let vec = Vector(x: 1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2))
    }
    
    func testSign() {
        XCTAssertEqual(Vector(x: 0.0, y: 0.0).sign, .init(x: 0.0, y: 0.0))
        XCTAssertEqual(Vector(x: -0.0, y: -0.0).sign, .init(x: 0.0, y: 0.0))
        XCTAssertEqual(Vector(x: -1.0, y: 1.0).sign, .init(x: -1.0, y: 1.0))
        XCTAssertEqual(Vector(x: 5.0, y: -4.0).sign, .init(x: 1.0, y: -1.0))
    }
    
    func testSignedDistanceTo() {
        let vec = Vector(x: -2, y: 3)
        
        XCTAssertEqual(vec.signedDistance(to: vec), 0.0)
        XCTAssertEqual(vec.signedDistance(to: .init(x: 2, y: 5)), 4.47213595499958)
    }
}

#endif // #if canImport(simd)
#endif // #if ENABLE_SIMD
