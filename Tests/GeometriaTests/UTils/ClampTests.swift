import XCTest
import Geometria
import simd

class ClampTests: XCTestCase {
    func testClamp() {
        XCTAssertEqual(clamp(7, min: 0, max: 3), 3)
        XCTAssertEqual(clamp(7, min: 5, max: 10), 7)
        XCTAssertEqual(clamp(7, min: 10, max: 13), 10)
    }
    
    func testClamp_doesntShadowSIMDClamp() {
        // Test that clamp() doesn't shadows SIMD's clamp() function
        let a = SIMD2<Double>(1, 2)
        let b = SIMD2<Double>(0, 4)
        let c = SIMD2<Double>(3, 1)
        
        XCTAssertEqual(clamp(a, min: b, max: c), .init(1, 4))
    }
}
