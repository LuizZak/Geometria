import XCTest
import Geometria

// MARK: Vector2 equality

func assertEqual<T>(_ vec1: Vector2<T>,
                    _ vec2: Vector2<T>,
                    accuracy: T,
                    messagePrefix: @escaping @autoclosure () -> String = "",
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line)
    XCTAssertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
}

func assertNotEqual<T>(_ vec1: Vector2<T>,
                       _ vec2: Vector2<T>,
                       accuracy: T,
                       messagePrefix: @escaping @autoclosure () -> String = "",
                       file: StaticString = #file,
                       line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertNotEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line)
    XCTAssertNotEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
}

// MARK: Double array equality

func assertEqual<T>(_ values1: [T],
                    _ values2: [T],
                    accuracy: T,
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    zip(values1, values2).enumerated().forEach { tuple in
        let index = tuple.offset
        let (v1, v2) = tuple.element
        
        XCTAssertEqual(v1, v2, accuracy: accuracy, "\(index)", file: file, line: line)
    }
}

// MARK: SIMD3 equality

func assertEqual<T>(_ simd1: SIMD3<T>,
                    _ simd2: SIMD3<T>,
                    accuracy: T,
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
    XCTAssertEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
}

func assertNotEqual<T>(_ simd1: SIMD3<T>,
                       _ simd2: SIMD3<T>,
                       accuracy: T,
                       file: StaticString = #file,
                       line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertNotEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line)
    XCTAssertNotEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line)
    XCTAssertNotEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
}
