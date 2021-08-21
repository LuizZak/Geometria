import XCTest
import Geometria

class Vector2Tests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = Vector2<Int>
    
    func testZero() {
        XCTAssertEqual(Vector.zero.x, 0)
        XCTAssertEqual(Vector.zero.y, 0)
    }
    
    func testUnit() {
        XCTAssertEqual(Vector.one.x, 1)
        XCTAssertEqual(Vector.one.y, 1)
    }
    
    func testDescription() {
        XCTAssertEqual(Vector2<Int>(x: 0, y: 1).description,
                       "Vector2<Int>(x: 0, y: 1)")
        XCTAssertEqual(Vector2<Double>(x: 0, y: 1).description,
                       "Vector2<Double>(x: 0.0, y: 1.0)")
    }
    
    func testInit() {
        let sut = Vector(x: 0, y: 1)
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 1)
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
    
    func testInitZero() {
        let sut = Vector()
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 0)
    }
    
    func testInitXy() {
        let sut = Vector(repeating: 1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testPointwiseMin() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(Vector2i.pointwiseMin(vec1, vec2), Vector2i(x: -1, y: -3))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(Vector2i.pointwiseMax(vec1, vec2), Vector2i(x: 2, y: 4))
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
    
    func testAddition() {
        XCTAssertEqual(Vector(x: 1, y: 2) + Vector(x: 3, y: 4),
                       Vector(x: 4, y: 6))
        XCTAssertEqual(Vector2D(x: 1, y: 2) + Vector2D(x: 3, y: 4),
                       Vector2D(x: 4, y: 6))
        XCTAssertEqual(Vector2F(x: 1, y: 2) + Vector2F(x: 3, y: 4),
                       Vector2F(x: 4, y: 6))
    }
    
    func testAddition_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) + 3,
                       Vector(x: 4, y: 5))
        XCTAssertEqual(Vector2D(x: 1, y: 2) + 3,
                       Vector2D(x: 4, y: 5))
        XCTAssertEqual(Vector2F(x: 1, y: 2) + 3,
                       Vector2F(x: 4, y: 5))
    }
    
    func testSubtraction() {
        XCTAssertEqual(Vector(x: 1, y: 2) - Vector(x: 3, y: 5),
                       Vector(x: -2, y: -3))
        XCTAssertEqual(Vector2D(x: 1, y: 2) - Vector2D(x: 3, y: 5),
                       Vector2D(x: -2, y: -3))
        XCTAssertEqual(Vector2F(x: 1, y: 2) - Vector2F(x: 3, y: 5),
                       Vector2F(x: -2, y: -3))
    }
    
    func testSubtraction_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) - 3,
                       Vector(x: -2, y: -1))
        XCTAssertEqual(Vector2D(x: 1, y: 2) - 3,
                       Vector2D(x: -2, y: -1))
        XCTAssertEqual(Vector2F(x: 1, y: 2) - 3,
                       Vector2F(x: -2, y: -1))
    }
    
    func testMultiplication() {
        XCTAssertEqual(Vector(x: 1, y: 2) * Vector(x: 3, y: 4),
                       Vector(x: 3, y: 8))
        XCTAssertEqual(Vector2D(x: 1, y: 2) * Vector2D(x: 3, y: 4),
                       Vector2D(x: 3, y: 8))
        XCTAssertEqual(Vector2F(x: 1, y: 2) * Vector2F(x: 3, y: 4),
                       Vector2F(x: 3, y: 8))
    }
    
    func testMultiplication_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) * 3,
                       Vector(x: 3, y: 6))
        XCTAssertEqual(Vector2D(x: 1, y: 2) * 3,
                       Vector2D(x: 3, y: 6))
        XCTAssertEqual(Vector2F(x: 1, y: 2) * 3,
                       Vector2F(x: 3, y: 6))
    }
    
    func testDivision() {
        XCTAssertEqual(Vector(x: 3, y: 5) / Vector(x: 2, y: 3),
                       Vector(x: 1, y: 1))
        XCTAssertEqual(Vector2D(x: 3, y: 5) / Vector2D(x: 2, y: 3),
                       Vector2D(x: 1.5, y: 1.6666666666666667))
        XCTAssertEqual(Vector2F(x: 3, y: 5) / Vector2F(x: 2, y: 3),
                       Vector2F(x: 1.5, y: 1.6666666))
    }
    
    func testDivision_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 4) / 3,
                       Vector(x: 0, y: 1))
        XCTAssertEqual(Vector2D(x: 1, y: 2) / 3,
                       Vector2D(x: 0.3333333333333333, y: 0.6666666666666666))
        XCTAssertEqual(Vector2F(x: 1, y: 2) / 3,
                       Vector2F(x: 0.33333334, y: 0.6666667))
    }
    
    func testAddition_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 4)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 4, y: 6))
    }
    
    func testAddition_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 += 1
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 3))
    }
    
    func testSubtraction_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 5)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -2, y: -3))
    }
    
    func testSubtraction_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 -= 1
        
        XCTAssertEqual(vec1, Vector(x: 0, y: 1))
    }
    
    func testMultiplication_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 4)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 3, y: 8))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 *= 2
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 4))
    }
    
    func testDivision_inPlace() {
        var vec1 = Vector(x: 3, y: 5)
        
        vec1 /= Vector(x: 2, y: 3)
        
        XCTAssertEqual(vec1, Vector(x: 1, y: 1))
    }
    
    func testDivision_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 4)
        
        vec1 /= 3
        
        XCTAssertEqual(vec1, Vector(x: 0, y: 1))
    }
    
    func testAddition_floatingPoint_binaryNumber() {
        let vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 + vec1, Vector2D(x: 4, y: 6))
        XCTAssertEqual(vec1 + vec2, Vector2D(x: 4, y: 6))
    }
    
    func testSubtraction_floatingPoint_binaryNumber() {
        let vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 5)
        
        XCTAssertEqual(vec2 - vec1, Vector2D(x: 2, y: 3))
        XCTAssertEqual(vec1 - vec2, Vector2D(x: -2, y: -3))
    }
    
    func testMultiplication_floatingPoint_binaryNumber() {
        let vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 * vec1, Vector2D(x: 3, y: 8))
        XCTAssertEqual(vec1 * vec2, Vector2D(x: 3, y: 8))
    }
    
    func testDivision_floatingPoint_binaryNumber() {
        let vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 / vec1, Vector2D(x: 3, y: 2))
        XCTAssertEqual(vec1 / vec2, Vector2D(x: 0.3333333333333333, y: 0.5))
    }
    
    func testAddition_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector2D(x: 4, y: 6))
    }
    
    func testSubtraction_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 5)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector2D(x: -2, y: -3))
    }
    
    func testMultiplication_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector2D(x: 3, y: 8))
    }
    
    func testDivision_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector2D(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 /= vec2
        
        XCTAssertEqual(vec1, Vector2D(x: 0.3333333333333333, y: 0.5))
    }
    
    func testLengthSquared() {
        XCTAssertEqual(Vector(x: 3, y: 2).lengthSquared, 13)
        XCTAssertEqual(Vector2D(x: 3.0, y: 2.0).lengthSquared, 13.0)
    }
    
    func testDistanceSquared() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.distanceSquared(to: v2), 800)
    }
    
    func testDistanceSquared_zeroDistance() {
        let vec = Vector2D(x: 10, y: 20)
        
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
    
    func testRatio() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(v1.ratio(-1, to: v2), Vector2D(x: -10, y: 0))
        XCTAssertEqual(v1.ratio(0, to: v2), v1)
        XCTAssertEqual(v1.ratio(0.5, to: v2), Vector2D(x: 20, y: 30))
        XCTAssertEqual(v1.ratio(1, to: v2), v2)
        XCTAssertEqual(v1.ratio(2, to: v2), Vector2D(x: 50, y: 60))
    }
    
    func testLerp() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(Vector2D.lerp(start: v1, end: v2, amount: -1), Vector2D(x: -10, y: 0))
        XCTAssertEqual(Vector2D.lerp(start: v1, end: v2, amount: 0), v1)
        XCTAssertEqual(Vector2D.lerp(start: v1, end: v2, amount: 0.5), Vector2D(x: 20, y: 30))
        XCTAssertEqual(Vector2D.lerp(start: v1, end: v2, amount: 1), v2)
        XCTAssertEqual(Vector2D.lerp(start: v1, end: v2, amount: 2), Vector2D(x: 50, y: 60))
    }
    
    func testAbsolute() {
        let vec = Vector2D(x: -1, y: -2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector2D(x: -1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_positive() {
        let vec = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
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
    
    func testNegate_doubleNegateEqualsIdendity() {
        let vec = Vector(x: 1, y: 2)
        
        XCTAssertEqual(-(-vec), vec)
    }
    
    func testFloatingPointInitWithBinaryInteger() {
        let vecInt = Vector2<Int>(x: 1, y: 2)
        
        let vec = Vector2<Float>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
    }
    
    func testRoundedWithRoundingRule() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(.up), Vector2D(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.down), Vector2D(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.toNearestOrAwayFromZero), Vector2D(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.toNearestOrEven), Vector2D(x: 0, y: 2))
        XCTAssertEqual(vec.rounded(.towardZero), Vector2D(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.awayFromZero), Vector2D(x: 1, y: 2))
    }
    
    func testRounded() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(), Vector2D(x: 1, y: 2))
    }
    
    func testFloor() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.floor(), Vector2D(x: 0, y: 1))
    }
    
    func testCeil() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.ceil(), Vector2D(x: 1, y: 2))
    }
    
    func testModulosOperator_vector() {
        let vec = Vector2D(x: 3, y: 10)
        let mod = Vector2D(x: 4, y: 3)
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
    }
    
    func testModulosOperator_scalar() {
        let vec = Vector2D(x: 3, y: 10)
        let mod = 4.0
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 2)
    }
    
    func testAngle() {
        let vec = Vector2D(x: -10, y: 10)
        
        XCTAssertEqual(vec.angle, .pi * (3.0 / 4.0))
    }
    
    func testLength() {
        XCTAssertEqual(Vector2(x: 3, y: 2).length, 3.605551275463989)
    }
    
    func testRotatedBy() {
        let vec = Vector2D(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2)
        
        XCTAssertEqual(result.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotateBy() {
        var vec = Vector2D(x: 5, y: 0)
        
        vec.rotate(by: .pi / 2)
        
        XCTAssertEqual(vec.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(vec.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotatedByAround() {
        let vec = Vector2D(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2, around: Vector2D(x: 5, y: 5))
        
        XCTAssertEqual(result.x, 10, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testDistanceTo() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(v1.distance(to: v2), 28.284271247461902, accuracy: accuracy)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector2D(x: 10, y: 20)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testNormalize() {
        var vec = Vector2D(x: -10, y: 20)
        
        vec.normalize()
        
        assertEqual(vec, Vector2D(x: -0.4472135954999579, y: 0.8944271909999159),
                    accuracy: accuracy)
    }
    
    func testNormalize_zero() {
        var vec = Vector2D(x: 0, y: 0)
        
        vec.normalize()
        
        XCTAssertEqual(vec, .zero)
    }
    
    func testNormalized() {
        let vec = Vector2D(x: -10, y: 20)
        
        assertEqual(vec.normalized(), Vector2D(x: -0.4472135954999579, y: 0.8944271909999159),
                    accuracy: accuracy)
    }
    
    func testNormalized_zero() {
        let vec = Vector2D(x: 0, y: 0)
        
        XCTAssertEqual(vec.normalized(), .zero)
    }
    
    func testMatrix_identity() {
        let matrix = Vector2D.matrix()
        
        assertEqual(matrix.column1, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_translate() {
        let matrix = Vector2D.matrix(translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scale() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -20.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotate() {
        let matrix = Vector2D.matrix(rotate: .pi)
        
        assertEqual(matrix.column1, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0, -1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_scalePrecedesRotation() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi)
        
        assertEqual(matrix.column1, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotationPrecedesTranslation() {
        let matrix = Vector2D.matrix(rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scaleRotateTranslate() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, -20.0], accuracy: accuracy)
    }
    
    func testMultiplyMatrix() {
        let matrix = Matrix2D(m11: 2, m12: 3, m21: 4, m22: 5, m31: 6, m32: 7)
        let vec = Vector2D(x: 1, y: 2)
        
        assertEqual(vec * matrix, Vector2D(x: 16.0, y: 20.0), accuracy: accuracy)
    }
    
    func testMultiplyMatrix_inPlace() {
        let matrix = Matrix2D.translation(x: 10, y: 20)
        var vec = Vector2D(x: 1, y: 2)
        
        vec *= matrix
        
        XCTAssertEqual(vec, Vector2D(x: 11.0, y: 22.0))
    }
    
    func testAverageVector() {
        let list = [
            Vector2D(x: -1, y: -1),
            Vector2D(x: 0, y: 0),
            Vector2D(x: 10, y: 7)
        ]
        
        XCTAssertEqual(list.averageVector(), Vector2D(x: 3, y: 2))
    }
    
    func testAverageVector_emptyCollection() {
        let list: [Vector2D] = []
        
        XCTAssertEqual(list.averageVector(), Vector2D.zero)
    }
}
