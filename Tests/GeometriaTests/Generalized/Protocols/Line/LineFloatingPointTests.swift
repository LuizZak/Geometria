import XCTest
import Geometria

class LineFloatingPointTests: XCTestCase {
    typealias IntervalLine = IntervalLine2D
    typealias IntervalLine3 = IntervalLine3D
    typealias Line = Line2D
    typealias Line3 = Line3D
    typealias LineSegment = LineSegment2D
    typealias LineSegment3 = LineSegment3D
    typealias DirectionalRay = DirectionalRay2D
    typealias DirectionalRay3 = DirectionalRay3D
    typealias Ray = Ray2D
    typealias Ray3 = Ray3D
    
    // MARK: VectorFloatingPoint Conformance

    func testNormalizedLineSlope() {
        let sut = Line(x1: 0, y1: 0, x2: 3, y2: 3)

        let result = sut.normalizedLineSlope

        assertEqual(
            result,
            .init(x: 0.7071067811865476, y: 0.7071067811865476),
            accuracy: 1e-16
        )
    }
    
    func testProjectAsScalar2D() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), 0.5, accuracy: 1e-12)
    }
    
    func testProjectAsScalar2D_offBounds() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), -2)
    }
    
    func testProjectAsScalar2D_skewed() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.projectAsScalar(point), 1, accuracy: 1e-12)
    }
    
    func testProjectAsScalar3D() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), 0.3333333333333333, accuracy: 1e-12)
    }
    
    func testProjectAsScalar3D_offBounds() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), -3)
    }
    
    func testProjectAsScalar3D_skewed() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        XCTAssertEqual(sut.projectAsScalar(point), 0.6666666666666666, accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 2.5, y: 1.5),
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
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectUnclamped(point), Vector2D(x: -2, y: 0))
    }
    
    func testProjectUnclamped2D_skewed() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 1, y: 1),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped2D_skewed_centered() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector2D(x: 0.5, y: 0.5),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_parallel() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 0, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 1, y: 0, z: 0),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_offBounds() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectUnclamped(point), Vector3D(x: -3, y: 0, z: 0))
    }
    
    func testProjectUnclamped3D_skewed() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProjectUnclamped3D_skewed_centered() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        assertEqual(sut.projectUnclamped(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }

    func testProjectedMagnitude() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)

        assertEqual(sut.projectedMagnitude(10),
                    Vector2D(x: 9.071067811865476, y: 8.071067811865476),
                    accuracy: 1e-12)
    }

    func testProjectedNormalizedMagnitude() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)

        assertEqual(sut.projectedNormalizedMagnitude(0.5),
                    Vector2D(x: 2.5, y: 1.5),
                    accuracy: 1e-12)
    }

    // MARK: - clampedAsIntervalLine(minimumNormalizedMagnitude:maximumNormalizedMagnitude:)

    func testClampedAsIntervalLine_directionalRay_2D() {
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

    func testClampedAsIntervalLine_directionalRay_2D_invalidClamp() {
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

    func testClampedAsIntervalLine_lineSegment_2D() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1,
            maximumNormalizedMagnitude: 0.5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 5.0, y: 10.0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), sut.length / 2.0, accuracy: 1e-14)
        XCTAssertEqual(result.length, sut.length / 2.0, accuracy: 1e-16)
    }

    func testClampedAsIntervalLine_lineSegment_2D_wholeSegment() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1.0,
            maximumNormalizedMagnitude: 2.0
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 10.0, y: 20.0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), sut.length, accuracy: 1e-14)
        XCTAssertEqual(result.length, sut.length, accuracy: 1e-16)
    }

    func testClampedAsIntervalLine_lineSegment_2D_invalidClamp() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1.0,
            maximumNormalizedMagnitude: -0.5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-50
        )
        assertEqual(
            result.b,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-50
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-50)
        XCTAssertEqual(sut.a.distance(to: result.b), 0.0, accuracy: 1e-50)
        XCTAssertEqual(result.length, 0.0, accuracy: 1e-50)
    }
    
    // MARK: -
    
    func testDistanceSquaredTo2D() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = LineSegment3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.6666666666666667, accuracy: 1e-15)
    }
    
    func testDistanceTo2D() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastStart() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastEnd() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.distance(to: point), 1.4142135623730951, accuracy: 1e-15)
    }
    
    func testDistanceTo3D() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
    
    func testSignedDistance_line() {
        let sut = Line3(x1:  1, y1: 2, z1: 3,
                        x2: 10, y2: 2, z2: 3)
        
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 2, z: 3)), 0.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: -5, y: 0, z: 0)), 3.605551275463989)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 0, z: 0)), 3.605551275463989)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: 15, y: 0, z: 0)), 3.605551275463989)
    }
    
    func testSignedDistance_ray() {
        let sut = Ray3D(x1: 1, y1: 2, z1: 3,
                        x2: 2, y2: 2, z2: 3)
        
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 2, z: 3)), 0.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: -5, y: 0, z: 0)), 7.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 0, z: 0)), 3.605551275463989)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: 15, y: 0, z: 0)), 3.605551275463989)
    }
    
    func testSignedDistance_directionalRay() {
        let sut = DirectionalRay3D(x1: 1, y1: 2, z1: 3,
                                   x2: 2, y2: 2, z2: 3)
        
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 2, z: 3)), 0.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: -5, y: 0, z: 0)), 7.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 0, z: 0)), 3.605551275463989)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: 15, y: 0, z: 0)), 3.605551275463989)
    }
    
    func testSignedDistance_lineSegment() {
        let sut = LineSegment3D(x1:  1, y1: 2, z1: 3,
                                x2: 10, y2: 2, z2: 3)
        
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 2, z: 3)), 0.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: -5, y: 0, z: 0)), 7.0)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x:  5, y: 0, z: 0)), 3.605551275463989)
        XCTAssertEqual(sut.signedDistance(to: Vector3D(x: 15, y: 0, z: 0)), 6.164414002968976)
    }
}
