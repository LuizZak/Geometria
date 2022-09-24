import XCTest

@testable import Geometria

/// A test fixture class that allows simultaneous test assertions along with
/// generations of visualizations that can be displayed on a [p5.js] sketch.
///
/// [p5.js]: https://editor.p5js.org/
class TestFixture {
    private let p5Printer: P5Printer
    private var didFail: Bool = false

    init(sceneScale: Double, renderScale: Double) {
        p5Printer = P5Printer(scale: sceneScale, renderScale: renderScale)
        p5Printer.shouldStartDebugMode = true
    }

    func printVisualization() {
        p5Printer.printAll()
    }

    // MARK: Visualization add

    func add<T: Visualizable2DGeometricType>(_ geometry: T?) {
        geometry?.addVisualization2D(to: p5Printer)
    }

    func add<T: Visualizable3DGeometricType>(_ geometry: T?) {
        geometry?.addVisualization3D(to: p5Printer)
    }

    // MARK: General assertions

    func assertEquals<T: Equatable>(_ actual: T, _ expected: T, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(actual, expected, file: file, line: line)

        didFail = actual != expected || didFail
    }

    // MARK: General geometric assertions

    // 2D

    func assertEquals<T: Visualizable2DGeometricType & Equatable>(_ actual: T, _ expected: T, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if actual != expected {
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    func assertEquals<T: Visualizable2DGeometricType & Equatable>(_ actual: T?, _ expected: T?, file: StaticString = #file, line: UInt = #line) {
        if let actual = actual {
            actual.addVisualization2D(to: p5Printer, style: resultStyle())

            if actual != expected, let expected = expected {
                expected.addVisualization2D(to: p5Printer, style: expectedStyle())
            }
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }
    
    func assertEquals<T: Visualizable2DGeometricType & Equatable>(_ actual: [T], _ expected: [T], file: StaticString = #file, line: UInt = #line) {
        for (act, exp) in zip(actual, expected) {
            assertEquals(act, exp, file: file, line: line)
        }

        XCTAssertEqual(
            actual.count,
            expected.count,
            "Expected result to have \(expected.count) elements but found \(actual)",
            file: file,
            line: line
        )

        didFail = actual.count != expected.count || didFail
    }


    // 3D

    func assertEquals<T: Visualizable3DGeometricType & Equatable>(_ actual: T, _ expected: T, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if actual != expected {
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    func assertEquals<T: Visualizable3DGeometricType & Equatable>(_ actual: T?, _ expected: T?, file: StaticString = #file, line: UInt = #line) {
        if let actual = actual {
            actual.addVisualization3D(to: p5Printer, style: resultStyle())

            if actual != expected, let expected = expected {
                expected.addVisualization3D(to: p5Printer, style: expectedStyle())
            }
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }
    
    func assertEquals<T: Visualizable3DGeometricType & Equatable>(_ actual: [T], _ expected: [T], file: StaticString = #file, line: UInt = #line) {
        for (act, exp) in zip(actual, expected) {
            assertEquals(act, exp, file: file, line: line)
        }

        XCTAssertEqual(
            actual.count,
            expected.count,
            "Expected result to have \(expected.count) elements but found \(actual)",
            file: file,
            line: line
        )

        didFail = actual.count != expected.count || didFail
    }

    // MARK: Vectors

    // 2D

    func assertEquals<T: Visualizable2DGeometricType & Vector2Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    func assertEquals<T: Visualizable2DGeometricType & Vector3Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    // 3D

    func assertEquals<T: Visualizable3DGeometricType & Vector2Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    func assertEquals<T: Visualizable3DGeometricType & Vector3Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    // MARK: FloatingPoint vectors

    // 2D

    func assertEquals<T: Visualizable2DGeometricType & Vector2Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
        }
    }

    func assertEquals<T: Visualizable2DGeometricType & Vector3Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
        }
    }

    // 3D

    func assertEquals<T: Visualizable3DGeometricType & Vector2Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
        }
    }

    func assertEquals<T: Visualizable3DGeometricType & Vector3Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
        }
    }

    // MARK: -

    private func resultStyle() -> P5Printer.Style {
        .init(strokeColor: .green, fillColor: .green, strokeWeight: 2)
    }

    private func expectedStyle() -> P5Printer.Style {
        .init(strokeColor: .red, fillColor: .red, strokeWeight: 2)
    }

    @discardableResult
    static func beginFixture(sceneScale: Double = 2.0, renderScale: Double = 1.0, _ closure: (TestFixture) throws -> Void) rethrows -> TestFixture {
        let fixture = TestFixture(sceneScale: sceneScale, renderScale: renderScale)

        try closure(fixture)

        if fixture.didFail {
            fixture.printVisualization()
        }

        return fixture
    }
}

/// Protocol for 3D geometric types that can be visualized in a p5.js sketch.
protocol Visualizable3DGeometricType {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?)
}

extension Visualizable3DGeometricType {
    func addVisualization3D(to printer: P5Printer) {
        addVisualization3D(to: printer, style: nil)
    }
}

/// Protocol for 2D geometric types that can be visualized in a p5.js sketch.
protocol Visualizable2DGeometricType {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?)
}

extension Visualizable2DGeometricType {
    func addVisualization2D(to printer: P5Printer) {
        addVisualization2D(to: printer, style: nil)
    }
}
