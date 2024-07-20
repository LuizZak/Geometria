import XCTest
import Geometria
import TestCommons

class VectorComparableTests: XCTestCase {
    func testMin() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(min(vec1, vec2), Vector2i(x: -1, y: -3))
    }
    
    func testMax() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(max(vec1, vec2), Vector2i(x: 2, y: 4))
    }
    
    func testMinimalComponentIndex() {
        XCTAssertEqual(TestVectorComparable(x: -1, y: 2).minimalComponentIndex, 0)
        XCTAssertEqual(TestVectorComparable(x: 1, y: -2).minimalComponentIndex, 1)
    }
    
    func testMinimalComponentIndex_equalXY() {
        XCTAssertEqual(TestVectorComparable(x: 1, y: 1).minimalComponentIndex, 1)
    }
    
    func testMaximalComponentIndex() {
        XCTAssertEqual(TestVectorComparable(x: -1, y: 2).maximalComponentIndex, 1)
        XCTAssertEqual(TestVectorComparable(x: 1, y: -2).maximalComponentIndex, 0)
    }
    
    func testMaximalComponentIndex_equalXY() {
        XCTAssertEqual(TestVectorComparable(x: 1, y: 1).maximalComponentIndex, 1)
    }
    
    func testGreaterThan() {
        XCTAssertTrue(TestVectorComparable(x: 1, y: 1) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: 1) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 1, y: 0) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: 0) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: -1, y: 0) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: -1) > TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: -1, y: -1) > TestVectorComparable(x: 0, y: 0))
    }
    
    func testGreaterThan_mismatchedScalarCount_returnsFalse() {
        XCTAssertFalse(
            TestVectorComparable(x: 1, y: 1, scalarCount: 1)
                > TestVectorComparable(x: 0, y: 0)
        )
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(TestVectorComparable(x: 1, y: 1) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: 0, y: 1) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: 1, y: 0) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: 0, y: 0) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: -1, y: 0) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: -1) >= TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: -1, y: -1) >= TestVectorComparable(x: 0, y: 0))
    }
    
    func testGreaterThanOrEqualTo_mismatchedScalarCount_returnsFalse() {
        XCTAssertFalse(
            TestVectorComparable(x: 1, y: 1, scalarCount: 1)
                >= TestVectorComparable(x: 0, y: 0)
        )
    }
    
    func testLessThan() {
        XCTAssertFalse(TestVectorComparable(x: 1, y: 1) < TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: 1) < TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 1, y: 0) < TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: 0) < TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: -1, y: 0) < TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: -1) < TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: -1, y: -1) < TestVectorComparable(x: 0, y: 0))
    }
    
    func testLessThan_mismatchedScalarCount_returnsFalse() {
        XCTAssertFalse(
            TestVectorComparable(x: -1, y: -1, scalarCount: 1)
                < TestVectorComparable(x: 0, y: 0)
            )
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(TestVectorComparable(x: 1, y: 1) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 0, y: 1) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertFalse(TestVectorComparable(x: 1, y: 0) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: 0, y: 0) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: -1, y: 0) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: 0, y: -1) <= TestVectorComparable(x: 0, y: 0))
        XCTAssertTrue(TestVectorComparable(x: -1, y: -1) <= TestVectorComparable(x: 0, y: 0))
    }
    
    func testLessThanOrEqualTo_mismatchedScalarCount_returnsFalse() {
        XCTAssertFalse(
            TestVectorComparable(x: -1, y: -1, scalarCount: 1)
                <= TestVectorComparable(x: 0, y: 0)
        )
    }
    
    func testMinimalComponent() {
        XCTAssertEqual(TestVectorComparable(x: -1, y: 2).minimalComponent, -1)
        XCTAssertEqual(TestVectorComparable(x: 1, y: -2).minimalComponent, -2)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(TestVectorComparable(x: -1, y: 2).maximalComponent, 2)
        XCTAssertEqual(TestVectorComparable(x: 1, y: -2).maximalComponent, 1)
    }
}

private struct TestVectorComparable: VectorComparable {
    typealias Scalar = Double
    
    var x: Double
    var y: Double
    
    var scalarCount: Int
    
    subscript(index: Int) -> Double {
        get {
            switch index {
            case 0:
                return x
            case 1:
                return y
            default:
                fatalError("index out of bounds")
            }
        }
        set {
            switch index {
            case 0:
                x = newValue
            case 1:
                y = newValue
            default:
                fatalError("index out of bounds")
            }
        }
    }
    
    init(x: Double, y: Double, scalarCount: Int = 2) {
        self.x = x
        self.y = y
        self.scalarCount = scalarCount
    }
    
    init(repeating scalar: Double) {
        self.init(x: scalar, y: scalar)
    }
    
    static func pointwiseMin(
        _ lhs: TestVectorComparable,
        _ rhs: TestVectorComparable
    ) -> TestVectorComparable {

        TestVectorComparable(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y))
    }
    
    static func pointwiseMax(
        _ lhs: TestVectorComparable,
        _ rhs: TestVectorComparable
    ) -> TestVectorComparable {
        
        TestVectorComparable(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y))
    }
}
