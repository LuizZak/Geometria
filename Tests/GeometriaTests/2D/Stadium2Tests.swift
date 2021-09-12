import XCTest
import Geometria

class Stadium2Tests: XCTestCase {
    typealias Stadium = Stadium2<Vector2D>
    
    func testAsLine() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 5, y: 7),
                          radius: 1)
        
        let result = sut.asLineSegment
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.end, .init(x: 5, y: 7))
    }
    
    func testIsValid() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 1, y: 3),
                          radius: 1)
        
        XCTAssertTrue(sut.isValid)
    }
    
    func testIsValid_zeroLengthStadium_returnsFalse() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 1, y: 2),
                          radius: 1)
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_zeroRadiusStadium_returnsFalse() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 1, y: 2),
                          radius: 0)
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_negativeRadiusStadium_returnsFalse() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 1, y: 2),
                          radius: -4)
        
        XCTAssertFalse(sut.isValid)
    }
}

// MARK: BoundableType Conformance

extension Stadium2Tests {
    func testBounds_unitLengthStadium() {
        let sut = Stadium(start: .zero,
                          end: .unitY,
                          radius: 1)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -1, y: -1))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 2))
    }
    
    func testBounds_verticalStadium() {
        let sut = Stadium(start: .zero,
                          end: .unitY * 20,
                          radius: 3)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -3))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 23))
    }
    
    func testBounds_skewedStadium() {
        let sut = Stadium(start: .init(x: -2, y: 0),
                          end: .init(x: 3, y: 5),
                          radius: 4)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -6.0, y: -4.0))
        XCTAssertEqual(result.maximum, .init(x: 7.0, y: 9.0))
    }
}

// MARK: VolumetricType Conformance

extension Stadium2Tests {
    func testStartAsCircle() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 29, y: 31),
                          radius: 5)
        
        let result = sut.startAsCircle
        
        XCTAssertEqual(result.center, .init(x: 1, y: 2))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testEndAsCircle() {
        let sut = Stadium(start: .init(x: 1, y: 2),
                          end: .init(x: 29, y: 31),
                          radius: 5)
        
        let result = sut.endAsCircle
        
        XCTAssertEqual(result.center, .init(x: 29, y: 31))
        XCTAssertEqual(result.radius, 5)
    }
    
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
