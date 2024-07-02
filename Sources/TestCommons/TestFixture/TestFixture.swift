import XCTest
import Geometria

/// A test fixture class that allows simultaneous test assertions along with
/// generations of visualizations that can be displayed on a [p5.js] sketch.
///
/// [p5.js]: https://editor.p5js.org/
public class TestFixture {
    private let p5Printer: P5Printer
    private var didFail: Bool = false

    public init(sceneScale: Double, renderScale: Double) {
        p5Printer = P5Printer(scale: sceneScale, renderScale: renderScale)
        p5Printer.shouldStartDebugMode = true
        p5Printer.drawGrid = true
    }

    public func printVisualization() {
        p5Printer.printAll()
    }

    // MARK: Visualization add

    public func add<T: VisualizableGeometricType2>(_ geometry: T?, file: StaticString = #file, line: UInt = #line) {
        geometry?.addVisualization2D(to: p5Printer, style: nil, file: file, line: line)
    }

    public func add<T: VisualizableGeometricType3>(_ geometry: T?, file: StaticString = #file, line: UInt = #line) {
        geometry?.addVisualization3D(to: p5Printer, style: nil, file: file, line: line)
    }

    // MARK: Wrapped assertions

    public func assertions<T: VisualizableGeometricType2>(
        on visualizable: T,
        file: StaticString = #file,
        line: UInt = #line
    ) -> AssertionWrapper2<T> {
        .init(fixture: self, value: visualizable, file: file, line: line)
    }

    public func assertions<T: VisualizableGeometricType3>(
        on visualizable: T,
        file: StaticString = #file,
        line: UInt = #line
    ) -> AssertionWrapper3<T> {
        .init(fixture: self, value: visualizable, file: file, line: line)
    }

    // MARK: General assertions

    public func assertEquals<T: Equatable>(
        _ actual: T,
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        XCTAssertEqual(actual, expected, file: file, line: line)

        didFail = actual != expected || didFail
    }

    public func assertTrue(
        _ actual: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        XCTAssertTrue(actual, file: file, line: line)
        let failed = actual != true

        didFail = failed || didFail
    }

    public func assertFalse(
        _ actual: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        XCTAssertFalse(actual, file: file, line: line)
        let failed = actual != false

        didFail = failed || didFail
    }

    // MARK: General geometric assertions

