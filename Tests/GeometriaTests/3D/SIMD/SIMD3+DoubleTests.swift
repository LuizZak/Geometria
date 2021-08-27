import XCTest
import Geometria

class SIMD3_DoubleTests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = SIMD3<Double>
    
    func testPointwiseMin() {
        let vec1 = Vector(x: 2, y: -3, z: 5)
        let vec2 = Vector(x: -1, y: 4, z: -6)
        
        XCTAssertEqual(Vector.pointwiseMin(vec1, vec2), Vector(x: -1, y: -3, z: -6))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector(x: 2, y: -3, z: 5)
        let vec2 = Vector(x: -1, y: 4, z: -6)
        
        XCTAssertEqual(Vector.pointwiseMax(vec1, vec2), Vector(x: 2, y: 4, z: 5))
    }
    
    func testGreaterThan() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1) > Vector(x: 0, y: 0, z: 0))
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 1, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 1, y: 1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1) >= Vector(x: 0, y: 0, z: 0))
    }
    
    func testLessThan() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) < Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1) < Vector(x: 0, y: 0, z: 0))
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: -1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: -1) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1) <= Vector(x: 0, y: 0, z: 0))
    }
    
    func testLengthSquared() {
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1).lengthSquared, 14)
        XCTAssertEqual(Vector(x: 3.0, y: 2.0, z: 1.0).lengthSquared, 14.0)
    }
    
    func testDistanceSquared() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.distanceSquared(to: v2), 2700)
    }
    
    func testDistanceSquared_zeroDistance() {
        let vec = Vector(x: 10, y: 20, z: 30)
        
        XCTAssertEqual(vec.distanceSquared(to: vec), 0.0)
    }
    
    func testDot() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.dot(v2), 3200)
    }
    
    func testRatio() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.ratio(-1, to: v2), Vector(x: -20, y: -10, z: 0))
        XCTAssertEqual(v1.ratio(0, to: v2), v1)
        XCTAssertEqual(v1.ratio(0.5, to: v2), Vector(x: 25, y: 35, z: 45))
        XCTAssertEqual(v1.ratio(1, to: v2), v2)
        XCTAssertEqual(v1.ratio(2, to: v2), Vector(x: 70, y: 80, z: 90))
    }
    
    func testLerp() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 70, y: 110, z: 130)
        
        XCTAssertEqual(Vector.lerp(start: v1, end: v2, amount: -1), Vector(x: -50, y: -70, z: -70))
        XCTAssertEqual(Vector.lerp(start: v1, end: v2, amount: 0), v1)
        XCTAssertEqual(Vector.lerp(start: v1, end: v2, amount: 0.5), Vector(x: 40.0, y: 65.0, z: 80.0))
        XCTAssertEqual(Vector.lerp(start: v1, end: v2, amount: 1), v2)
        XCTAssertEqual(Vector.lerp(start: v1, end: v2, amount: 2), Vector(x: 130.0, y: 200.0, z: 230.0))
    }
    
    func testAbsolute() {
        let vec = Vector(x: -1, y: -2, z: -3)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2, z: 3))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector(x: -1, y: 2, z: 3)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2, z: 3))
    }
    
    func testAbsolute_positive() {
        let vec = Vector(x: 1, y: 2, z: 3)
        
        XCTAssertEqual(vec.absolute, Vector(x: 1, y: 2, z: 3))
    }
    
    func testNegate() {
        XCTAssertEqual(-Vector(x: 1, y: 2, z: 3), Vector(x: -1, y: -2, z: -3))
    }
    
    func testNegate_doubleNegateEqualsIdendity() {
        let vec = Vector(x: 1, y: 2, z: 3)
        
        XCTAssertEqual(-(-vec), vec)
    }
    
    func testAddingProduct() {
        let a = Vector(x: 0.5, y: 0.6, z: 0.7)
        let b = Vector(x: 1, y: 2, z: 3)
        let c = Vector(x: 5, y: 7, z: 11)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 5.5)
        XCTAssertEqual(result.y, 14.6)
        XCTAssertEqual(result.z, 33.7)
    }
    
    func testAddingProductScalarVector() {
        let a = Vector(x: 0.5, y: 0.6, z: 0.7)
        let b = 2.0
        let c = Vector(x: 5, y: 7, z: 11)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 10.5)
        XCTAssertEqual(result.y, 14.6)
        XCTAssertEqual(result.z, 22.7)
    }
    
    func testAddingProductVectorScalar() {
        let a = Vector(x: 0.5, y: 0.6, z: 0.7)
        let b = Vector(x: 1, y: 2, z: 3)
        let c = 2.0
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 4.6)
        XCTAssertEqual(result.z, 6.7)
    }
    
    func testRoundedWithRoundingRule() {
        let vec = Vector(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.rounded(.up), Vector(x: 1, y: 2, z: 4))
        XCTAssertEqual(vec.rounded(.down), Vector(x: 0, y: 1, z: 3))
        XCTAssertEqual(vec.rounded(.toNearestOrAwayFromZero), Vector(x: 1, y: 2, z: 3))
        XCTAssertEqual(vec.rounded(.toNearestOrEven), Vector(x: 0, y: 2, z: 3))
        XCTAssertEqual(vec.rounded(.towardZero), Vector(x: 0, y: 1, z: 3))
        XCTAssertEqual(vec.rounded(.awayFromZero), Vector(x: 1, y: 2, z: 4))
    }
    
    func testRounded() {
        let vec = Vector(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.rounded(), Vector(x: 1, y: 2, z: 3))
    }
    
    func testFloor() {
        let vec = Vector(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.floor(), Vector(x: 0, y: 1, z: 3))
    }
    
    func testCeil() {
        let vec = Vector(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.ceil(), Vector(x: 1, y: 2, z: 4))
    }
    
    func testModulosOperator_vector() {
        let vec = Vector(x: 3, y: 10, z: 7)
        let mod = Vector(x: 4, y: 3, z: 5)
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 2)
    }
    
    func testModulosOperator_scalar() {
        let vec = Vector(x: 3, y: 10, z: 7)
        let mod = 4.0
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
    }
    
    func testFloatingPointInitWithBinaryInteger() {
        let vecInt = Vector3i(x: 1, y: 2, z: 3)
        
        let vec = SIMD3<Double>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
        XCTAssertEqual(vec.z, 3)
    }
    
    // Ensure the original overloaded init from simd module still works without
    // ambiguities
    func testFloatingPointInitWithBinaryInteger_simd() {
        let vecInt = SIMD3<Int>(x: 1, y: 2, z: 3)
        
        let vec = SIMD3<Double>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
        XCTAssertEqual(vec.z, 3)
    }
    
    func testLength() {
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1).length, 3.7416573867739413, accuracy: accuracy)
    }
    
    func testPowFactor_double() {
        let vec = Vector(x: 2, y: 3, z: 5)
        
        let result = Vector.pow(vec, 6.0)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowFactor_double_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5)
        
        let result = Vector.pow(vec, 6.0)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
    }
    
    func testPowFactor_integer() {
        let vec = Vector(x: 2, y: 3, z: 5)
        
        let result = Vector.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowFactor_integer_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5)
        
        let result = Vector.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowVector() {
        let vec = Vector(x: 2, y: 3, z: 5)
        let power = Vector(x: 6, y: 7, z: 8)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 2187)
        XCTAssertEqual(result.z, 390625)
    }
    
    func testPowVector_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5)
        let power = Vector(x: 6, y: 7, z: 8)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
    }
    
    func testDistanceTo() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.distance(to: v2), 51.96152422706632, accuracy: accuracy)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector(x: 10, y: 20, z: 30)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testNormalize() {
        var vec = Vector(x: -10, y: 20, z: 15.0)
        
        vec.normalize()
        
        assertEqual(vec, Vector(x: -0.3713906763541037,
                                y: 0.7427813527082074,
                                z: 0.5570860145311556),
                    accuracy: accuracy)
    }
    
    func testNormalize_zero() {
        var vec = Vector(x: 0, y: 0, z: 0)
        
        vec.normalize()
        
        XCTAssertEqual(vec, .zero)
    }
    
    func testNormalized() {
        let vec = Vector(x: -10, y: 20, z: 15.0)
        
        assertEqual(vec.normalized(), Vector(x: -0.3713906763541037,
                                             y: 0.7427813527082074,
                                             z: 0.5570860145311556),
                    accuracy: accuracy)
    }
    
    func testNormalized_zero() {
        let vec = Vector(x: 0, y: 0, z: 0)
        
        XCTAssertEqual(vec.normalized(), .zero)
    }
    
    func testAzimuth() {
        let vec = Vector(x: 1, y: 1, z: 1)
        
        XCTAssertEqual(vec.azimuth, 0.7853981633974483)
    }
    
    func testElevation() {
        let vec = Vector(x: 1, y: 1, z: 1)
        
        XCTAssertEqual(vec.elevation, 0.7853981633974483)
    }
}
