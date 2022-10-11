import XCTest
import Geometria

class RoundNRectangleTests: XCTestCase {
    typealias RoundRectangle = RoundNRectangle<Vector2D>
    
    func testCodable() throws {
        let sut = RoundRectangle(rectangle: .init(x: 1, y: 2, width: 3, height: 5), radius: .init(x: 7, y: 11))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(RoundRectangle.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithRadiusXY() {
        let sut = RoundRectangle(rectangle: .init(x: 1, y: 2, width: 3, height: 5), radiusX: 7, radiusY: 11)
        
        XCTAssertEqual(sut.bounds.x, 1)
        XCTAssertEqual(sut.bounds.y, 2)
        XCTAssertEqual(sut.bounds.width, 3)
        XCTAssertEqual(sut.bounds.height, 5)
        XCTAssertEqual(sut.radius.x, 7)
        XCTAssertEqual(sut.radius.y, 11)
    }
    
    func testEquals() {
        XCTAssertEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
    }
    
    func testUnequals() {
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 999, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 999, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 999, height: 5),
                radius: .init(x: 7, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 999),
                radius: .init(x: 7, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 999, y: 11)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 999)
            ),
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            )
        )
    }
    
    func testHashable() {
        XCTAssertEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 999, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 999, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 999, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 999),
                radius: .init(x: 7, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 999, y: 11)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
        
        XCTAssertNotEqual(
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 999)
            ).hashValue,
            RoundRectangle(
                rectangle: .init(x: 1, y: 2, width: 3, height: 5),
                radius: .init(x: 7, y: 11)
            ).hashValue
        )
    }
}
