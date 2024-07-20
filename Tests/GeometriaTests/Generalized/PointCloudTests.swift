import XCTest

@testable import Geometria

class PointCloudTests: XCTestCase {
    typealias Sut = PointCloud<Vector2D>

    func testTranslatedBy() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 3.0, y: -11.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 2.0, y: 3.0),
            ]
        )

        let result = sut.translated(by: .init(x: 50, y: -25))

        XCTAssertEqual(result.points, [
            .init(x: 47.0, y: -23.0),
            .init(x: 56.0, y: -20.0),
            .init(x: 53.0, y: -36.0),
            .init(x: 42.0, y: -18.0),
            .init(x: 52.0, y: -22.0),
        ])
    }

    func testBounds() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
                .init(x: 3.0, y: -11.0),
                .init(x: -8.0, y: 7.0),
                .init(x: 2.0, y: 3.0),
            ]
        )

        XCTAssertEqual(
            sut.bounds,
            .init(minimum: .init(x: -8.0, y: -11.0), maximum: .init(x: 6.0, y: 7.0))
        )
    }

    func testScaledBy() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
            ]
        )

        let result = sut.scaled(by: .init(x: 0.5, y: 2.0))

        XCTAssertEqual(result.points, [
            .init(x: -1.5, y: 4.0),
            .init(x: 3.0, y: 10.0),
        ])
    }

    func testScaledByAround() {
        let sut = Sut(
            points: [
                .init(x: -3.0, y: 2.0),
                .init(x: 6.0, y: 5.0),
            ]
        )

        let result = sut.scaled(by: .init(x: 0.5, y: 2.0), around: .init(x: -3.0, y: 5.0))

        XCTAssertEqual(result.points, [
            .init(x: -3.0, y: -1.0),
            .init(x: 1.5, y: 5.0),
        ])
    }
}
