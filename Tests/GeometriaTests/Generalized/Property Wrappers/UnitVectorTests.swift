import XCTest
import Geometria
import TestCommons

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
        
        XCTAssertTrue(UnitVector(wrappedValue: .init(x: 1, y: 0)).isValid)
    }
    
    func testSet() {
        var sut = UnitVector(wrappedValue: .init(x: 1, y: 0))
        
        sut.wrappedValue = .init(x: 2, y: 3)
        
        XCTAssertEqual(sut.wrappedValue, .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertTrue(sut.isValid)
    }
    
    func testInit_invalid() {
        let sut = UnitVector(wrappedValue: .zero)
        
        XCTAssertEqual(sut.wrappedValue, .zero)
        XCTAssertFalse(sut.isValid)
    }
    
    func testSet_invalidValue() {
        var sut = UnitVector(wrappedValue: .one)
        
        sut.wrappedValue = .zero
        
        XCTAssertEqual(sut.wrappedValue, .zero)
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_resetsAfterAssigningValidValue() {
        var sut = UnitVector(wrappedValue: .zero)
        
        sut.wrappedValue = .init(x: 1, y: 0)
        
        XCTAssertEqual(sut.wrappedValue, .init(x: 1, y: 0))
        XCTAssertTrue(sut.isValid)
    }
}
