import XCTest
import Geometria
import TestCommons

class Line2Real_Tests: XCTestCase {
    typealias Vector = Vector2D
    typealias Line = Line2<Vector>
    
    func testAngle() {
        let sut = Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.angle, 0.982793723247329, accuracy: 1e-13)
    }
}
