import XCTest
import Geometria

class NSphereTests: XCTestCase {
    typealias NSphere = Circle2D
    
    func testCodable() throws {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(NSphere.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithCenterRadius() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertEqual(sut.center, .init(x: 0, y: 1))
        XCTAssertEqual(sut.radius, 2)
    }
}

// MARK: AdditiveArithmetic Conformance

extension NSphereTests {
    func testExpandedBy() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        let result = sut.expanded(by: 3)
        
        XCTAssertEqual(result.center, .init(x: 0, y: 1))
        XCTAssertEqual(result.radius, 5)
    }
    
}

// MARK: VectorMultiplicative, Scalar: Comparable Conformance

extension NSphereTests {
    func testContainsVector() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertTrue(sut.contains(.init(x: 1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: -1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 0)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 3)))
        //
        XCTAssertFalse(sut.contains(.init(x: -3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: 4)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: -3)))
    }
}
