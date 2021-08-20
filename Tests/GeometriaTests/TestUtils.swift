import XCTest
import Geometria

func assertEqual<T: Equatable & FloatingPoint>(_ simd1: SIMD2<T>,
                                               _ simd2: SIMD2<T>,
                                               accuracy: T,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
    
    XCTAssertEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
}

func assertEqual<T: Equatable & FloatingPoint>(_ simd1: SIMD3<T>,
                                               _ simd2: SIMD3<T>,
                                               accuracy: T,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
    
    XCTAssertEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
    XCTAssertEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
}

func assertNotEqual<T: Equatable & FloatingPoint>(_ simd1: SIMD2<T>,
                                                  _ simd2: SIMD2<T>,
                                                  accuracy: T,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) {
    
    XCTAssertNotEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertNotEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
}

func assertNotEqual<T: Equatable & FloatingPoint>(_ simd1: SIMD3<T>,
                                                  _ simd2: SIMD3<T>,
                                                  accuracy: T,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) {
    
    XCTAssertNotEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertNotEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
    XCTAssertNotEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
}
