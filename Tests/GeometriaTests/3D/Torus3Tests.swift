import XCTest
import Geometria

class Torus3Tests: XCTestCase {
    let accuracy = 1e-16
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

// MARK: VolumetricType Conformance

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

    func testContains_pointOnCenter_majorRadiusLessThanMinorRadius() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 4,
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
        let point = Vector(x: 5, y: 9.22, z: 43.4)

        XCTAssertTrue(sut.contains(point))
    }

    func testContains_tiltedTorus_pointOutsideTube() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 17, z: 43)

        XCTAssertFalse(sut.contains(point))
    }

    func testContains_pointOutsideOfBounds() {
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

// MARK: PointProjectableType Conformance

extension Torus3Tests {
    func testProject_pointOutsideTorus() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 30, y: 30, z: 5)

        let result = sut.project(point)

        assertEqual(result, .init(x: 17.592944348069327, y: 17.592944348069327, z: 1.0880433337235615), accuracy: accuracy)
    }

    func testProject_pointInTube() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 23, y: 0, z: 1)

        let result = sut.project(point)

        assertEqual(result, .init(x: 24.74341649025257, y: 0.0, z: 1.5811388300841898), accuracy: accuracy)
    }

    func testProject_pointInsideMajorRadius() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 0, z: 5)

        let result = sut.project(point)

        assertEqual(result, .init(x: 15.256583509747431, y: 0.0, z: 1.5811388300841898), accuracy: accuracy)
    }

    func testProject_pointOnTubeCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 20, y: 0, z: 0)

        let result = sut.project(point)

        assertEqual(result, .init(x: 25.0, y: 0.0, z: 0.0), accuracy: accuracy)
    }

    func testProject_pointOnCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 0, y: 0, z: 0)

        let result = sut.project(point)

        assertEqual(result, .init(x: -15.0, y: 0.0, z: 0.0), accuracy: accuracy)
    }

    func testProject_tiltedTorus() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 17, z: 43)

        let result = sut.project(point)

        assertEqual(result, .init(x: 3.843224223335116, y: 16.063316446105986, z: 43.824054228272956), accuracy: accuracy)
    }

    func testProject_tiltedTorus_pointInTube() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 9.22, z: 43.4)

        let result = sut.project(point)

        assertEqual(result, .init(x: 4.7217654385894265, y: 9.61053532781247, z: 40.99280938985172), accuracy: accuracy)
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension Torus3Tests {
    func testSignedDistance_pointOutsideTorus() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 30, y: 30, z: 5)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, 26.75606231793161, accuracy: accuracy)
    }

    func testSignedDistance_pointInTube() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 23, y: 0, z: 1)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, -1.9782711335573246, accuracy: accuracy)
    }

    func testSignedDistance_pointInsideMajorRadius() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 0, z: 5)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, 7.9289321881345245, accuracy: accuracy)
    }

    func testSignedDistance_pointOnTubeCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 20, y: 0, z: 0)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, -5.0, accuracy: accuracy)
    }

    func testSignedDistance_pointOnCenter() {
        let sut = Torus(
            center: .zero,
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 0, y: 0, z: 0)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, 15.0, accuracy: accuracy)
    }

    func testSignedDistance_offCenterTorus_pointInTube() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 30, y: 20, z: 30)

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, -5.0, accuracy: accuracy)
    }

    func testSignedDistance_offCenterTorus_pointOnCenter() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .unitZ,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = sut.center

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, 15.0, accuracy: accuracy)
    }

    func testSignedDistance_tiltedTorus_pointInTube() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = Vector(x: 5, y: 9.22, z: 43.4)

        let result = sut.signedDistance(to: point)

        print(sut.axis.cross(.unitZ))

        XCTAssertEqual(result, -2.887474488316567, accuracy: accuracy)
    }

    func testSignedDistance_tiltedTorus_pointOnCenter() {
        let sut = Torus(
            center: .init(x: 10, y: 20, z: 30),
            axis: .one,
            majorRadius: 20,
            minorRadius: 5
        )
        let point = sut.center

        let result = sut.signedDistance(to: point)

        XCTAssertEqual(result, 15.0, accuracy: accuracy)
    }
}
