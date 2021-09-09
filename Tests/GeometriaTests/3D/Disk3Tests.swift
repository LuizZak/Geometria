import XCTest
import Geometria

class Disk3Tests: XCTestCase {
    typealias Vector = Vector3D
    typealias Disk = Disk3<Vector>
    typealias Line = Line3<Vector>
    typealias LineSegment = LineSegment3<Vector>
    typealias Ray = Ray3<Vector>
    typealias DirectionalRay = DirectionalRay3<Vector>
    
    func testEquatable() {
        let diff = 9.0
        
        XCTAssertEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: diff, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: diff, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: diff),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: diff, y: 5, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: diff, z: 6),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: diff),
                 radius: 1)
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1),
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: diff)
        )
    }
    
    func testHashable() {
        let diff = 9.0
        
        XCTAssertEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: diff, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: diff, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: diff),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: diff, y: 5, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: diff, z: 6),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: diff),
                 radius: 1).hashValue
        )
        XCTAssertNotEqual(
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: 1).hashValue,
            Disk(center: .init(x: 1, y: 2, z: 3),
                 normal: .init(x: 4, y: 5, z: 6),
                 radius: diff).hashValue
        )
    }
}

// MARK: BoundableType Conformance

extension Disk3Tests {
    func testBounds_alignedDisk_zPlane() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0), normal: .unitZ, radius: 3)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -3, z: 0))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 3, z: 0))
    }
    
    func testBounds_alignedDisk_xPlane() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0), normal: .unitX, radius: 3)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 0, y: -3, z: -3))
        XCTAssertEqual(result.maximum, .init(x: 0, y: 3, z: 3))
    }
    
    func testBounds_alignedDisk_yPlane() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0), normal: .unitY, radius: 3)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: 0, z: -3))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 0, z: 3))
    }
    
    func testBounds_alignedDisk_slanted() {
        let sut = Disk(center: .init(x: 1, y: 2, z: 3), normal: .one, radius: 3)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -1.4494897427831779, y: -0.12132034355964283, z: 0.8786796564403572))
        XCTAssertEqual(result.maximum, .init(x: 3.449489742783178, y: 4.121320343559643, z: 5.121320343559643))
    }
}

// MARK: PointProjectableType Conformance

extension Disk3Tests {
    func testProject_vectorWithinRadius_returnsProjection() {
        let sut = Disk(center: .init(x: 1, y: 2, z: 3),
                       normal: .init(x: 2, y: 2, z: 2),
                       radius: 10)
        let point = Vector3D(x: 3, y: 4, z: 7)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 0.3333333333333326, y: 1.3333333333333326, z: 4.333333333333333))
    }
    
    func testProject_vectorOutsideOfRadius_returnsVectorOnRadius() {
        let sut = Disk(center: .init(x: 1, y: 2, z: 3),
                       normal: .unitZ,
                       radius: 5)
        let point = Vector3D(x: -10, y: -10, z: 10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 4.378623142586731, y: 5.685770701003707, z: 3))
    }
}

// MARK: LineIntersectablePlaneType Conformance

extension Disk3Tests {
    // MARK: Radius Intersection Check
    
    func testUnclampedNormalMagnitudeForIntersection_radiusCheck() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 2)
        let line1 = Line(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        let line2 = Line(x1: -6, y1: -6, z1: 3, x2: -5, y2: -5, z2: 2)
        
        let result1 = sut.unclampedNormalMagnitudeForIntersection(with: line1)
        let result2 = sut.unclampedNormalMagnitudeForIntersection(with: line2)
        
        XCTAssertEqual(result1, 3.0)
        XCTAssertNil(result2)
    }
    
    func testIntersection_radiusCheck() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 2)
        let line1 = Line(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        let line2 = Line(x1: -6, y1: -6, z1: 3, x2: -5, y2: -5, z2: 2)
        
        let result1 = sut.intersection(with: line1)
        let result2 = sut.intersection(with: line2)
        
        XCTAssertNotNil(result1)
        XCTAssertNil(result2)
    }
    
    // MARK: Line - Disk intersection
    
    func testUnclampedNormalMagnitudeForIntersection_line() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_negativeMagnitude() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: -2, y1: -2, z1: 2, x2: -3, y2: -3, z2: 3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_parallel() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 1, y2: 0, z2: 1)
        
        XCTAssertNil(sut.unclampedNormalMagnitudeForIntersection(with: line))
    }
    
    // MARK: Ray - Disk intersection
    
    func testUnclampedNormalMagnitudeForIntersection_ray() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Ray(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_ray_negativeMagnitude() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Ray(x1: -2, y1: -2, z1: 2, x2: -3, y2: -3, z2: 3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    // MARK: Vector
    
    // MARK: Line - Disk intersection
    
    func testIntersection_line() throws {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: 0, y: 0, z: 0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_line_negativeMagnitude() throws {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: 0.0, y: 0.0, z: 0.0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_line_parallel() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 0, y2: 0, z2: 1)
        
        XCTAssertNil(sut.intersection(with: line))
    }
    
    // MARK: Ray - Disk intersection
    
    func testIntersection_ray() throws {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Ray(x1: -3, y1: -3, z1: 3, x2: -2, y2: -2, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: 0.0, y: 0.0, z: 0.0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_ray_negativeMagnitude() {
        let sut = Disk(center: .init(x: 0, y: 0, z: 0),
                       normal: .init(x: 0, y: 0, z: 1),
                       radius: 1)
        let line = Ray(x1: -2, y1: -2, z1: -2, x2: -3, y2: -3, z2: -3)
        
        XCTAssertNil(sut.intersection(with: line))
    }
}
