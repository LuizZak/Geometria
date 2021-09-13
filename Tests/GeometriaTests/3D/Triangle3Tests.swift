import XCTest
import Geometria

class Triangle3Tests: XCTestCase {
    typealias Triangle = Triangle3D
}

// MARK: Vector: Vector3FloatingPoint Conformance

extension Triangle3Tests {
    func testNormal_onPlaneXY() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, -.unitZ)
    }
    
    func testNormal_onPlaneXY_counterClockwise() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .unitZ)
    }
    
    func testNormal_slanted() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .init(x: 0.0, y: 0.7071067811865475, z: -0.7071067811865475))
    }
    
    func testNormal_colinear() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 1, z: 1),
            c: .init(x: 2, y: 2, z: 2)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .zero)
    }
    
    func testNormal_zero() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.normal
        
        XCTAssertEqual(result, .zero)
    }
    
    func testAsPlane_onPlaneXY() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, -.unitZ)
    }
    
    func testAsPlane_onPlaneXY_counterClockwise() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .unitZ)
    }
    
    func testAsPlane_slanted() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .init(x: 0.0, y: 0.7071067811865476, z: -0.7071067811865476))
    }
    
    func testAsPlane_colinear() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 1, z: 1),
            c: .init(x: 2, y: 2, z: 2)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .zero)
    }
    
    func testAsPlane_zero() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, .zero)
        XCTAssertEqual(result.normal, .zero)
    }
}
