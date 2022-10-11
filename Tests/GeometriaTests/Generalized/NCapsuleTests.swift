import XCTest
import Geometria

class NCapsuleTests: XCTestCase {
    typealias Stadium = NCapsule<Vector2D>
    typealias Capsule = NCapsule<Vector3D>
    
    func testAsLine() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 3, y: 5),
            radius: 1
        )
        
        let result = sut.asLineSegment
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.end, .init(x: 3, y: 5))
    }
    
    func testIsValid() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 1, y: 3),
            radius: 1
        )
        
        XCTAssertTrue(sut.isValid)
    }
    
    func testIsValid_zeroLengthStadium_returnsTrue() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 1, y: 2),
            radius: 1
        )
        
        XCTAssertTrue(sut.isValid)
    }
    
    func testIsValid_zeroRadiusStadium_returnsFalse() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 1, y: 2),
            radius: 0
        )
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_negativeRadiusStadium_returnsFalse() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 1, y: 2),
            radius: -4
        )
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testStartAsSphere() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 29, y: 31),
            radius: 5
        )
        
        let result = sut.startAsSphere
        
        XCTAssertEqual(result.center, .init(x: 1, y: 2))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testEndAsSphere() {
        let sut = Stadium(
            start: .init(x: 1, y: 2),
            end: .init(x: 29, y: 31),
            radius: 5
        )
        
        let result = sut.endAsSphere
        
        XCTAssertEqual(result.center, .init(x: 29, y: 31))
        XCTAssertEqual(result.radius, 5)
    }
}

// MARK: BoundableType Conformance

extension NCapsuleTests {
    func testBounds_zeroLength_returnsRadiusBounds() {
        let sut = Stadium(
            start: .one,
            end: .one,
            radius: 3
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -2, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 4, y: 4))
    }
    
    func testBounds_unitLengthStadium() {
        let sut = Stadium(
            start: .zero,
            end: .unitY,
            radius: 1
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -1, y: -1))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 2))
    }
    
    func testBounds_verticalStadium() {
        let sut = Stadium(
            start: .zero,
            end: .unitY * 20,
            radius: 3
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -3))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 23))
    }
    
    func testBounds_skewedStadium() {
        let sut = Stadium(
            start: .init(x: -2, y: 0),
            end: .init(x: 3, y: 5),
            radius: 4
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -6.0, y: -4.0))
        XCTAssertEqual(result.maximum, .init(x: 7.0, y: 9.0))
    }
}

// MARK: VolumetricType Conformance

extension NCapsuleTests {
    func testContains_withinLineProjection_returnsTrue() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 29),
            radius: 3
        )
        
        XCTAssertTrue(sut.contains(x: 12, y: 20))
        XCTAssertTrue(sut.contains(x: 14, y: 20))
    }
    
    func testContains_outOfBounds_returnsFalse() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 29),
            radius: 3
        )
        
        XCTAssertFalse(sut.contains(.init(x: 9, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 17, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 13)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 33)))
    }
    
    func testContains_withinLineDistanceAtEnds_returnsTrue() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 29),
            radius: 3
        )
        
        XCTAssertTrue(sut.contains(x: 12, y: 16))
        XCTAssertTrue(sut.contains(x: 14, y: 30))
    }
    
    func testContains_equalStartEnd_withinLineProjection_returnsTrue() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 17),
            radius: 3
        )
        
        XCTAssertTrue(sut.contains(x: 12, y: 17))
        XCTAssertTrue(sut.contains(x: 14, y: 17))
    }
    
    func testContains_equalStartEnd_outOfBounds_returnsFalse() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 17),
            radius: 3
        )
        
        XCTAssertFalse(sut.contains(.init(x: 9, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 17, y: 20)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 13)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 33)))
    }
    
    func testContains_equalStartEnd_withinLineDistanceAtEnds_returnsTrue() {
        let sut = Stadium(
            start: .init(x: 13, y: 17),
            end: .init(x: 13, y: 17),
            radius: 3
        )
        
        XCTAssertTrue(sut.contains(x: 12, y: 16))
        XCTAssertTrue(sut.contains(x: 14, y: 18))
    }
}

// MARK: PointProjectableType

extension NCapsuleTests {
    func testProject_withinCapsule_closerToLineSegment() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 3, y: 2, z: 25)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 4.160251471689219, y: 2.773500981126146, z: 25.0))
    }
    
    func testProject_withinCapsule_withinStartSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 3, y: 2, z: -3)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 3.1980107453341566, y: 2.132007163556104, z: -3.1980107453341566))
    }
    
    func testProject_withinCapsule_withinEndSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 3, y: 2, z: 53)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 3.1980107453341566, y: 2.132007163556104, z: 53.19801074533416))
    }
    
    func testProject_withinCapsule_onLine() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 0, y: 0, z: 25)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: -1.886751345948129, y: -1.886751345948129, z: 23.11324865405187))
    }
    
    func testProject_onEdge_withinLineSegment() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 5, y: 0, z: 25)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 5, y: 0, z: 25))
    }
    
    func testProject_onEdge_onStartSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: -1)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 2.886751345948129, y: 2.886751345948129, z: -2.886751345948129))
    }
    
    func testProject_onEdge_onEndSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: 51)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 2.886751345948129, y: 2.886751345948129, z: 52.88675134594813))
    }
    
    func testProject_outOfBounds_closerToLineSegment() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 10, y: 10, z: 25)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 3.5355339059327373, y: 3.5355339059327373, z: 25.0))
    }
    
    func testProject_outOfBounds_closerToStartSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 5, y: 5, z: -4)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 3.077287274483318, y: 3.077287274483318, z: -2.4618298195866544))
    }
    
    func testProject_outOfBounds_closerToEndSphere() {
        let sut = Capsule(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 50),
            radius: 5
        )
        let point = Vector3D(x: 10, y: 10, z: 52)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 3.500700210070024, y: 3.500700210070024, z: 50.700140042014006))
    }
}
