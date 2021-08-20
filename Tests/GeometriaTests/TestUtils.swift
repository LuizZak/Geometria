import XCTest
import Geometria

// MARK: Vector2 equality

func assertEqual<T: Equatable & FloatingPoint>(_ vec1: Vector2<T>,
                                               _ vec2: Vector2<T>,
                                               accuracy: T,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
    
    XCTAssertEqual(vec1.x, vec2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertEqual(vec1.y, vec2.y, accuracy: accuracy, "y", file: file, line: line)
}

func assertNotEqual<T: Equatable & FloatingPoint>(_ vec1: Vector2<T>,
                                                  _ vec2: Vector2<T>,
                                                  accuracy: T,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) {
    
    XCTAssertNotEqual(vec1.x, vec2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertNotEqual(vec1.y, vec2.y, accuracy: accuracy, "y", file: file, line: line)
}

// MARK: SIMD3 equality

func assertEqual<T: Equatable & FloatingPoint>(_ simd1: SIMD3<T>,
                                               _ simd2: SIMD3<T>,
                                               accuracy: T,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
    
    XCTAssertEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
    XCTAssertEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
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
