import XCTest
import Geometria

class PointNormalTests: XCTestCase {
    typealias PointNormal = Geometria.PointNormal<Vector2D>
    
    func testDescription() {
        let sut = PointNormal(point: .init(x: 1, y: 2),
                              normal: .init(x: 3, y: 5))
        
        XCTAssertEqual(
            sut.description,
            "PointNormal(point: Vector2<Double>(x: 1.0, y: 2.0), normal: Vector2<Double>(x: 3.0, y: 5.0))"
        )
    }
    
    func testInit() {
        let sut = PointNormal(point: .init(x: 1, y: 2),
                              normal: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.point, .init(x: 1, y: 2))
        XCTAssertEqual(sut.normal, .init(x: 3, y: 5))
    }
}
