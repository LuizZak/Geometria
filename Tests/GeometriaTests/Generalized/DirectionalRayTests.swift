import XCTest
import Geometria

class DirectionalRayTests: XCTestCase {
    typealias DirectionalRay = DirectionalRay2D
    typealias DirectionalRay3 = DirectionalRay3D
    
    func testCodable() throws {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(DirectionalRay.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)),
                       DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 999, y: 2),
                                         direction: .init(x: 3, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 999),
                                         direction: .init(x: 3, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 999, y: 5)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 999)),
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)).hashValue,
                       DirectionalRay(start: .init(x: 1, y: 2),
                                      direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 999, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 999),
                                         direction: .init(x: 3, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 999, y: 5)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 999)).hashValue,
                          DirectionalRay(start: .init(x: 1, y: 2),
                                         direction: .init(x: 3, y: 5)).hashValue)
    }
    
    func testDirection_asUnit() {
        XCTAssertEqual(DirectionalRay(start: .zero,
                                      direction: .init(x: 2, y: 3)).direction,
                       .init(x: 0.5547001962252291, y: 0.8320502943378437))
    }
    
    func testInitWithLine() {
        let sut = DirectionalRay(Line2D(x1: 1, y1: 2, x2: 3, y2: 5))
        
        XCTAssertEqual(sut.start, .init(x: 1, y: 2))
        XCTAssertEqual(sut.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
    }
    
    func testInitWithLine_negativeDirection() {
        let sut = DirectionalRay(Line2D(x1: 1, y1: 1, x2: -1, y2: -1))
        
        XCTAssertEqual(sut.start, .init(x: 1, y: 1))
        XCTAssertEqual(sut.direction, .init(x: -0.7071067811865475, y: -0.7071067811865475))
    }
    
    func testInitWithPoints() {
        let sut = DirectionalRay(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.start, .init(x: 1, y: 2))
        XCTAssertEqual(sut.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
    }
    
    func testInitWithPoints_negativeDirection() {
        let sut = DirectionalRay(a: .init(x: 1, y: 1), b: .init(x: -1, y: -1))
        
        XCTAssertEqual(sut.start, .init(x: 1, y: 1))
        XCTAssertEqual(sut.direction, .init(x: -0.7071067811865475, y: -0.7071067811865475))
    }

    func testCategory() {
        let sut = DirectionalRay(a: .zero, b: .one)

        XCTAssertEqual(sut.category, .ray)
    }
}

// MARK: LineType Conformance

extension DirectionalRayTests {
    func testA() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2), direction: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.a, .init(x: 1, y: 2))
    }
    
    func testB() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2), direction: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
    }
}

// MARK: VectorAdditive Conformance

extension DirectionalRayTests {
    func testAsLine() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
        XCTAssertEqual(result.angle, sut.angle)
    }
    
    func testAsRay() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        
        let result = sut.asRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 1.5144957554275265, y: 2.857492925712544))
        XCTAssertEqual(result.angle, sut.angle)
    }
    
    func testAsIntervalLine() {
        let sut = DirectionalRay(start: .init(x: 1, y: 2),
                                 direction: .init(x: 3, y: 5))
        
        let result = sut.asIntervalLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.direction, .init(x: 0.5144957554275266, y: 0.8574929257125442))
        XCTAssertEqual(result.minimumMagnitude, .zero)
        XCTAssertEqual(result.maximumMagnitude, .infinity)
    }
}

// MARK: LineAdditive Conformance

extension DirectionalRayTests {
    func testOffsetBy() {
        let sut = DirectionalRay(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.lineSlope, sut.lineSlope)
        XCTAssertEqual(result.start, .init(x: 8, y: 13))
        XCTAssertEqual(result.direction, sut.direction)
    }
}

// MARK: LineMultiplicative Conformance

extension DirectionalRayTests {
    func testWithPointsScaledBy() {
        let sut = DirectionalRay(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(result.lineSlope,
                    (sut.lineSlope * factor).normalized(),
                    accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: 7, y: 22))
        XCTAssertEqual(result.direction, .init(x: 0.3905498468561694, y: 0.9205817818752565))
    }
    
