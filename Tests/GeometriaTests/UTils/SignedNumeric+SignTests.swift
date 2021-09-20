import XCTest
@testable import Geometria

class SignedNumeric_SignTests: XCTestCase {
    func testSignValueFunction_integer() {
        XCTAssertEqual(signValue(-2.signValue), -1)
        XCTAssertEqual(signValue(0.signValue), 0)
        XCTAssertEqual(signValue(3.signValue), 1)
    }
    
    func testSignValueFunction_floatingPoint() {
        XCTAssertEqual(signValue(-2.0), -1)
        XCTAssertEqual(signValue(-0.0), 0)
        XCTAssertEqual(signValue(0.3), 1)
    }
    
    func testSignValue_integer() {
        XCTAssertEqual(-2.signValue, -1)
        XCTAssertEqual(0.signValue, 0)
        XCTAssertEqual(3.signValue, 1)
    }
    
    func testSignValue_floatingPoint() {
        XCTAssertEqual(-2.0.signValue, -1)
        XCTAssertEqual(-0.0.signValue, 0)
        XCTAssertEqual(0.3.signValue, 1)
    }
}
