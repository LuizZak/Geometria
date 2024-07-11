import MiniP5Printer
import Geometria
import GeometriaClipping
import XCTest

public extension TestFixture {
    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        intersections: [ParametricClip2Intersection<T1, T2>],
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        for intersection in intersections {
            self.add(t1, t2, intersection: intersection, style: style, file: file, line: line)
        }
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        intersection: ParametricClip2Intersection<T1, T2>,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        add(t1, t2, intersections: intersection.periods, style: style, file: file, line: line)
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        intersections: [(`self`: T1.Period, `other`: T2.Period)],
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        for intersection in intersections {
            self.add(t1, t2, intersection: intersection, style: style, file: file, line: line)
        }
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ t1: T1,
        _ t2: T2,
        intersection: (`self`: T1.Period, `other`: T2.Period),
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T1.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {
        self.add(t1, intersectionAt: intersection.`self`, style: style, file: file, line: line)
        self.add(t2, intersectionAt: intersection.`other`, style: style, file: file, line: line)
    }

    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T: ParametricClip2Geometry>(
        _ geometry: T,
        intersectionAt: T.Period,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: CustomStringConvertible {
        self.p5Printer.add(geometry, intersectionAt: intersectionAt, style: style, file: file, line: line)
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

        if !assertEquals(actual.startPeriod, expected.startPeriod, accuracy: accuracy, message()) {
            return false
        }

        if !assertEquals(actual.endPeriod, expected.endPeriod, accuracy: accuracy, message()) {
            return false
        }

        switch (actual, expected) {
        case (.lineSegment2(let lhs), .lineSegment2(let rhs)):
            return assertEquals(lhs, rhs, message(), file: file, line: line)

        case (.circleArc2(let lhs), .circleArc2(let rhs)):
            return assertEquals(lhs, rhs, message(), file: file, line: line)

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
    func assertEquals<T1, T2>(
        _ actual: ParametricClip2Intersection<T1, T2>,
        _ expected: ParametricClip2Intersection<T1, T2>,
        accuracy: T1.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool where T1.Scalar: FloatingPoint {

        return assertEquals(actual.periods, expected.periods, accuracy: accuracy, file: file, line: line)
    }

    @discardableResult
    func assertEquals<T1, T2>(
        _ actual: [ParametricClip2Intersection<T1, T2>],
        _ expected: [ParametricClip2Intersection<T1, T2>],
        accuracy: T1.Scalar = .infinity,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool where T1.Scalar: FloatingPoint {

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
            visualize()

            fixture.add(point)

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
            visualize()

            fixture.add(point)

            fixture.failure(
                "Expected geometry to not contain point @ \(point)",
                file: file,
                line: line
            )
        }

        return self
    }

    @discardableResult
    func assertSimplexes(
        accuracy: T.Scalar,
        _ expected: [T.Simplex],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Bool {

        let actual = value.allSimplexes()
        if !fixture.assertEquals(actual, accuracy: accuracy, expected, file: file, line: line) {
            fixture.add(actual)
            fixture.add(expected)

            return false
        }

        return true
    }

    func assertIntersections<T2: ParametricClip2Geometry>(
        _ other: T2,
        accuracy: T.Scalar,
        tolerance: T.Period = T.Period.leastNonzeroMagnitude,
        _ expected: [ParametricClip2Intersection<T, T2>],
        file: StaticString = #file,
        line: UInt = #line
    ) where T2: VisualizableGeometricType2, T2.Vector == T.Vector, T.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {

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
    }
}

public extension TestFixture.AssertionWrapperBase where T: Boolean2Parametric, T.Scalar: CustomStringConvertible {
    func assertAllSimplexes(
        accuracy: T.Scalar = .infinity,
        _ expected: [[T.Simplex]],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let actual = value.allSimplexes()

        func reportFailure() {
            visualize()

            for actual in actual {
                fixture.add(actual, style: fixture.resultStyle(), file: file, line: line)
            }
            for expected in expected {
                fixture.add(expected, style: fixture.expectedStyle(), file: file, line: line)
            }
        }

        guard actual.count == expected.count else {
            fixture.failure("\(actual) != \(expected)", file: file, line: line)
            return reportFailure()
        }

        for (lhs, rhs) in zip(actual, expected) {
            if !fixture.assertEquals(lhs, rhs, file: file, line: line) {
                return reportFailure()
            }
        }
    }

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
}
