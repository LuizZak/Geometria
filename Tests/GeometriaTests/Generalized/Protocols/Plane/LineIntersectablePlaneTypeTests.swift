import XCTest
import Geometria

class LineIntersectablePlaneTypeTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Plane = PointNormalPlane3<Vector>
    typealias Line = Line3<Vector>
    typealias LineSegment = LineSegment3<Vector>
    typealias Ray = Ray3<Vector>
    typealias DirectionalRay = DirectionalRay3<Vector>
    
    // MARK: Line - Plane intersection

    func testUnclampedNormalMagnitudeForIntersection_line() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_negativeMagnitude() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_parallel() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 1, y2: 0, z2: 1)
        
        XCTAssertNil(sut.unclampedNormalMagnitudeForIntersection(with: line))
    }
    
    // MARK: Ray - Plane intersection
    
    func testUnclampedNormalMagnitudeForIntersection_ray() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Ray(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_ray_negativeMagnitude() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Ray(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    // MARK: Vector
    
    // MARK: Line - Plane intersection

    func testIntersection_line() throws {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(
            result,
            .init(x: 3.0, y: 3.0, z: 0),
            accuracy: 1e-15
        )
    }
    
    func testIntersection_line_negativeMagnitude() throws {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(
            result,
            .init(x: -2.0, y: -2.0, z: 0.0),
            accuracy: 1e-15
        )
    }
    
    func testIntersection_line_parallel() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 0, y2: 0, z2: 1)
        
        XCTAssertNil(sut.intersection(with: line))
    }
    
    // MARK: Ray - Plane intersection
    
    func testIntersection_ray() throws {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Ray(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(
            result,
            .init(x: 3.0, y: 3.0, z: 0.0),
            accuracy: 1e-15
        )
    }
    
    func testIntersection_ray_negativeMagnitude() {
        let sut = Plane(
            point: .init(x: 0, y: 0, z: 0),
            normal: .init(x: 0, y: 0, z: 1)
        )
        let line = Ray(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        XCTAssertNil(sut.intersection(with: line))
    }
}
