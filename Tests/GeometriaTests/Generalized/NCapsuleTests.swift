import XCTest
import Geometria

class NCapsuleTests: XCTestCase {
    typealias Stadium = NCapsule<Vector2D>
    typealias Capsule = NCapsule<Vector3D>
    
    func testAsLine() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 3, y: 5),
                          radius: 1)
        
        let result = sut.asLineSegment
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.end, .init(x: 3, y: 5))
    }
}

// MARK: VolumetricType Conformance

extension NCapsuleTests {
    func testContains_withinLineProjection_returnsTrue() {
        let sut = Stadium(start: .init(x: 13, y: 17),
                          end: .init(x: 13, y: 29),
                          radius: 3)
        
        XCTAssertTrue(sut.contains(x: 12, y: 20))
        XCTAssertTrue(sut.contains(x: 14, y: 20))
    }
    
    func testContains_outOfBounds_returnsFalse() {
        let sut = Stadium(start: .init(x: 13, y: 17),
                          end: .init(x: 13, y: 29),
                          radius: 3)
        
        XCTAssertFalse(sut.contains(.init(x: 9, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 17, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 13)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 33)))
    }
    
    func testContains_withinLineDistanceAtEnds_returnsTrue() {
        let sut = Stadium(start: .init(x: 13, y: 17),
                          end: .init(x: 13, y: 29),
                          radius: 3)
        
        XCTAssertTrue(sut.contains(x: 12, y: 16))
        XCTAssertTrue(sut.contains(x: 14, y: 30))
    }
}