    func testWithPointsScaledByAroundCenter() {
        let sut = DirectionalRay(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(result.lineSlope,
                    (sut.lineSlope * factor).normalized(),
                    accuracy: 1e-16)
        XCTAssertEqual(result.start, .init(x: -23, y: 2.0))
        XCTAssertEqual(result.direction, .init(x: 0.3905498468561694, y: 0.9205817818752565))
    }
}

// MARK: LineFloatingPoint Conformance

extension DirectionalRayTests {

    func testNormalizedLineSlope() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 3, y2: 3)

        let result = sut.normalizedLineSlope

        assertEqual(
            result,
            .init(x: 0.7071067811865476, y: 0.7071067811865476),
            accuracy: 1e-16
        )
    }

    func testProjectAsScalar2D() {
        let sut = DirectionalRay(x: 2, y: 1, dx: 3, dy: 2)
        let point = Vector2D(x: 2, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), 0.5547001962252291, accuracy: 1e-12)
    }
    
    func testProjectAsScalar2D_offBounds() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), -2)
    }
    
    func testProjectAsScalar2D_skewed() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), 1.4142135623730951, accuracy: 1e-12)
    }
    
    func testProjectAsScalar3D() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 3, dy: 0, dz: 0)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), 1.0, accuracy: 1e-12)
    }
    
    func testProjectAsScalar3D_offBounds() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 0, dz: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), -3)
    }
    
    func testProjectAsScalar3D_skewed() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), 1.1547005383792515, accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D() {
        let sut = DirectionalRay(x: 2, y: 1, dx: 3, dy: 2)
        let point = Vector2D(x: 2, y: 2)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 2.4615384615384617, y: 1.3076923076923077),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D_parallel() {
        let sut = Line2D(x1: 0, y1: 0, x2: 3, y2: 0)
        let point = Vector2D(x: 1, y: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 1, y: 0),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D_offBounds() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectUnclamped(point), Vector2D(x: -2, y: 0))
    }
    
    func testProjectUnclamped2D_skewed() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 2)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 1, y: 1),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D_skewed_centered() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        let point = Vector2D(x: 0, y: 1)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 0.5, y: 0.5),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_parallel() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 3, dy: 0, dz: 0)
        let point = Vector3D(x: 1, y: 0, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 1, y: 0, z: 0),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_offBounds() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 0, dz: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectUnclamped(point), Vector3D(x: -3, y: 0, z: 0))
    }
    
    func testProjectUnclamped3D_skewed() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_skewed_centered() {
        let sut = DirectionalRay3(x: 0, y: 0, z: 0, dx: 1, dy: 1, dz: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProjectedMagnitude() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 1)
        
        let result = sut.projectedMagnitude(10)
        
        assertEqual(result,
                    .init(x: 7.071067811865475, y: 7.071067811865475),
                    accuracy: 1e-12)
    }
    
    func testContainsProjectedNormalizedMagnitude() {
        let sut = DirectionalRay(x: 0, y: 0, dx: 1, dy: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(.infinity))
    }
    
    func testContainsProjectedNormalizedMagnitude_returnsFalseForNaN() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.nan))
    }
    
    func testClampProjectedNormalizedMagnitude() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 2)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), .infinity)
    }

    func testClampedAsIntervalLine_2D() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 2)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -10,
            maximumNormalizedMagnitude: 20
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 8.94427190999916, y: 17.88854381999832),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), 20.0, accuracy: 1e-14)
        XCTAssertEqual(result.length, 20.0, accuracy: 1e-14)
    }
    
    func testClampedAsIntervalLine_2D_openStart() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 2)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: .infinity,
            maximumNormalizedMagnitude: 20
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 8.94427190999916, y: 17.88854381999832),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), 20.0, accuracy: 1e-14)
        XCTAssertEqual(result.length, 20.0, accuracy: 1e-14)
    }
    
    func testClampedAsIntervalLine_2D_openEnd() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 2)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: 20,
            maximumNormalizedMagnitude: .infinity
        )

        assertEqual(
            result.a,
            Vector2D(x: 8.94427190999916, y: 17.88854381999832),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 9.391485505499118, y: 18.782971010998235),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 20.0, accuracy: 1e-16)
        XCTAssertEqual(result.length, .infinity)
    }

    func testClampedAsIntervalLine_2D_invalidClamp() {
        let sut = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 2)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -10,
            maximumNormalizedMagnitude: -5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), 0.0, accuracy: 1e-16)
        XCTAssertEqual(result.length, 0.0, accuracy: 1e-15)
    }

}
