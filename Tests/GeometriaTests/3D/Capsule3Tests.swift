import XCTest
import Geometria
import TestCommons

class Capsule3Tests: XCTestCase {
    typealias Capsule = Capsule3D
    
    func testAsCylinder() {
        let sut = Capsule(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 5, y: 7, z: 11),
            radius: 1
        )
        
        let result = sut.asCylinder
        
        XCTAssertEqual(result.start, sut.start)
        XCTAssertEqual(result.end, sut.end)
        XCTAssertEqual(result.radius, sut.radius)
    }
    
    func testSignedDistance_withinBounds() {
        let sut = Capsule(
            start: .zero,
            end: .init(x: 10, y: 10, z: 10),
            radius: 5
        )
        let vector = Vector3D(x: 8, y: 8, z: 8)
        
        let result = sut.signedDistance(to: vector)
        
        XCTAssertEqual(result, -5)
    }
    
    func testSignedDistance_outsideBounds() {
        let sut = Capsule(
            start: .zero,
            end: .init(x: 10, y: 10, z: 10),
            radius: 5
        )
        let vector = Vector3D(x: 10, y: 10, z: 0)
        
        let result = sut.signedDistance(to: vector)
        
        XCTAssertEqual(result, 3.164965809277259)
    }
    
    func testSignedDistance_onEdge() {
        let sut = Capsule(
            start: .zero,
            end: .init(x: 10, y: 0, z: 0),
            radius: 5
        )
        let vector = Vector3D(x: 5, y: 0, z: 5)
        
        let result = sut.signedDistance(to: vector)
        
        XCTAssertEqual(result, 0.0)
    }
}
