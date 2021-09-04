import XCTest
import Geometria

class TakeVector3Tests: XCTestCase {
    typealias TakeVector = TakeVector3<Vector3<Double>>
    
    private func makeSut() -> TakeVector {
        return TakeVector(underlying: .init(x: 1, y: 2, z: 3))
    }
    
    func testXY() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.xy, .init(x: 1, y: 2))
    }
    
    func testYX() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.yx, .init(x: 2, y: 1))
    }
    
    func testXZ() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.xz, .init(x: 1, y: 3))
    }
    
    func testZX() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.zx, .init(x: 3, y: 1))
    }
    
    func testYZ() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.yz, .init(x: 2, y: 3))
    }
    
    func testZY() {
        let sut = makeSut()
        
        XCTAssertEqual(sut.zy, .init(x: 3, y: 2))
    }
}
