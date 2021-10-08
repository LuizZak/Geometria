import XCTest
import Geometria

class Torus3Tests: XCTestCase {
    typealias Torus = Torus3D

    func testEquatable() {
        let diff = 9.0

        XCTAssertEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )

        XCTAssertNotEqual(
            Torus(center: .init(x: diff, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: diff, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: diff), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: diff, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: diff, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: diff), 
                  majorTorus: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: diff, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: diff),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8)
        )
    }
    
    func testHashable() {
        let diff = 9.0

        XCTAssertEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )

        XCTAssertNotEqual(
            Torus(center: .init(x: diff, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: diff, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: diff), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: diff, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: diff, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: diff), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: diff, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: diff).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorTorus: 7, 
                  minorRadius: 8).hashValue
        )
    }
}
