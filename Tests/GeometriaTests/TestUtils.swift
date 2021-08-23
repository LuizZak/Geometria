import XCTest
import Geometria

// MARK: Vector2 equality

func assertEqual<V: Vector2Type>(_ vec1: V,
                                 _ vec2: V,
                                 accuracy: V.Scalar,
                                 messagePrefix: @escaping @autoclosure () -> String = "",
                                 file: StaticString = #file,
                                 line: UInt = #line) where V.Scalar: FloatingPoint {
    
    XCTAssertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line)
    XCTAssertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
}

func assertEqual<V: Vector3Type>(_ vec1: V,
                                 _ vec2: V,
                                 accuracy: V.Scalar,
                                 messagePrefix: @escaping @autoclosure () -> String = "",
                                 file: StaticString = #file,
                                 line: UInt = #line) where V.Scalar: FloatingPoint {
    
    XCTAssertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line)
    XCTAssertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
    XCTAssertEqual(vec1.z, vec2.z, accuracy: accuracy, "\(messagePrefix())z", file: file, line: line)
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
