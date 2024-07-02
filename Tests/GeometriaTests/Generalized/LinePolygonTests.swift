import XCTest
import Geometria
import TestCommons

class LinePolygonTests: XCTestCase {
    typealias LinePolygon = LinePolygon2D

    func testCodable() throws {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
        ])
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(sut)
        let result = try decoder.decode(LinePolygon.self, from: data)

        XCTAssertEqual(sut, result)
    }

    func testEquals() {
        XCTAssertEqual(LinePolygon(), LinePolygon())
        XCTAssertEqual(LinePolygon(vertices: [.init(x: 0, y: 0)]),
                       LinePolygon(vertices: [.init(x: 0, y: 0)]))
    }

    func testUnequals() {
        XCTAssertNotEqual(LinePolygon(vertices: []),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))

        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 999, y: 0)]),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))

        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 0, y: 999)]),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))
    }

    func testHashable() {
        XCTAssertNotEqual(LinePolygon(vertices: []).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)

        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 999, y: 0)]).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)

        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 0, y: 999)]).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)
    }

    func testAddVertex() {
        var sut = LinePolygon(vertices: [])

        sut.addVertex(.init(x: 1, y: 2))
        sut.addVertex(.init(x: 3, y: 5))

        XCTAssertEqual(sut.vertices, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5),
        ])
    }

    func testReverse() {
        var sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
        ])

        sut.reverse()

        XCTAssertEqual(sut.vertices, [
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
            .init(x: 0, y: 0),
        ])
    }

    func testReversed() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
        ])

        let result = sut.reversed()

        XCTAssertEqual(result.vertices, [
            .init(x: 1, y: 1),
            .init(x: 1, y: 0),
            .init(x: 0, y: 0),
        ])
    }
}

// MARK: BoundableType Conformance

extension LinePolygonTests {
    func testBounds() {
        let sut = LinePolygon(vertices: [
            .init(x: -2, y: 3),
            .init(x: 4, y: 1),
            .init(x: 3, y: -4),
        ])

        let result = sut.bounds

        XCTAssertEqual(result.minimum, .init(x: -2, y: -4))
        XCTAssertEqual(result.maximum, .init(x: 4, y: 3))
    }

    func testBounds_empty() {
        let sut = LinePolygon()

        let result = sut.bounds

        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
}

// MARK: VectorFloatingPoint Conformance

extension LinePolygonTests {
    func testAverage_emptyVertices() {
        let sut = LinePolygon(vertices: [])

        XCTAssertEqual(sut.average, .zero)
    }

    func testAverage_singleVertex() {
        let sut = LinePolygon(vertices: [
            .init(x: 1, y: 2),
        ])

        XCTAssertEqual(sut.average, .init(x: 1, y: 2))
    }

    func testAverage_multiVertices() {
        let sut = LinePolygon(vertices: [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5),
            .init(x: 7, y: 11),
            .init(x: 13, y: 17),
        ])

        XCTAssertEqual(sut.average, .init(x: 6, y: 8.75))
    }

    func testProject() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 1),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let test1 = Vector2D(x: 0, y: 0)
        let test2 = Vector2D(x: 1, y: 1)
        let test3 = Vector2D(x: 2, y: 1)
        let test4 = Vector2D(x: 1, y: 1.5)
        let test5 = Vector2D(x: 2.32, y: 2.32)

        TestFixture.beginFixture(sceneScale: 100, renderScale: 50) { fixture in
            fixture.add(sut)

            fixture.assertions(on: test1)
                .assertEquals(sut.project(test1), .init(x: 0.0, y: 0.0))

            fixture.assertions(on: test2)
                .assertEquals(sut.project(test2), .init(x: 1.0, y: 1.0))

            fixture.assertions(on: test3)
                .assertEquals(sut.project(test3), .init(x: 2.0, y: 1.0))

            fixture.assertions(on: test4)
                .assertEquals(sut.project(test4), .init(x: 1.0, y: 1.0))

            fixture.assertions(on: test5)
                .assertEquals(sut.project(test5), .init(x: 2.0, y: 2.0))
        }
    }
}
