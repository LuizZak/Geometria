import XCTest
import Geometria

class Torus3Tests: XCTestCase {
    typealias Torus = Torus3D

    func testEquatable() {
        let diff = 9.0

        XCTAssertEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )

        XCTAssertNotEqual(
            Torus(center: .init(x: diff, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: diff, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: diff), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: diff, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: diff, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: diff), 
                  majorRadius: 7, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: diff, 
                  minorRadius: 8),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: diff),
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8)
        )
    }
    
    func testHashable() {
        let diff = 9.0

        XCTAssertEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )

        XCTAssertNotEqual(
            Torus(center: .init(x: diff, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: diff, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: diff), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: diff, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: diff, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: diff), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: diff, 
                  minorRadius: 8).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
        XCTAssertNotEqual(
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: diff).hashValue,
            Torus(center: .init(x: 1, y: 2, z: 3), 
                  axis: .init(x: 4, y: 5, z: 6), 
                  majorRadius: 7, 
                  minorRadius: 8).hashValue
        )
    }
}

// MARK: BoundableType Conformance

extension Torus3Tests {
    func testBounds_xyAxisAlignedTorus() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )

        let result = sut.bounds

        XCTAssertEqual(
            result,
            AABB(
                minimum: .init(x: -25, y: -25, z: -5),
                maximum: .init(x: 25, y: 25, z: 5)
            )
        )
    }

    func testBounds_xyAxisAlignedTorus_offCenter() {
        let sut = Torus(
            center: .init(x: 1, y: 2, z: 3),
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )

        let result = sut.bounds

        XCTAssertEqual(
            result,
            AABB(
                minimum: .init(x: -24, y: -23, z: -2),
                maximum: .init(x: 26, y: 27, z: 8)
            )
        )
    }
    
    func testBounds_tiltedTorus() {
        let sut = Torus(
            center: .zero,
            axis: .init(x: 1, y: 1, z: 1),
            majorRadius: 20,
            minorRadius: 5
        )

        let result = sut.bounds

        XCTAssertEqual(
            result,
            AABB(
                minimum: .init(x: -23.299165869141277, y: -20.564420875611816, z: -20.564420875611816),
                maximum: .init(x: 23.299165869141277, y: 20.564420875611816, z: 20.564420875611816)
            )
        )
    }

    func testBounds_majorRadiusZero() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 0,
            minorRadius: 10
        )

        let result = sut.bounds

        XCTAssertEqual(
            result,
            AABB(
                minimum: .init(x: -10, y: -10, z: -10),
                maximum: .init(x: 10, y: 10, z: 10)
            )
        )
    }
}
