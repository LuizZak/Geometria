import XCTest

@testable import Geometria

class LineCategoryTests: XCTestCase {
    func testEquals() {
        XCTAssertEqual(LineCategory.line, LineCategory.line)
        XCTAssertEqual(LineCategory.ray, LineCategory.ray)
        XCTAssertEqual(LineCategory.mirroredRay, LineCategory.mirroredRay)
        XCTAssertEqual(LineCategory.lineSegment, LineCategory.lineSegment)
    }

    func testUnequals() {
        XCTAssertNotEqual(LineCategory.line, LineCategory.lineSegment)
        XCTAssertNotEqual(LineCategory.line, LineCategory.mirroredRay)
        XCTAssertNotEqual(LineCategory.line, LineCategory.ray)
        XCTAssertNotEqual(LineCategory.ray, LineCategory.lineSegment)
        XCTAssertNotEqual(LineCategory.ray, LineCategory.mirroredRay)
        XCTAssertNotEqual(LineCategory.mirroredRay, LineCategory.lineSegment)
    }

    func testHashable() {
        XCTAssertEqual(LineCategory.line.hashValue, LineCategory.line.hashValue)
        XCTAssertEqual(LineCategory.ray.hashValue, LineCategory.ray.hashValue)
        XCTAssertEqual(LineCategory.mirroredRay.hashValue, LineCategory.mirroredRay.hashValue)
        XCTAssertEqual(LineCategory.lineSegment.hashValue, LineCategory.lineSegment.hashValue)
        //
        XCTAssertNotEqual(LineCategory.line.hashValue, LineCategory.lineSegment.hashValue)
        XCTAssertNotEqual(LineCategory.line.hashValue, LineCategory.ray.hashValue)
        XCTAssertNotEqual(LineCategory.line.hashValue, LineCategory.mirroredRay.hashValue)
        XCTAssertNotEqual(LineCategory.ray.hashValue, LineCategory.mirroredRay.hashValue)
        XCTAssertNotEqual(LineCategory.ray.hashValue, LineCategory.lineSegment.hashValue)
        XCTAssertNotEqual(LineCategory.mirroredRay.hashValue, LineCategory.lineSegment.hashValue)
    }

    func testIsOpenStart() {
        XCTAssertTrue(LineCategory.line.isOpenStart)
        XCTAssertFalse(LineCategory.ray.isOpenStart)
        XCTAssertTrue(LineCategory.mirroredRay.isOpenStart)
        XCTAssertFalse(LineCategory.lineSegment.isOpenStart)
    }

    func testIsOpenEnd() {
        XCTAssertTrue(LineCategory.line.isOpenEnd)
        XCTAssertTrue(LineCategory.ray.isOpenEnd)
        XCTAssertFalse(LineCategory.mirroredRay.isOpenEnd)
        XCTAssertFalse(LineCategory.lineSegment.isOpenEnd)
    }
}