import XCTest
import Geometria

class LineFloatingPointTests: XCTestCase {
    typealias Line = Line2D
    typealias Line3 = Line3D
    
    // MARK: VectorFloatingPoint Conformance
    
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
