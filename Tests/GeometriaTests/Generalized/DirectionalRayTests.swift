import XCTest
import Geometria

class DirectionalRayTests: XCTestCase {
    typealias DirectionalRay = DirectionalRay2D
    typealias DirectionalRay3 = DirectionalRay3D
    
    func testCodable() throws {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(DirectionalRay.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)),
                       DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 999, y: 2),
                                         direction: .init(x: 3, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 999),
                                         direction: .init(x: 3, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 999, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 999)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)).hashValue,
                       DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 999, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 999),
                                         direction: .init(x: 3, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 999, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 999)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
    }
    
    func testDirection_asUnit() {
        XCTAssertEqual(DirectionalRay(start: .zero,
                                      direction: .init(x: 2, y: 3)).direction,
                       .init(x: 0.5547001962252291, y: 0.8320502943378437))
    }
}

// MARK: LineType Conformance

extension DirectionalRayTests {
    func testA() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2), direction: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.a, .init(x: 1, y: 2))
    }
    
    func testB() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2), direction: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
    }
}

// MARK: VectorAdditive Conformance

extension DirectionalRayTests {
    func testAsLine() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
        XCTAssertEqual(result.angle, sut.angle)
    }
    
    func testAsRay() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        
        let result = sut.asRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
        XCTAssertEqual(result.angle, sut.angle)
    }
}

// MARK: LineFloatingPoint, Vector: VectorFloatingPoint Conformance

extension DirectionalRayTests {
    func testProjectScalar2D() {
        let sut = DirectionalRay(x: 2, y: 1, dx: 3, dy: 2)
        let point = Vector2D(x: 2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 0.5547001962252291, accuracy: 1e-12)
    }
    
    func testProjectScalar2D_offBounds() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), -2)
    }
    
    func testProjectScalar2D_skewed() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 1.4142135623730951, accuracy: 1e-12)
    }
    
    func testProjectScalar3D() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 3, dy: 0, dz: 0)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 1.0, accuracy: 1e-12)
    }
    
    func testProjectScalar3D_offBounds() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 0, dz: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), -3)
    }
    
    func testProjectScalar3D_skewed() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 1.1547005383792515, accuracy: 1e-12)
    }
    
    func testProject2D() {
        let sut = DirectionalRay(x: 2, y: 1, dx: 3, dy: 2)
        let point = Vector2D(x: 2, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 2.4615384615384617, y: 1.3076923076923077),
                    accuracy: 1e-12)
    }
    
    func testProject2D_parallel() {
        let sut = Line2D(x1: 0, y1: 0, x2: 3, y2: 0)
        let point = Vector2D(x: 1, y: 0)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 0),
                    accuracy: 1e-12)
    }
    
    func testProject2D_offBounds() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.project(point), Vector2D(x: -2, y: 0))
    }
    
    func testProject2D_skewed() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 1),
                    accuracy: 1e-12)
    }
    
    func testProject2D_skewed_centered() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 1)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 0.5, y: 0.5),
                    accuracy: 1e-12)
    }
    
    func testProject3D_parallel() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 3, dy: 0, dz: 0)
        let point = Vector3D(x: 1, y: 0, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 1, y: 0, z: 0),
                    accuracy: 1e-12)
    }
    
    func testProject3D_offBounds() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 0, dz: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.project(point), Vector3D(x: -3, y: 0, z: 0))
    }
    
    func testProject3D_skewed() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProject3D_skewed_centered() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testDistanceSquaredTo2D() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1.0, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 1, y: 3)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 2, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.6666666666666667, accuracy: 1e-15)
    }
}
