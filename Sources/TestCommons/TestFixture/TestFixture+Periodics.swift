import MiniP5Printer
import Geometria
import GeometriaPeriodics
import XCTest

public extension TestFixture {
    /// - note: Adds only the intersections, and not the geometries themselves.
    func add<T1: Periodic2Geometry, T2: Periodic2Geometry>(
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
    func add<T1: Periodic2Geometry, T2: Periodic2Geometry>(
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
    func add<T: Periodic2Geometry>(
        _ geometry: T,
        intersectionAt: T.Period,
        style: P5Printer.Style? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Scalar: CustomStringConvertible {
        self.p5Printer.add(geometry, intersectionAt: intersectionAt, style: style, file: file, line: line)
    }
}

public extension TestFixture.AssertionWrapperBase where T: Periodic2Geometry, T.Scalar: CustomStringConvertible {
    func assertSimplexes(
        _ expected: [T.Simplex],
        file: StaticString = #file,
        line: UInt = #line
    ) {

        let actual = value.allSimplexes()
        if actual != expected {
            fixture.add(actual)
            fixture.add(expected)

            assertEquals(actual, expected, file: file, line: line)
        }
    }

    func assertIntersections<T2: Periodic2Geometry>(
        _ other: T2,
        tolerance: T.Period = T.Period.leastNonzeroMagnitude,
        _ expected: [(`self`: T.Period, `other`: T2.Period)],
        file: StaticString = #file,
        line: UInt = #line
    ) where T2: VisualizableGeometricType2, T2.Vector == T.Vector, T.Scalar: CustomStringConvertible, T2.Scalar: CustomStringConvertible {

        let actual = value.allIntersectionPeriods(
            other,
            tolerance: tolerance
        )

        if !actual.elementsEqual(expected, by: ==) {
            visualize()
            fixture.add(other, file: file, line: line)

            fixture.add(value, other, intersections: actual, style: fixture.resultStyle().with(\.fillColor, .green))
            fixture.add(value, other, intersections: expected, style: fixture.expectedStyle().with(\.fillColor, .red))

            fixture.failure("\(actual) != \(expected)", file: file, line: line)
        }
    }
}

public extension TestFixture.AssertionWrapperBase where T: Boolean2Periodic, T.Scalar: CustomStringConvertible {
    func assertAllSimplexes(
        _ expected: [[T.Simplex]],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let actual = value.allSimplexes()

        if actual != expected {
            visualize()

            for actual in actual {
                fixture.add(actual, style: fixture.resultStyle(), file: file, line: line)
            }
            for expected in expected {
                fixture.add(expected, style: fixture.expectedStyle(), file: file, line: line)
            }

            fixture.failure("\(actual) != \(expected)", file: file, line: line)
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
