import XCTest
import Geometria

class RayTests: XCTestCase {
    typealias Ray = Ray2D
    typealias Ray3 = Ray3D
    
    func testCodable() throws {
        let sut = Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Ray.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)),
                       Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Ray(start: .init(x: 999, y: 2), b: .init(x: 3, y: 5)),
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 999), b: .init(x: 3, y: 5)),
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 999, y: 5)),
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 999)),
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue,
                       Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Ray(start: .init(x: 999, y: 2), b: .init(x: 3, y: 5)).hashValue,
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 999), b: .init(x: 3, y: 5)).hashValue,
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 999, y: 5)).hashValue,
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 999)).hashValue,
                          Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
    }

    func testCategory() {
        let sut = Ray(start: .zero, b: .one)

        XCTAssertEqual(sut.category, .ray)
    }
    
    func testAsLine() {
        let sut = Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
}

// MARK: LineType Conformance

extension RayTests {
    func testA() {
        let sut = Ray(start: .zero, b: .one)
        
        XCTAssertEqual(sut.a, .zero)
    }
}

// MARK: LineAdditive Conformance

extension RayTests {
    func testOffsetBy() {
        let sut = Ray(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(sut.lineSlope, result.lineSlope)
        XCTAssertEqual(result.start, .init(x: 8, y: 13))
        XCTAssertEqual(result.b, .init(x: 10, y: 16))
    }
}

// MARK: LineMultiplicative Conformance

extension RayTests {
    func testWithPointsScaledBy() {
        let sut = Ray(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: 7, y: 22))
        XCTAssertEqual(result.b, .init(x: 21, y: 55))
    }
    
    func testWithPointsScaledByAroundCenter() {
        let sut = Ray(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(result.lineSlope, sut.lineSlope * factor, accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: -23, y: 2.0))
        XCTAssertEqual(result.b, .init(x: -9.0, y: 35.0))
    }
}

// MARK: LineFloatingPoint Conformance

extension RayTests {
    func testAsDirectionalRay() {
        let sut = Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5))

        let result = sut.asDirectionalRay

        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(result.angle, sut.angle)
    }

    func testContainsProjectedNormalizedMagnitude() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(.infinity))
    }
    
    func testContainsProjectedNormalizedMagnitude_returnsFalseForNaN() {
        let sut = Ray(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.nan))
    }
    
    func testClampProjectedNormalizedMagnitude() {
        let sut = Ray(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 2)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), .infinity)
    }
    
    func testDistanceSquaredTo2D() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1.0, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 1, y: 3)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 2, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = Ray3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.6666666666666667, accuracy: 1e-15)
    }
}
