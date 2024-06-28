import XCTest
@testable import Geometria
import TestCommons

#if ENABLE_SIMD
#if canImport(simd)

import simd

#endif // #if canImport(simd)
#endif // #if ENABLE_SIMD

class Comparable_ClampTests: XCTestCase {
    func testClamp() {
        XCTAssertEqual(clamp(7, min: 0, max: 3), 3)
        XCTAssertEqual(clamp(7, min: 5, max: 10), 7)
        XCTAssertEqual(clamp(7, min: 10, max: 13), 10)
    }
    
    #if ENABLE_SIMD
    #if canImport(simd)

    func testClamp_doesntShadowSIMDClamp() {
        // Test that clamp() doesn't shadows SIMD's clamp() function
        let a = SIMD2<Double>(1, 2)
        let b = SIMD2<Double>(0, 4)
        let c = SIMD2<Double>(3, 1)
        
        XCTAssertEqual(clamp(a, min: b, max: c), .init(1, 1))
    }

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
    
    func testClamped() {
        XCTAssertEqual(7.clamped(min: 0, max: 3), 3)
        XCTAssertEqual(7.clamped(min: 5, max: 10), 7)
        XCTAssertEqual(7.clamped(min: 10, max: 13), 10)
    }
}
