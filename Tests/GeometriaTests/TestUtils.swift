import XCTest
import Geometria

// MARK: Vector equality

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

func assertEqual<V: Vector4Type>(_ vec1: V,
                                 _ vec2: V,
                                 accuracy: V.Scalar,
                                 messagePrefix: @escaping @autoclosure () -> String = "",
                                 file: StaticString = #file,
                                 line: UInt = #line) where V.Scalar: FloatingPoint {
    
    XCTAssertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line)
    XCTAssertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
    XCTAssertEqual(vec1.z, vec2.z, accuracy: accuracy, "\(messagePrefix())z", file: file, line: line)
    XCTAssertEqual(vec1.w, vec2.w, accuracy: accuracy, "\(messagePrefix())w", file: file, line: line)
}

// MARK: FloatingPoint array equality

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

// MARK: FloatingPoint tuple equality

func assertEqual<T>(_ values1: (T, T),
                    _ values2: (T, T),
                    accuracy: T,
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

func assertEqual<T>(_ values1: (T, T),
                    _ values2: (T, T),
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line)
}

func assertEqual<T>(_ values1: (T, T, T),
                    _ values2: (T, T, T),
                    accuracy: T,
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.2, values2.2, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

func assertEqual<T>(_ values1: (T, T, T),
                    _ values2: (T, T, T),
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.2, values2.2, "\(values1) != \(values2)", file: file, line: line)
}

func assertEqual<T>(_ values1: (T, T, T, T),
                    _ values2: (T, T, T, T),
                    accuracy: T,
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.2, values2.2, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.3, values2.3, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

func assertEqual<T>(_ values1: (T, T, T, T),
                    _ values2: (T, T, T, T),
                    file: StaticString = #file,
                    line: UInt = #line) where T: FloatingPoint {
    
    XCTAssertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.2, values2.2, "\(values1) != \(values2)", file: file, line: line)
    XCTAssertEqual(values1.3, values2.3, "\(values1) != \(values2)", file: file, line: line)
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

// MARK: ConvexLineIntersection equality

func assertEqual<T: Vector2FloatingPoint>(_ expected: ConvexLineIntersection<T>,
                                          _ actual: ConvexLineIntersection<T>,
                                          file: StaticString = #file,
                                          line: UInt = #line) {
    
    _assertEqual(expected, actual, file: file, line: line) { point -> String in
        ".init(x: \(point.x), y: \(point.y))"
    }
}

func assertEqual<T: Vector3FloatingPoint>(_ expected: ConvexLineIntersection<T>,
                                          _ actual: ConvexLineIntersection<T>,
                                          file: StaticString = #file,
                                          line: UInt = #line) {
    
    _assertEqual(expected, actual, file: file, line: line) { point -> String in
        ".init(x: \(point.x), y: \(point.y), z: \(point.z))"
    }
}

func _assertEqual<T: VectorFloatingPoint>(_ exp: ConvexLineIntersection<T>,
                                          _ act: ConvexLineIntersection<T>,
                                          file: StaticString,
                                          line: UInt,
                                          printPoint: @escaping (T) -> String) {
    
    guard exp != act else {
        return
    }
    
    XCTFail("\(exp) is not equal to \(act)", file: file, line: line)
    
    let printPointNormal: (PointNormal<T>) -> String = { pn in
        """
            .init(
                point: \(printPoint(pn.point)),
                normal: \(printPoint(pn.normal))
            )
        """
    }
    
    var buffer = ""
    
    switch exp {
    case .contained:
        buffer = ".contained"
    case .noIntersection:
        buffer = ".noIntersection"
    case .enter(let pn):
        buffer = """
        .enter(
        \(printPointNormal(pn))
        )
        """
    case .exit(let pn):
        buffer = """
        .exit(
        \(printPointNormal(pn))
        )
        """
    case .singlePoint(let pn):
        buffer = """
        .singlePoint(
        \(printPointNormal(pn))
        )
        """
    case let .enterExit(enter, exit):
        buffer = """
        .enterExit(
        \(printPointNormal(enter)),
        \(printPointNormal(exit))
        )
        """
    }
    
    print(buffer)
}

func padded(_ str: String, _ hasNeg: Bool, count: Int) -> String {
    var pre = ""
    var suf = String(repeating: " ", count: count - str.count)
    
    if hasNeg && !str.hasPrefix("-") && !suf.isEmpty {
        pre = String(suf.removeLast())
    }

    return "\(pre)\(str)\(suf)"
}

func printAssertMatrix<Matrix: MatrixType>(_ matrix: Matrix) where Matrix.Scalar: CustomStringConvertible {
    func value(_ col: Int, _ row: Int) -> String {
        matrix[col, row].description
    }

    let matrix = matrix
    var hasNegCol: [Bool] = []
    var lenCol: [Int] = []
    
    for col in 0..<matrix.columnCount {
        var hasNegative = false
        var maxLength = 0
        for row in 0..<matrix.rowCount {
            hasNegative = hasNegative || matrix[col, row] < 0
        }

        hasNegCol.append(hasNegative)

        for row in 0..<matrix.rowCount {
            var length = value(col, row).count
            if hasNegative && matrix[col, row] >= 0 {
                length += 1
            }

            maxLength = max(maxLength, length)
        }
        
        lenCol.append(maxLength)
    }

    for row in 0..<matrix.rowCount {
        var args: [String] = []
        for col in 0..<matrix.columnCount {
            args.append(
                padded(value(col, row), hasNegCol[col], count: lenCol[col])
            )
        }

        print("        assertEqual(sut.r\(row), (\(args.joined(separator: ", "))))")
    }
}
