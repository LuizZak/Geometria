import XCTest
import Geometria

class Vector2TypeTests: XCTestCase {
    func testScalarCount() {
        XCTAssertEqual(Vector2D().scalarCount, 2)
    }
    
    func testSubscript_x() {
        XCTAssertEqual(Vector2D(x: 0, y: 2)[0], 0)
    }
    
    func testSubscript_x_set() {
        var sut = Vector2D.zero
        
        sut[0] = 2
        
        XCTAssertEqual(sut, .init(x: 2, y: 0))
    }
    
    func testSubscript_y() {
        XCTAssertEqual(Vector2D(x: 0, y: 2)[1], 2)
    }
    
    func testSubscript_y_set() {
        var sut = Vector2D.zero
        
        sut[1] = 2
        
        XCTAssertEqual(sut, .init(x: 0, y: 2))
    }
    
    func testMinimalComponent() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).minimalComponent, -1)
        XCTAssertEqual(Vector2D(x: 1, y: -2).minimalComponent, -2)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).maximalComponent, 2)
        XCTAssertEqual(Vector2D(x: 1, y: -2).maximalComponent, 1)
    }
}