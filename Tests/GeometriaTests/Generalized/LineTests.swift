import XCTest
import Geometria

class LineTests: XCTestCase {
    typealias Line = Line2D
    typealias Line3 = Line3D
    
    func testCodable() throws {
        let sut = Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Line.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)),
                       Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Line(a: .init(x: 999, y: 2), b: .init(x: 3, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 999), b: .init(x: 3, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 999, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 999)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue,
                       Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 999, y: 2), b: .init(x: 3, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 999), b: .init(x: 3, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 999, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 999)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
    }
}

// MARK: LineAdditive Conformance

extension LineTests {
    func testOffsetBy() {
        let sut = Line(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(sut.lineSlope, result.lineSlope)
        XCTAssertEqual(result.a, .init(x: 8, y: 13))
        XCTAssertEqual(result.b, .init(x: 10, y: 16))
    }
}

// MARK: LineMultiplicative Conformance

extension LineTests {
    func testWithPointsScaledBy() {
        let sut = Line(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.a, .init(x: 7, y: 22))
        XCTAssertEqual(result.b, .init(x: 21, y: 55))
    }
    
    func testWithPointsScaledByAroundCenter() {
        let sut = Line(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.a, .init(x: -23, y: 2.0))
        XCTAssertEqual(result.b, .init(x: -9.0, y: 35.0))
    }
}

// MARK: LineFloatingPoint Conformance

extension LineTests {
    func testContainsProjectedNormalizedMagnitude() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(.infinity))
    }
    
    func testContainsProjectedNormalizedMagnitude_returnsFalseForNaN() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.nan))
    }
    
    func testClampProjectedNormalizedMagnitude() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), -.infinity)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), -1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), -0.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 2)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), .infinity)
    }
}
