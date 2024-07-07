import Geometria
import GeometriaPeriodics

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
}
