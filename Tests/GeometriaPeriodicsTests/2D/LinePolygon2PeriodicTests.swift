import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class LinePolygon2PeriodicTests: XCTestCase {
    typealias Sut = LinePolygon2Periodic<Vector2D>

    func testEphemeral() {
        let sut = Sut.makeStar()

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.printVisualization()
        }
    }
}
