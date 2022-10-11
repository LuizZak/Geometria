import XCTest
import Geometria

class LineSegmentTests: XCTestCase {
    typealias LineSegment = LineSegment2D
    typealias LineSegment3 = LineSegment3D
    
    func testCodable() throws {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(LineSegment.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)),
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        )
    }
    
    func testUnequals() {
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)),
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)),
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)),
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)),
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        )
    }
    
    func testHashable() {
        XCTAssertEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue,
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)).hashValue,
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)).hashValue,
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)).hashValue,
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue
        )
        
        XCTAssertNotEqual(
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)).hashValue,
            LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue
        )
    }

    func testCategory() {
        let sut = LineSegment(start: .zero, end: .one)

        XCTAssertEqual(sut.category, .lineSegment)
    }
    
    func testAsLine() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
    
    func testAsRay() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
}

// MARK: LineType Conformance

extension LineSegmentTests {
    func testA() {
        let sut = LineSegment(start: .zero, end: .one)
        
        XCTAssertEqual(sut.a, .zero)
    }
    
    func testB() {
        let sut = LineSegment(start: .zero, end: .one)
        
        XCTAssertEqual(sut.b, .one)
    }
}

// MARK: BoundableType Conformance

extension LineSegmentTests {
    func testBounds() {
        let sut = LineSegment(start: .init(x: 1, y: -2), end: .init(x: -3, y: 5))
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 5))
    }
}

// MARK: LineAdditive Conformance

extension LineSegmentTests {
    func testOffsetBy() {
        let sut = LineSegment(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(sut.lineSlope, result.lineSlope)
        XCTAssertEqual(result.start, .init(x: 8, y: 13))
        XCTAssertEqual(result.end, .init(x: 10, y: 16))
    }
}

// MARK: LineMultiplicative Conformance

extension LineSegmentTests {
    func testLengthSquared() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.lengthSquared, 13)
    }
    
    func testWithPointsScaledBy() {
        let sut = LineSegment(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: 7, y: 22))
        XCTAssertEqual(result.end, .init(x: 21, y: 55))
    }
    
    func testWithPointsScaledByAroundCenter() {
        let sut = LineSegment(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: -23, y: 2.0))
        XCTAssertEqual(result.end, .init(x: -9.0, y: 35.0))
    }
}

// MARK: LineDivisible Conformance

extension LineSegmentTests {
    func testCenter() {
        let sut = LineSegment(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.center
        
        XCTAssertEqual(result.x, 2)
        XCTAssertEqual(result.y, 3.5)
    }
    
    func testCenter_zeroLine() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 0, y2: 0)
        
        let result = sut.center
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 0.0)
    }
    
    func testCenter_mixedSigns() {
        let sut = LineSegment(x1: -2, y1: 2, x2: 5, y2: -7)
        
        let result = sut.center
        
        XCTAssertEqual(result.x, 1.5)
        XCTAssertEqual(result.y, -2.5)
    }
}

// MARK: LineFloatingPoint Conformance

extension LineSegmentTests {
    func testLength() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))

        XCTAssertEqual(sut.length, 3.605551275463989, accuracy: 1e-13)
    }

    func testAsDirectionalRay() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))

        let result = sut.asDirectionalRay

        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(result.angle, sut.angle)
    }

    func testContainsProjectedNormalizedMagnitude() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.infinity))
    }
    
    func testContainsProjectedNormalizedMagnitude_returnsFalseForNaN() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.nan))
    }
    
    func testClampProjectedNormalizedMagnitude() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), 1)
    }
    
    func testDistanceSquaredTo2D() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = LineSegment3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(
            sut.distanceSquared(to: point),
            0.6666666666666667,
            accuracy: 1e-15
        )
    }
}
