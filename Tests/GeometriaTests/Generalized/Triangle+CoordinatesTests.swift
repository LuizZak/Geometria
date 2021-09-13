import XCTest
import Geometria

class Triangle_CoordinatesTests: XCTestCase {
    typealias Triangle = Triangle3D
    typealias Coordinates = Triangle.Coordinates
    
    func testProjectToWorld_aPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 10, y: 10, z: 10),
            c: .init(x: 10, y: 0, z: 10)
        )
        let coordinates = Coordinates(
            wa: 1.0,
            wb: 0.0,
            wc: 0.0
        )
        
        let result = sut.projectToWorld(coordinates)
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 0.0)
        XCTAssertEqual(result.z, 0.0)
    }
    
    func testProjectToWorld_bPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 10, y: 10, z: 10),
            c: .init(x: 10, y: 0, z: 10)
        )
        let coordinates = Coordinates(
            wa: 0.0,
            wb: 1.0,
            wc: 0.0
        )
        
        let result = sut.projectToWorld(coordinates)
        
        XCTAssertEqual(result.x, 10.0)
        XCTAssertEqual(result.y, 10.0)
        XCTAssertEqual(result.z, 10.0)
    }
    
    func testProjectToWorld_cPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 10, y: 10, z: 10),
            c: .init(x: 10, y: 0, z: 10)
        )
        let coordinates = Coordinates(
            wa: 0.0,
            wb: 0.0,
            wc: 1.0
        )
        
        let result = sut.projectToWorld(coordinates)
        
        XCTAssertEqual(result.x, 10.0)
        XCTAssertEqual(result.y, 0.0)
        XCTAssertEqual(result.z, 10.0)
    }
    
    func testProjectToWorld_center() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 10, y: 10, z: 10),
            c: .init(x: 10, y: 0, z: 10)
        )
        let coordinates = Coordinates(
            wa: 1.0 / 3.0,
            wb: 1.0 / 3.0,
            wc: 1.0 / 3.0
        )
        
        let result = sut.projectToWorld(coordinates)
        
        XCTAssertEqual(result.x, 6.666666666666666)
        XCTAssertEqual(result.y, 3.333333333333333)
        XCTAssertEqual(result.z, 6.666666666666666)
    }
    
    func testProjectToWorld_extrapolated() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 10, y: 10, z: 10),
            c: .init(x: 10, y: 0, z: 10)
        )
        let coordinates = Coordinates(
            wa: 0.0,
            wb: 2.0,
            wc: 0.0
        )
        
        let result = sut.projectToWorld(coordinates)
        
        XCTAssertEqual(result.x, 20.0)
        XCTAssertEqual(result.y, 20.0)
        XCTAssertEqual(result.z, 20.0)
    }
}
