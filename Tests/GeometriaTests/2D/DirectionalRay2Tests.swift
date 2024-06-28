import XCTest
import Geometria
import TestCommons

class DirectionalRay2Tests: XCTestCase {
    typealias DirectionalRay = DirectionalRay2D
    
    func testInitWithCoordinates() {
        let sut = DirectionalRay(x1: 1, y1: 2, x2: 1, y2: -2)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.direction.x, 0)
        XCTAssertEqual(sut.direction.y, -1)
    }
    
    func testInitWithCenterDirection() {
        let sut = DirectionalRay(x: 1, y: 2, dx: 3, dy: 5)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.direction.x, 0.5144957554275265)
        XCTAssertEqual(sut.direction.y, 0.8574929257125441)
    }
    
    func testInitWithCenterDirection_normalization() {
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 3, dy: 5).direction,
                       .init(x: 0.5144957554275265, y: 0.8574929257125441))
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 1, dy: 0).direction,
                       .init(x: 1, y: 0))
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 0, dy: 1).direction,
                       .init(x: 0, y: 1))
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: -1, dy: 0).direction,
                       .init(x: -1, y: 0))
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 0, dy: -1).direction,
                       .init(x: 0, y: -1))
    }
    
    func testAngle() {
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 3, dy: 5).angle,
                       1.0303768265243125,
                       accuracy: 1e-13)
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 1, dy: 0).angle,
                       0,
                       accuracy: 1e-13)
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 0, dy: 1).angle,
                       .pi / 2,
                       accuracy: 1e-13)
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: -1, dy: 0).angle,
                       .pi,
                       accuracy: 1e-13)
        XCTAssertEqual(DirectionalRay(x: 1, y: 2, dx: 0, dy: -1).angle,
                       -.pi / 2,
                       accuracy: 1e-13)
    }
}
