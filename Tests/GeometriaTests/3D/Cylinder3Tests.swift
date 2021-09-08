import XCTest
import Geometria

class Cylinder3Tests: XCTestCase {
    typealias Cylinder = Cylinder3<Vector3D>
    
    func testAsLine() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 3),
                           end: .init(x: 5, y: 7, z: 11),
                           radius: 1)
        
        let result = sut.asLineSegment
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.end, .init(x: 5, y: 7, z: 11))
    }
}

// MARK: VolumetricType Conformance

extension Cylinder3Tests {
    func testStartAsDisk() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 3),
                           end: .init(x: 29, y: 31, z: 37),
                           radius: 5)
        
        let result = sut.startAsDisk
        
        XCTAssertEqual(result.center, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.normal, .init(x: -0.530954782389336, y: -0.5499174531889551, z: -0.6447308071870509))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testEndAsDisk() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 3),
                           end: .init(x: 29, y: 31, z: 37),
                           radius: 5)
        
        let result = sut.endAsDisk
        
        XCTAssertEqual(result.center, .init(x: 29, y: 31, z: 37))
        XCTAssertEqual(result.normal, .init(x: 0.530954782389336, y: 0.5499174531889551, z: 0.6447308071870509))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testContains_withinLineProjection_returnsTrue() {
        let sut = Cylinder(start: .init(x: 13, y: 17, z: 5),
                           end: .init(x: 13, y: 29, z: 5),
                           radius: 3)
        
        XCTAssertTrue(sut.contains(x: 12, y: 20, z: 5))
        XCTAssertTrue(sut.contains(x: 14, y: 20, z: 5))
    }
    
    func testContains_outOfBounds_returnsFalse() {
        let sut = Cylinder(start: .init(x: 13, y: 17, z: 5),
                           end: .init(x: 13, y: 29, z: 5),
                           radius: 3)
        
        XCTAssertFalse(sut.contains(.init(x: 9, y: 20, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 17, y: 20, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 13, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 33, z: 5)))
    }
    
    func testContains_withinLineDistanceAtEnds_returnsFalse() {
        let sut = Cylinder(start: .init(x: 13, y: 17, z: 5),
                           end: .init(x: 13, y: 29, z: 5),
                           radius: 3)
        
        XCTAssertFalse(sut.contains(x: 12, y: 16, z: 5))
        XCTAssertFalse(sut.contains(x: 14, y: 30, z: 5))
    }
}

// MARK: PointProjectableType Conformance

extension Cylinder3Tests {
    func testProject_pointOnTopOfStart_center() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: 1, y: 2, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 2, z: 10))
    }
    
    func testProject_pointOnTopOfStart_offCenter() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: 0, y: -1, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 0, y: -1, z: 10))
    }
    
    func testProject_pointOnTopOfStart_offRadius() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: -10, y: -10, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 4.378623142586731, y: 5.685770701003707, z: 10.0))
    }
    
    func testProject_pointBelowEnd_center() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: 1, y: 2, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 2, z: 0))
    }
    
    func testProject_pointBelowEnd_offCenter() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: 0, y: -1, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 0, y: -1, z: 0))
    }
    
    func testProject_pointBelowEnd_offRadius() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: -10, y: -10, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 4.378623142586731, y: 5.685770701003707, z: 0.0))
    }
    
    func testProject_betweenEnds() {
        let sut = Cylinder(start: .init(x: 1, y: 2, z: 10),
                           end: .init(x: 1, y: 2, z: 0),
                           radius: 5)
        let point = Vector3D(x: -10, y: -10, z: 5)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 4.378623142586731, y: 5.685770701003707, z: 5))
    }
}
