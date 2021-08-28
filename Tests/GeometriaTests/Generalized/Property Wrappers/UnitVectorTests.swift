import XCTest
import Geometria

class UnitVectorTests: XCTestCase {
    typealias UnitVector = Geometria.UnitVector<Vector2D>
    
    func testInit() {
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: 1, y: 0)).wrappedValue,
                       .init(x: 1, y: 0))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: 0, y: 1)).wrappedValue,
                       .init(x: 0, y: 1))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: -1, y: 0)).wrappedValue,
                       .init(x: -1, y: 0))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: 0, y: -1)).wrappedValue,
                       .init(x: 0, y: -1))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: 2, y: 3)).wrappedValue,
                       .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: -2, y: 3)).wrappedValue,
                       .init(x: -0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: -2, y: -3)).wrappedValue,
                       .init(x: -0.5547001962252291, y: -0.8320502943378437))
        XCTAssertEqual(UnitVector(wrappedValue: .init(x: 2, y: -3)).wrappedValue,
                       .init(x: 0.5547001962252291, y: -0.8320502943378437))
    }
    
    func testSet() {
        var sut: UnitVector = UnitVector(wrappedValue: .init(x: 1, y: 0))
        
        sut.wrappedValue = .init(x: 2, y: 3)
        
        XCTAssertEqual(sut.wrappedValue, .init(x: 0.5547001962252291, y: 0.8320502943378437))
    }
}
