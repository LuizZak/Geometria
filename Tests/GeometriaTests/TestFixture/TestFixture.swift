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

    func add<T: VisualizableGeometricType>(_ geometry: T?) {
        geometry?.addVisualization(to: p5Printer)
    }

    // MARK: General assertions

    func assertEquals<T: Equatable>(_ actual: T, _ expected: T, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(actual, expected, file: file, line: line)

        didFail = actual != expected || didFail
    }

    // MARK: General geometric assertions

    func assertEquals<T: VisualizableGeometricType & Equatable>(_ actual: T, _ expected: T, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization(to: p5Printer, style: resultStyle())

        if actual != expected {
            expected.addVisualization(to: p5Printer, style: expectedStyle())
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    func assertEquals<T: VisualizableGeometricType & Equatable>(_ actual: T?, _ expected: T?, file: StaticString = #file, line: UInt = #line) {
        if let actual = actual {
            actual.addVisualization(to: p5Printer, style: resultStyle())

            if actual != expected, let expected = expected {
                expected.addVisualization(to: p5Printer, style: expectedStyle())
            }
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    // MARK: Vectors

    func assertEquals<T: VisualizableGeometricType & Vector2Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    func assertEquals<T: VisualizableGeometricType & Vector3Type & Equatable>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) {
        actual.addVisualization(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    // MARK: FloatingPoint vectors

    func assertEquals<T: VisualizableGeometricType & Vector2Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization(to: p5Printer, style: expectedStyle())
        }
    }

    func assertEquals<T: VisualizableGeometricType & Vector3Type>(_ actual: T, _ expected: T, accuracy: T.Scalar, file: StaticString = #file, line: UInt = #line) where T.Scalar: FloatingPoint {
        actual.addVisualization(to: p5Printer, style: resultStyle())

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization(to: p5Printer, style: expectedStyle())
        }
    }

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

/// Protocol for geometric types that can be visualized in a p5.js sketch.
protocol VisualizableGeometricType {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?)
}

extension VisualizableGeometricType {
    func addVisualization(to printer: P5Printer) {
        addVisualization(to: printer, style: nil)
    }
}
