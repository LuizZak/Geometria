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

// MARK: VectorFloatingPoint Conformance

extension RayTests {
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

// MARK: VectorReal Conformance

extension RayTests {
    func testDistanceTo2D() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastStart() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distance(to: point), 1.0, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastEnd() {
        let sut = Ray(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.distance(to: point), 1.4142135623730951, accuracy: 1e-15)
    }
    
    func testDistanceTo3D() {
        let sut = Ray3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
}

// MARK: VectorNormalizable Conformance

extension RayTests {
    func testAsDirectionalRay() {
        let sut = Ray(start: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        
        let result = sut.asDirectionalRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(result.angle, sut.angle)
    }
}
