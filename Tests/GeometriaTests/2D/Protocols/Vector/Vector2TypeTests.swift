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
    
    func testInitWithVector() {
        struct TestVec2: Vector2Type {
            // swiftlint:ignore:next nesting
            typealias Scalar = Double
            
            var x: Double
            var y: Double
            
            init(x: Double, y: Double) {
                (self.x, self.y) = (x, y)
            }
            
            init(repeating scalar: Double) {
                (x, y) = (scalar, scalar)
            }
        }
        
        let testVec = TestVec2(x: 1, y: 2)
        let sut = Vector2D(testVec)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 2)
    }
    
    func testMinimalComponentIndex() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).minimalComponentIndex, 0)
        XCTAssertEqual(Vector2D(x: 1, y: -2).minimalComponentIndex, 1)
    }
    
    func testMinimalComponentIndex_equalXY() {
        XCTAssertEqual(Vector2D(x: 1, y: 1).minimalComponentIndex, 1)
    }
    
    func testMaximalComponentIndex() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).maximalComponentIndex, 1)
        XCTAssertEqual(Vector2D(x: 1, y: -2).maximalComponentIndex, 0)
    }
    
    func testMaximalComponentIndex_equalXY() {
        XCTAssertEqual(Vector2D(x: 1, y: 1).maximalComponentIndex, 1)
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
