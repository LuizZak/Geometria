import XCTest
import Geometria

class PointProjectableTypeTests: XCTestCase {
    func testDistanceSquaredTo() {
        let sut = TestPointProjective()
        
        XCTAssertEqual(sut.distanceSquared(to: .init(x: 3, y: 4)), 25)
    }
    
    func testDistanceTo() {
        let sut = TestPointProjective()
        
        XCTAssertEqual(sut.distance(to: .init(x: 3, y: 4)), 5)
    }
}

private struct TestPointProjective: PointProjectableType {
    typealias Vector = Vector2D
    
    func project(_ vector: Vector2D) -> Vector2D {
        return .zero
    }
}
