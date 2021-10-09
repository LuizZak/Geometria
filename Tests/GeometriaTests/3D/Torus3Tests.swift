import XCTest
import Geometria

class Torus3Tests: XCTestCase {
    typealias Vector = Vector3D
    typealias Torus = Torus3<Vector>

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
            axis: .one,
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

    

    func testBounds_minorRadiusZero() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 10,
            minorRadius: 0
        )

        let result = sut.bounds

        XCTAssertEqual(
            result,
            AABB(
                minimum: .init(x: -10, y: -10, z: 0),
                maximum: .init(x: 10, y: 10, z: 0)
            )
        )
    }
}

extension Torus3Tests {
    func testContains_pointOnTubeCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 20, y: 0, z: 0)

        XCTAssertTrue(sut.contains(point))
    }

    func testContains_pointOnCenter_degenerateTorus() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 0,
            minorRadius: 5
        )
        let point = Vector(x: 0, y: 0, z: 0)

        XCTAssertTrue(sut.contains(point))
    }

    func testContains_tiltedTorus_pointInTube() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 15, z: 45)

        XCTAssertTrue(sut.contains(point))
    }

    func testContains_pointOusideOfBounds() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 30, y: 30, z: 15)

        XCTAssertFalse(sut.contains(point))
    }

    func testContains_pointOnCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 0, y: 0, z: 0)

        XCTAssertFalse(sut.contains(point))
    }
}
