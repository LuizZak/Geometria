import XCTest
import Geometria

// MARK: FloatingPoint equality

@discardableResult
public func assertEqual<T: FloatingPoint>(
    _ v1: T,
    _ v2: T,
    accuracy: T? = nil,
    _ messagePrefix: @escaping @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    if let accuracy = accuracy {
        XCTAssertEqual(v1, v2, accuracy: accuracy, "\(messagePrefix())", file: file, line: line)

        return v1.isApproximatelyEqual(to: v2, absoluteTolerance: accuracy)
    } else {
        XCTAssertEqual(v1, v2, "\(messagePrefix())", file: file, line: line)

        return v1 == v2
    }
}

// MARK: Vector equality

@discardableResult
public func assertEqual<V: Vector2Type>(
    _ vec1: V,
    _ vec2: V,
    accuracy: V.Scalar,
    messagePrefix: @escaping @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where V.Scalar: FloatingPoint {

    assertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line) &&
    assertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line)
}

@discardableResult
public func assertEqual<V: Vector3Type>(
    _ vec1: V,
    _ vec2: V,
    accuracy: V.Scalar,
    messagePrefix: @escaping @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where V.Scalar: FloatingPoint {

    assertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line) &&
    assertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line) &&
    assertEqual(vec1.z, vec2.z, accuracy: accuracy, "\(messagePrefix())z", file: file, line: line)
}

@discardableResult
public func assertEqual<V: Vector4Type>(
    _ vec1: V,
    _ vec2: V,
    accuracy: V.Scalar,
    messagePrefix: @escaping @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where V.Scalar: FloatingPoint {

    assertEqual(vec1.x, vec2.x, accuracy: accuracy, "\(messagePrefix())x", file: file, line: line) &&
    assertEqual(vec1.y, vec2.y, accuracy: accuracy, "\(messagePrefix())y", file: file, line: line) &&
    assertEqual(vec1.z, vec2.z, accuracy: accuracy, "\(messagePrefix())z", file: file, line: line) &&
    assertEqual(vec1.w, vec2.w, accuracy: accuracy, "\(messagePrefix())w", file: file, line: line)
}

// MARK: FloatingPoint array equality

@discardableResult
public func assertEqual<T>(
    _ values1: [T],
    _ values2: [T],
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    var success = true

    zip(values1, values2).enumerated().forEach { tuple in
        let index = tuple.offset
        let (v1, v2) = tuple.element

        success = assertEqual(v1, v2, accuracy: accuracy, "\(index)", file: file, line: line) && success
    }

    return success
}

// MARK: FloatingPoint tuple equality

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T),
    _ values2: (T, T),
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T),
    _ values2: (T, T),
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line)
}

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T, T),
    _ values2: (T, T, T),
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.2, values2.2, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T, T),
    _ values2: (T, T, T),
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.2, values2.2, "\(values1) != \(values2)", file: file, line: line)
}

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T, T, T),
    _ values2: (T, T, T, T),
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.2, values2.2, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.3, values2.3, accuracy: accuracy, "\(values1) != \(values2)", file: file, line: line)
}

@discardableResult
public func assertEqual<T>(
    _ values1: (T, T, T, T),
    _ values2: (T, T, T, T),
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(values1.0, values2.0, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.1, values2.1, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.2, values2.2, "\(values1) != \(values2)", file: file, line: line) &&
    assertEqual(values1.3, values2.3, "\(values1) != \(values2)", file: file, line: line)
}

// MARK: SIMD3 equality

#if ENABLE_SIMD && canImport(simd)

@discardableResult
public func assertEqual<T>(
    _ simd1: SIMD3<T>,
    _ simd2: SIMD3<T>,
    accuracy: T,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool where T: FloatingPoint {

    assertEqual(simd1.x, simd2.x, accuracy: accuracy, "x", file: file, line: line) &&
    assertEqual(simd1.y, simd2.y, accuracy: accuracy, "y", file: file, line: line) &&
    assertEqual(simd1.z, simd2.z, accuracy: accuracy, "z", file: file, line: line)
}

#endif // #if ENABLE_SIMD && canImport(simd)

// MARK: ClosedShape2Intersection equality

@discardableResult
public func assertEqual<T: Vector2FloatingPoint>(
    _ actual: ClosedShape2Intersection<T>,
    _ expected: ClosedShape2Intersection<T>,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    guard actual != expected else {
        return true
    }

    XCTFail("\(actual) is not equal to \(expected)", file: file, line: line)

    let printPoint: (T) -> String = { point in
        ".init(x: \(point.x), y: \(point.y))"
    }
    let printPointNormal: (PointNormal<T>) -> String = { pn in
        """
            .init(
                point: \(printPoint(pn.point)),
                normal: \(printPoint(pn.normal))
            )
        """
    }
    let printPair: (ClosedShape2Intersection<T>.Pair) -> String = { pair in
        """
            .init(
                enter: \(printPointNormal(pair.enter)),
                exit: \(printPointNormal(pair.exit)),
            )
        """
    }

    var buffer = ""

    switch actual {
    case .contained:
        buffer = ".contained"

    case .contains:
        buffer = ".contains"

    case .noIntersection:
        buffer = ".noIntersection"

    case .singlePoint(let pn):
        buffer = """
        .singlePoint(
        \(printPointNormal(pn))
        )
        """

    case .pairs(let points):
        buffer = """
        .pairs(
        \(points.map(printPair).joined(separator: ",\n"))
        )
        """
    }

    print(buffer)

    return false
}

// MARK: ConvexLineIntersection equality

@discardableResult
public func assertEqual<T: Vector2FloatingPoint>(
    _ actual: ConvexLineIntersection<T>,
    _ expected: ConvexLineIntersection<T>,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    _assertEqual(actual, expected, file: file, line: line) { point -> String in
        ".init(x: \(point.x), y: \(point.y))"
    }
}

@discardableResult
public func assertEqual<T: Vector3FloatingPoint>(
    _ actual: ConvexLineIntersection<T>,
    _ expected: ConvexLineIntersection<T>,
    file: StaticString = #file,
    line: UInt = #line
) -> Bool {

    return _assertEqual(actual, expected, file: file, line: line) { point -> String in
        ".init(x: \(point.x), y: \(point.y), z: \(point.z))"
    }
}

@discardableResult
func _assertEqual<T: VectorFloatingPoint>(
    _ act: ConvexLineIntersection<T>,
    _ exp: ConvexLineIntersection<T>,
    file: StaticString,
    line: UInt,
    printPoint: @escaping (T) -> String
) -> Bool {

    guard act != exp else {
        return true
    }

    XCTFail("\(act) is not equal to \(exp)", file: file, line: line)

    let printPointNormal: (LineIntersectionPointNormal<T>) -> String = { pn in
        """
            .init(
                normalizedMagnitude: \(pn.normalizedMagnitude),
                point: \(printPoint(pn.point)),
                normal: \(printPoint(pn.normal))
            )
        """
    }

    var buffer = ""

    switch act {
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

    return false
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

func padded(_ str: String, _ hasNeg: Bool, count: Int) -> String {
    var pre = ""
    var suf = String(repeating: " ", count: count - str.count)

    if hasNeg && !str.hasPrefix("-") && !suf.isEmpty {
        pre = String(suf.removeLast())
    }

    return "\(pre)\(str)\(suf)"
}
