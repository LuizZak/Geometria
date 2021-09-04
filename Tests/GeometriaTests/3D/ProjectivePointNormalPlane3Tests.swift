import XCTest
import Geometria

class ProjectivePointNormalPlane3Tests: XCTestCase {
    typealias Vector = Vector3D
    typealias Vector2 = Vector2D
    typealias Plane = ProjectivePointNormalPlane3D
    
    func testPointOnPlane() {
        let sut = Plane(point: .init(x: 13, y: 3, z: 17),
                        normal: .unitY,
                        upAxis: .unitZ,
                        rightAxis: .unitX)
        
        XCTAssertEqual(sut.pointOnPlane, .init(x: 13, y: 3, z: 17))
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
    
    func testAttemptProject() {
        let sut = Plane(point: .init(x: 13, y: 3, z: 17),
                        normal: .unitY,
                        upAxis: .unitZ,
                        rightAxis: .unitX)
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
        let sut = Plane(point: .init(x: 13, y: 3, z: 17),
                        normal: .unitY,
                        upAxis: .unitZ,
                        rightAxis: .unitX)
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
