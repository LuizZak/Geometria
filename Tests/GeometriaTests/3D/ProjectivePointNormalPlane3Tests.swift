import XCTest
import Geometria

class ProjectivePointNormalPlane3Tests: XCTestCase {
    typealias Vector = Vector3D
    typealias Vector2 = Vector2D
    typealias Plane = ProjectivePointNormalPlane3D
    
    func testPointOnPlane() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        XCTAssertEqual(sut.pointOnPlane, .init(x: 13, y: 3, z: 17))
    }
    
    func testChangePoint() {
        var sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        sut.changePoint(.init(x: 1, y: 2, z: 3))
        
        XCTAssertEqual(sut.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(sut.normal, .unitY)
        XCTAssertEqual(sut.upAxis, .unitZ)
        XCTAssertEqual(sut.rightAxis, .unitX)
    }
    
    func testChangingPoint() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        let result = sut.changingPoint(.init(x: 1, y: 2, z: 3))
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.normal, sut.normal)
        XCTAssertEqual(result.upAxis, sut.upAxis)
        XCTAssertEqual(result.rightAxis, sut.rightAxis)
    }
    
    func testChangeNormal() {
        var sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        sut.changeNormal(-.unitZ, upAxis: .unitY)
        
        XCTAssertEqual(sut.point, .init(x: 13, y: 3, z: 17))
        XCTAssertEqual(sut.normal, -.unitZ)
        XCTAssertEqual(sut.upAxis, .unitY)
        XCTAssertEqual(sut.rightAxis, .unitX)
    }
    
    func testChangeNormal_correctsUpAxis() {
        var sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        sut.changeNormal(.init(x: 0, y: 1, z: -3), upAxis: .init(x: 0, y: 3, z: 1))
        
        XCTAssertEqual(sut.point, .init(x: 13, y: 3, z: 17))
        XCTAssertEqual(sut.normal, .init(x: 0, y: 0.316227766016838, z: -0.9486832980505139))
        XCTAssertEqual(sut.upAxis, .init(x: 0, y: 0.9486832980505139, z: 0.31622776601683794))
        XCTAssertEqual(sut.rightAxis, .unitX)
    }
    
    func testChangeNormal_lookUpZAxis_correctsRightAxis() {
        var sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        sut.changeNormal(.unitZ, upAxis: .unitY)
        
        XCTAssertEqual(sut.point, .init(x: 13, y: 3, z: 17))
        XCTAssertEqual(sut.normal, .unitZ)
        XCTAssertEqual(sut.upAxis, .unitY)
        XCTAssertEqual(sut.rightAxis, -.unitX)
    }
    
    func testChangingNormal() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        let result = sut.changingNormal(-.unitZ, upAxis: .unitY)
        
        XCTAssertEqual(result.point, sut.point)
        XCTAssertEqual(result.normal, -.unitZ)
        XCTAssertEqual(result.upAxis, .unitY)
        XCTAssertEqual(result.rightAxis, .unitX)
    }
    
    func testChangingNormal_correctsUpAxis() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        let result = sut.changingNormal(.init(x: 0, y: 1, z: -3), upAxis: .init(x: 0, y: 3, z: 1))
        
        XCTAssertEqual(result.point, sut.point)
        XCTAssertEqual(result.normal, .init(x: 0, y: 0.316227766016838, z: -0.9486832980505139))
        XCTAssertEqual(result.upAxis, .init(x: 0, y: 0.9486832980505139, z: 0.31622776601683794))
        XCTAssertEqual(result.rightAxis, .unitX)
    }
    
    func testMakeCorrectedPlane_skewed_correctsUpAxis() {
        let sut = Plane
            .makeCorrectedPlane(
                point: .init(x: 13.0, y: 3.0, z: 17.0),
                normal: .init(x: 0.0, y: 5, z: -0.3),
                upAxis: .unitZ
            )
        
        XCTAssertEqual(sut.upAxis, .init(x: 0.0, y: 0.05989229072794671, z: 0.9982048454657786))
    }
    
    func testAsPointNormalPlane() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        
        let result = sut.asPointNormalPlane
        
        XCTAssertEqual(result.point, sut.point)
        XCTAssertEqual(result.normal, sut.normal)
    }
}

// MARK: ProjectiveSpace Conformance

extension ProjectivePointNormalPlane3Tests {
    func testProjectLineIntersection_line() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let line = Line3D(a: .zero, b: .one)
        
        let result = sut.projectLineIntersection(line)
        
        XCTAssertEqual(result, .init(x: -10.0, y: -14.0))
    }
    
    func testProjectLineIntersection_line_parallelLine_returnsNil() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let line = Line3D(a: .zero, b: .unitZ)
        
        let result = sut.projectLineIntersection(line)
        
        XCTAssertNil(result)
    }
    
    func testProjectLineIntersection_ray_beforeStart_returnsNil() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let line = Ray3D(start: sut.point + .unitY, b: sut.point + .unitY * 2)
        
        let result = sut.projectLineIntersection(line)
        
        XCTAssertNil(result)
    }
    
    func testProjectLineIntersection_lineSegment_afterEnd_returnsNil() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let line = LineSegment3D(start: sut.point - .unitY * 2, end: sut.point - .unitY)
        
        let result = sut.projectLineIntersection(line)
        
        XCTAssertNil(result)
    }
    
    func testProject2D() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let vec = Vector(x: 11, y: 12, z: 23)
        
        XCTAssertEqual(sut.project2D(vec), .init(x: -2, y: 6.0))
    }
    
    func testProject2D_skewed() {
        let sut = Plane
            .makeCorrectedPlane(
                point: .init(x: 13.0, y: 3.0, z: 17.0),
                normal: .init(x: 0.0, y: 5, z: -0.3),
                upAxis: .unitZ
            )
        let vec = Vector(x: 11, y: 12, z: 23)
        
        XCTAssertEqual(sut.project2D(vec), .init(x: -2, y: 6.528259689346192))
    }
    
    func testAttemptProject() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let vec = Vector(x: 11, y: 12, z: 23)
        
        XCTAssertEqual(sut.attemptProjection(vec), .init(x: -2, y: 6.0))
    }
    
    func testAttemptProject_skewed() {
        let sut = Plane
            .makeCorrectedPlane(
                point: .init(x: 13.0, y: 3.0, z: 17.0),
                normal: .init(x: 0.0, y: 5, z: -0.3),
                upAxis: .unitZ
            )
        let vec = Vector(x: 11, y: 12, z: 23)
        
        XCTAssertEqual(sut.attemptProjection(vec), .init(x: -2, y: 6.528259689346192))
    }
    
    func testProjectOut() {
        let sut = Plane(
            point: .init(x: 13, y: 3, z: 17),
            normal: .unitY,
            upAxis: .unitZ,
            rightAxis: .unitX
        )
        let coord = Vector2(x: 2, y: 7)
        
        XCTAssertEqual(sut.projectOut(coord), .init(x: 15, y: 3, z: 24))
    }
    
    func testProjectOut_skewed() {
        let sut = Plane
            .makeCorrectedPlane(
                point: .init(x: 13.0, y: 3.0, z: 17.0),
                normal: .init(x: 0.0, y: 5, z: -0.3),
                upAxis: .unitZ
            )
        let coord = Vector2(x: 2, y: 7)
        
        XCTAssertEqual(sut.projectOut(coord), .init(x: 15, y: 3.419246035095627, z: 23.98743391826045))
    }
}
