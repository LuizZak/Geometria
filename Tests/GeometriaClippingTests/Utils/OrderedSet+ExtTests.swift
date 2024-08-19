import XCTest
import TestCommons
import OrderedCollections

@testable import GeometriaClipping

class OrderedSet_ExtTests: XCTestCase {
    func testMinimized_emptySet() {
        let sut: OrderedSet<OrderedSet<Int>> = []

        XCTAssertTrue(sut.minimized().isEmpty)
    }

    func testMinimized_setOfEmptySets() {
        let sut: OrderedSet<OrderedSet<Int>> = [[], [], []]

        XCTAssertEqual(sut.minimized(), [[]])
    }

    func testMinimized_fullyDisjoint() {
        let sut: OrderedSet<OrderedSet<Int>> = [[0, 1, 2], [3, 4], [5, 6]]

        assertEqualUnordered(
            sut.minimized(),
            [[0, 1, 2], [3, 4], [5, 6]],
            compare: ==
        )
    }

    func testMinimized_common_across_2() {
        let sut: OrderedSet<OrderedSet<Int>> = [[0, 1, 2], [2, 3, 4]]

        assertEqualUnordered(
            sut.minimized(),
            [[0, 1, 2, 3, 4]],
            compare: ==
        )
    }

    func testMinimized_common_across_3() {
        let sut: OrderedSet<OrderedSet<Int>> = [[0, 1, 2], [2, 3, 4], [4, 5, 6]]

        assertEqualUnordered(
            sut.minimized(),
            [[0, 1, 2, 3, 4, 5, 6]],
            compare: ==
        )
    }

    func testMinimized_common_across_3_skip_one() {
        let sut: OrderedSet<OrderedSet<Int>> = [[0, 1, 2], [2, 3, 4], [5, 6, 0]]

        assertEqualUnordered(
            sut.minimized(),
            [[0, 1, 2, 3, 4, 5, 6]],
            compare: ==
        )
    }
}
