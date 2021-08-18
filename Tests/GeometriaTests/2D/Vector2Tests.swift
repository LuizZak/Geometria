import XCTest
import Geometria

class Vector2Tests: XCTestCase {
    typealias Vector = Vector2<Int>
    
    func testZero() {
        XCTAssertEqual(Vector.zero.x, 0)
        XCTAssertEqual(Vector.zero.y, 0)
    }
    
    func testUnit() {
        XCTAssertEqual(Vector.unit.x, 1)
        XCTAssertEqual(Vector.unit.y, 1)
    }
    
    func testOne() {
        XCTAssertEqual(Vector.one.x, 1)
        XCTAssertEqual(Vector.one.y, 1)
    }
    
    func testDescription() {
        XCTAssertEqual(Vector2<Int>(x: 0, y: 1).description,
                       "Vector2<Int>(x: 0, y: 1)")
        XCTAssertEqual(Vector2<Double>(x: 0, y: 1).description,
                       "Vector2<Double>(x: 0.0, y: 1.0)")
    }
    
    func testInitZero() {
        let sut = Vector()
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 0)
    }
    
    func testInit() {
        let sut = Vector(x: 0, y: 1)
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testInitXy() {
        let sut = Vector(1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testSetX() {
        var sut = Vector.zero
        
        sut.x = 1
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 0)
    }
    
    func testSetY() {
        var sut = Vector.zero
        
        sut.y = 1
        
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
    
    func testDistanceSquared() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(v1.distanceSquared(to: v2), 800)
    }
    
    func testDot() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(v1.dot(v2), 1100)
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
    
    func testSmoothStep() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(Vector2D.smoothStep(start: v1, end: v2, amount: -1), v1)
        XCTAssertEqual(Vector2D.smoothStep(start: v1, end: v2, amount: 0), v1)
        XCTAssertEqual(Vector2D.smoothStep(start: v1, end: v2, amount: 0.5), Vector2D(x: 20, y: 30))
        XCTAssertEqual(Vector2D.smoothStep(start: v1, end: v2, amount: 1), v2)
        XCTAssertEqual(Vector2D.smoothStep(start: v1, end: v2, amount: 2), v2)
    }
}
