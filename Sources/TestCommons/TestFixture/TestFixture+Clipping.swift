import MiniP5Printer
import Geometria
import GeometriaClipping
import XCTest

public extension TestFixture {
    func add<T: ParametricClip2Geometry>(
        _ value: T,
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    func add<Vector>(
        _ value: Parametric2Contour<Vector>,
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Vector.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    func add<Vector>(
        _ value: [Parametric2GeometrySimplex<Vector>],
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Vector.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    func add<Vector>(
        _ value: Parametric2GeometrySimplex<Vector>,
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Vector.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    func add<Vector>(
        _ value: Circle2Parametric<Vector>,
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Vector.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    func add<Vector>(
        _ value: LinePolygon2Parametric<Vector>,
        category: String,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where Vector.Scalar: CustomStringConvertible {

        self.p5Printer.add(value, category: category, style: style, file: file, line: line)
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        category: String,
        intersections: [ParametricClip2Intersection<T1.Scalar>],
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Vector == T2.Vector, T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {

        for intersection in intersections {
            self.add(t1, t2, category: category, intersection: intersection, style: style, file: file, line: line)
        }
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        category: String,
        intersection: ParametricClip2Intersection<T1.Scalar>,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Vector == T2.Vector, T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        add(t1, t2, category: category, intersections: intersection.periods, style: style, file: file, line: line)
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        category: String,
        intersections: [(`self`: T1.Scalar, `other`: T1.Scalar)],
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Vector == T2.Vector, T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        for intersection in intersections {
            self.add(t1, t2, category: category, intersection: intersection, style: style, file: file, line: line)
        }
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        category: String,
        intersection: (`self`: T1.Scalar, `other`: T1.Scalar),
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Vector == T2.Vector, T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        self.add(t1, category: category, intersectionAt: intersection.`self`, style: style, file: file, line: line)
        self.add(t2, category: category, intersectionAt: intersection.`other`, style: style, file: file, line: line)
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T: ParametricClip2Geometry>(
        _ geometry: T,
        category: String,
        intersectionAt: T.Period,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: CustomStringConvertible {
        self.p5Printer.add(geometry, intersectionAt: intersectionAt, category: category, style: style, file: file, line: line)
    }

    @discardableResult
    func assertEquals<Period: FloatingPoint>(
        _ actual: (`self`: Period, other: Period),
        _ expected: (`self`: Period, other: Period),
        accuracy: Period = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        guard assertEquals(actual.`self`, expected.`self`, accuracy: accuracy, message(), file: file, line: line) else {
            return false
        }
        guard assertEquals(actual.other, expected.other, accuracy: accuracy, message(), file: file, line: line) else {
            return false
        }

        return true
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: LineSegment2Simplex<Vector>,
        _ expected: LineSegment2Simplex<Vector>,
        accuracy: Vector.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        return assertEquals(actual.lineSegment.start, expected.lineSegment.start, accuracy: accuracy, message(), file: file, line: line)
            && assertEquals(actual.lineSegment.end, expected.lineSegment.end, accuracy: accuracy, message(), file: file, line: line)
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: CircleArc2Simplex<Vector>,
        _ expected: CircleArc2Simplex<Vector>,
        accuracy: Vector.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        return assertEquals(actual.circleArc.center, expected.circleArc.center, accuracy: accuracy, file: file, line: line)
            && assertEquals(actual.circleArc.radius, expected.circleArc.radius, accuracy: accuracy, file: file, line: line)
            && assertEquals(actual.circleArc.startAngle, expected.circleArc.startAngle, accuracy: accuracy, file: file, line: line)
            && assertEquals(actual.circleArc.sweepAngle, expected.circleArc.sweepAngle, accuracy: accuracy, file: file, line: line)
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: Parametric2GeometrySimplex<Vector>,
        _ expected: Parametric2GeometrySimplex<Vector>,
        accuracy: Vector.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        if !assertEquals(actual.startPeriod, expected.startPeriod, accuracy: accuracy, message(), file: file, line: line) {
            return false
        }

        if !assertEquals(actual.endPeriod, expected.endPeriod, accuracy: accuracy, message(), file: file, line: line) {
            return false
        }

        switch (actual, expected) {
        case (.lineSegment2(let lhs), .lineSegment2(let rhs)):
            return assertEquals(lhs, rhs, accuracy: accuracy, message(), file: file, line: line)

        case (.circleArc2(let lhs), .circleArc2(let rhs)):
            return assertEquals(lhs, rhs, accuracy: accuracy, message(), file: file, line: line)

        default:
            failure("\(message()) \(actual) != \(expected)".trimmingCharacters(in: .whitespaces), file: file, line: line)
            return false
        }
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: [Parametric2GeometrySimplex<Vector>],
        accuracy: Vector.Scalar = .infinity,
        _ expected: [Parametric2GeometrySimplex<Vector>],
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        if actual.count != expected.count {
            failure("\(message()) \(actual) != \(expected)".trimmingCharacters(in: .whitespaces), file: file, line: line)
            return false
        }

        for (i, (actual, expected)) in zip(actual, expected).enumerated() {
            if !assertEquals(actual, expected, accuracy: accuracy, "[\(i)] \(message())", file: file, line: line) {
                return false
            }
        }

        return true
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: Parametric2Contour<Vector>,
        _ expected: Parametric2Contour<Vector>,
        accuracy: Vector.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        if !assertEquals(actual.startPeriod, expected.startPeriod, accuracy: accuracy, message(), file: file, line: line) {
            return false
        }

        if !assertEquals(actual.endPeriod, expected.endPeriod, accuracy: accuracy, message(), file: file, line: line) {
            return false
        }

        return assertEquals(
            actual.allSimplexes(),
            accuracy: accuracy,
            expected.allSimplexes(),
            message(),
            file: file,
            line: line
        )
    }

    @discardableResult
    func assertEquals<Vector>(
        _ actual: [Parametric2Contour<Vector>],
        accuracy: Vector.Scalar = .infinity,
        _ expected: [Parametric2Contour<Vector>],
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        if actual.count != expected.count {
            failure("\(message()) \(actual) != \(expected)".trimmingCharacters(in: .whitespaces), file: file, line: line)
            return false
        }

        for (i, (actual, expected)) in zip(actual, expected).enumerated() {
            if !assertEquals(actual, expected, "[\(i)] \(message())", file: file, line: line) {
                return false
            }
        }

        return true
    }

    @discardableResult
    func assertEquals<T: FloatingPoint>(
        _ actual: [(`self`: T, other: T)],
        _ expected: [(`self`: T, other: T)],
        accuracy: T = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        if actual.count != expected.count {
            failure("\(message()) \(actual) != \(expected)".trimmingCharacters(in: .whitespaces), file: file, line: line)
            return false
        }

        for (i, (actual, expected)) in zip(actual, expected).enumerated() {
            assertEquals(actual, expected, accuracy: accuracy, file: file, line: line)
            if !assertEquals(actual, expected, "[\(i)] \(message())", file: file, line: line) {
                return false
            }
        }

        return true
    }

    @discardableResult
    func assertEquals<Period>(
        _ actual: ParametricClip2Intersection<Period>,
        _ expected: ParametricClip2Intersection<Period>,
        accuracy: Period = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool where Period: FloatingPoint {

        return assertEquals(actual.periods, expected.periods, accuracy: accuracy, file: file, line: line)
    }

    @discardableResult
    func assertEquals<Period>(
        _ actual: [ParametricClip2Intersection<Period>],
        _ expected: [ParametricClip2Intersection<Period>],
        accuracy: Period = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool where Period: FloatingPoint {

        if actual.count != expected.count {
            failure("\(message()) \(actual) != \(expected)".trimmingCharacters(in: .whitespaces), file: file, line: line)
            return false
        }

        for (i, (actual, expected)) in zip(actual, expected).enumerated() {
            if !assertEquals(actual, expected, accuracy: accuracy, "[\(i)] \(message())", file: file, line: line) {
                return false
            }
        }

        return true
    }
}

public extension TestFixture.AssertionWrapperBase where T: ParametricClip2Geometry, T.Scalar: CustomStringConvertible {
    @discardableResult
    func assertContains(
        _ point: T.Vector,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self where T.Vector: VisualizableGeometricType2 {
        if !value.contains(point) {
            fixture.add(value, category: "input", file: file, line: line)

            fixture.add(point, file: file, line: line)

            fixture.failure(
                "Expected geometry to contain point @ \(point)",
                file: file,
                line: line
            )
        }

        return self
    }

    @discardableResult
    func assertDoesNotContain(
        _ point: T.Vector,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self where T.Vector: VisualizableGeometricType2 {
        if value.contains(point) {
            fixture.add(value, category: "input", file: file, line: line)

            fixture.add(point, file: file, line: line)

            fixture.failure(
                "Expected geometry to not contain point @ \(point)",
                file: file,
                line: line
            )
        }

        return self
    }

    @discardableResult
    func assertContours(
        accuracy: T.Scalar,
        _ expected: [T.Contour],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        let actual = value.allContours()
        if !fixture.assertEquals(actual, accuracy: accuracy, expected, file: file, line: line) {
            fixture.p5Printer.add(actual, category: "result", file: file, line: line)
            fixture.p5Printer.add(expected, category: "result", file: file, line: line)

            return false
        }

        return true
    }

    @discardableResult
    func assertSimplexes(
        accuracy: T.Scalar,
        _ expected: [T.Simplex],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        let actual = value.allContours().flatMap { $0.allSimplexes() }
        if !fixture.assertEquals(actual, accuracy: accuracy, expected, file: file, line: line) {
            fixture.p5Printer.add(actual, category: "result", file: file, line: line)
            fixture.p5Printer.add(expected, category: "result", file: file, line: line)

            return false
        }

        return true
    }

    func assertIntersections<T2: ParametricClip2Geometry>(
        _ other: T2,
        accuracy: T.Scalar,
        tolerance: T.Period = T.Period.leastNonzeroMagnitude,
        _ expected: [ParametricClip2Intersection<T.Scalar>],
        file: StaticString = #file,
        line: UInt = #line
    ) where T2.Vector == T.Vector, T.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {

        /* TODO: Re-implement
        let actual = value.allIntersectionPeriods(
            other,
            tolerance: tolerance
        )

        if !fixture.assertEquals(actual, expected, accuracy: accuracy, file: file, line: line) {
            visualize()
            fixture.add(other, file: file, line: line)

            fixture.add(value, other, intersections: actual, style: fixture.resultStyle().with(\.fillColor, .green))
            fixture.add(value, other, intersections: expected, style: fixture.expectedStyle().with(\.fillColor, .red))
        }
        */
    }
}

public extension TestFixture.AssertionWrapperBase where T: Boolean2Parametric, T.Scalar: CustomStringConvertible {
    func assertAllContours(
        accuracy: T.Scalar = .infinity,
        _ expected: [T.Contour],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let actual = value.allContours()

        func reportFailure() {
            visualize()

            for actual in actual {
                fixture.p5Printer.add(actual, category: "result", style: fixture.resultStyle(), file: file, line: line)
            }
            for expected in expected {
                fixture.p5Printer.add(expected, category: "expected", style: fixture.expectedStyle(), file: file, line: line)
            }
        }

        guard actual.count == expected.count else {
            fixture.failure("\(actual) != \(expected)", file: file, line: line)
            return reportFailure()
        }

        for (lhs, rhs) in zip(actual, expected) {
            if !fixture.assertEquals(lhs, rhs, accuracy: accuracy, file: file, line: line) {
                return reportFailure()
            }
        }
    }

    func assertAllSimplexes(
        accuracy: T.Scalar = .infinity,
        _ expected: [[T.Simplex]],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let actual = value.allContours().map { $0.allSimplexes() }

        func reportFailure() {
            visualize()

            for actual in actual {
                fixture.p5Printer.add(actual, category: "result", style: fixture.resultStyle(), file: file, line: line)
            }
            for expected in expected {
                fixture.p5Printer.add(expected, category: "expected", style: fixture.expectedStyle(), file: file, line: line)
            }
        }

        guard actual.count == expected.count else {
            fixture.failure("\(actual) != \(expected)", file: file, line: line)
            return reportFailure()
        }

        for (lhs, rhs) in zip(actual, expected) {
            if !fixture.assertEquals(lhs, accuracy: accuracy, rhs, file: file, line: line) {
                return reportFailure()
            }
        }
    }

    /*
    func assertAllSimplexesString(
        bufferWidth: Int,
        bufferHeight: Int,
        translation: Vector2D,
        scale: Vector2D,
        _ expectedBuffer: String,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Vector == Vector2D {
        let actual = value.allSimplexes()
        let bufferString = StringBufferConsolePrintTarget()
        let buffer = ConsolePrintBuffer(target: bufferString, bufferWidth: bufferWidth, bufferHeight: bufferHeight)
        buffer.diffingPrint = false

        buffer.printSimplexesList(actual, translation: translation, scale: scale)

        buffer.print(trimming: false)

        if bufferString.buffer != expectedBuffer {
            /*
            visualize()

            for actual in actual {
                fixture.add(actual, style: fixture.resultStyle(), file: file, line: line)
            }
            */

            XCTAssertEqual(bufferString.buffer, expectedBuffer, file: file, line: line)
        }
    }
    */
}