    public func assertEquals<T: VisualizableGeometricType2 & Equatable>(
        _ actual: T,
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if actual != expected {
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    public func assertEquals<T: VisualizableGeometricType3 & Equatable>(
        _ actual: T,
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if actual != expected {
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    public func assertEquals<T: VisualizableGeometricType2 & Equatable>(
        _ actual: T?,
        _ expected: T?,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        if let actual = actual {
            actual.addVisualization2D(to: p5Printer, style: resultStyle())

            if actual != expected, let expected = expected {
                expected.addVisualization2D(to: p5Printer, style: expectedStyle())
            }
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    public func assertEquals<T: VisualizableGeometricType3 & Equatable>(
        _ actual: T?,
        _ expected: T?,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        if let actual = actual {
            actual.addVisualization3D(to: p5Printer, style: resultStyle())

            if actual != expected, let expected = expected {
                expected.addVisualization3D(to: p5Printer, style: expectedStyle())
            }
        }

        XCTAssertEqual(actual, expected, file: file, line: line)
        didFail = actual != expected || didFail
    }

    public func assertEquals<T: VisualizableGeometricType2 & Equatable>(
        _ actual: [T],
        _ expected: [T],
        file: StaticString = #file,
        line: UInt = #line
    ) {

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

    public func assertEquals<T: VisualizableGeometricType3 & Equatable>(
        _ actual: [T],
        _ expected: [T],
        file: StaticString = #file,
        line: UInt = #line
    ) {

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

    public func assertEquals<T: VisualizableGeometricType2 & Vector2Type & Equatable>(
        _ actual: T,
        _ expected: T,
        accuracy: T.Scalar,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        actual.addVisualization2D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    public func assertEquals<T: VisualizableGeometricType3 & Vector3Type & Equatable>(
        _ actual: T,
        _ expected: T,
        accuracy: T.Scalar,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        actual.addVisualization3D(to: p5Printer, style: resultStyle())

        if actual != expected {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle())
            XCTFail("\(actual) != \(expected)", file: file, line: line)
        }
    }

    // MARK: FloatingPoint vectors

    public func assertEquals<T: VisualizableGeometricType2 & Vector2Type>(
        _ actual: T,
        _ expected: T,
        accuracy: T.Scalar,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: FloatingPoint {

        actual.addVisualization2D(to: p5Printer, style: resultStyle(), file: file, line: line)

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle(), file: file, line: line)
        }
    }

    public func assertEquals<T: VisualizableGeometricType3 & Vector3Type>(
        _ actual: T,
        _ expected: T,
        accuracy: T.Scalar,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: FloatingPoint {

        actual.addVisualization3D(to: p5Printer, style: resultStyle(), file: file, line: line)

        if !assertEqual(actual, expected, accuracy: accuracy, file: file, line: line) {
            didFail = true
            expected.addVisualization3D(to: p5Printer, style: expectedStyle(), file: file, line: line)
        }
    }

    // MARK: Intersections

    public func assertEquals<T: Vector2Type & VisualizableGeometricType2>(
        _ actual: ClosedShape2Intersection<T>,
        _ expected: ClosedShape2Intersection<T>,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: Numeric & CustomStringConvertible {

        actual.addVisualization2D(to: p5Printer, style: resultStyle(), file: file, line: line)

        if !assertEqual(actual, expected, file: file, line: line) {
            didFail = true
            expected.addVisualization2D(to: p5Printer, style: expectedStyle(), file: file, line: line)
        }
    }

    private func resultStyle() -> P5Printer.Style {
        .init(strokeColor: .green, fillColor: nil, strokeWeight: 2)
    }

    private func expectedStyle() -> P5Printer.Style {
        .init(strokeColor: .red, fillColor: nil, strokeWeight: 2)
    }

    @discardableResult
    public static func beginFixture(
        sceneScale: Double = 2.0,
        renderScale: Double = 1.0,
        _ closure: (TestFixture) throws -> Void
    ) rethrows -> TestFixture {

        let fixture = TestFixture(sceneScale: sceneScale, renderScale: renderScale)

        try closure(fixture)

        if fixture.didFail {
            fixture.printVisualization()
        }

        return fixture
    }

    public class AssertionWrapperBase<T>: AssertionWrapperType {
        public let fixture: TestFixture
        public let value: T
        var hasVisualized: Bool = false
        var file: StaticString, line: UInt

        internal init(fixture: TestFixture, value: T, file: StaticString, line: UInt) {
            self.fixture = fixture
            self.value = value
            self.file = file
            self.line = line
        }

        public final func visualize() {
            guard !hasVisualized else {
                return
            }
            hasVisualized = true

            addVisualization()
        }

        public func addVisualization() {
            fatalError("Must be overridden by subclasses")
        }
    }

    public class AssertionWrapper2<T: VisualizableGeometricType2>: AssertionWrapperBase<T> {
        public override func addVisualization() {
            value.addVisualization2D(to: fixture.p5Printer, style: nil, file: file, line: line)
        }
    }

    public class AssertionWrapper3<T: VisualizableGeometricType3>: AssertionWrapperBase<T> {
        public override func addVisualization() {
            value.addVisualization3D(to: fixture.p5Printer, style: nil, file: file, line: line)
        }
    }
}

public protocol AssertionWrapperType {
    associatedtype Value

    var fixture: TestFixture { get }
    var value: Value { get }

    func visualize()
}

/// Protocol for 2D geometric types that can be visualized in a p5.js sketch.
public protocol VisualizableGeometricType2 {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString, line: UInt)
}

public extension VisualizableGeometricType2 {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        addVisualization2D(to: printer, style: style, file: file, line: line)
    }

    func addVisualization2D(to printer: P5Printer, file: StaticString = #file, line: UInt = #line) {
        addVisualization2D(to: printer, style: nil, file: file, line: line)
    }
}

/// Protocol for 3D geometric types that can be visualized in a p5.js sketch.
public protocol VisualizableGeometricType3 {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString, line: UInt)
}

public extension VisualizableGeometricType3 {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        addVisualization3D(to: printer, style: style, file: file, line: line)
    }

    func addVisualization3D(to printer: P5Printer, file: StaticString = #file, line: UInt = #line) {
        addVisualization3D(to: printer, style: nil, file: file, line: line)
    }
}
