import XCTest

/// Aids in asserting that sequences feature a set of expected elements, with
/// options to assert exact element count and out-of-order (for Set<> structures)
/// verification.
class SequenceAsserter<T: Hashable> {
    private let _options: Options
    private var _sequence: [(T, verified: Bool)]

    private var remaining: [T] {
        return _sequence.filter { !$0.verified }.map(\.0)
    }
    private var actual: [T] {
        return _sequence.map(\.0)
    }

    init<S: Sequence>(actual sequence: S, options: Options) where S.Element == T {
        _options = options
        _sequence = (options.ignoreRepeated ? _deduplicateStable(sequence) : Array(sequence)).map {
            ($0, verified: false)
        }
    }

    func assert<S: Sequence>(
        equals expected: S,
        file: StaticString = #file,
        line: UInt = #line
    ) where S.Element == T {

        let expected = _options.ignoreRepeated ? _deduplicateStable(expected) : Array(expected)
        let actual = self.actual

        var lastIndexVerified = -1
        for (i, next) in expected.enumerated() {
            guard let nextIndex = _verifyItem(next) else {
                XCTFail(
                    """
                    Expected element \(next) not in actual sequence:

                    Actual:

                    \(actual)

                    Expected:

                    \(expected)
                    """,
                    file: file,
                    line: line
                )

                return
            }

            if _options.orderSensitive {
                if nextIndex != lastIndexVerified + 1 {
                    XCTFail(
                        """
                        Unexpected element at index \(i):

                        Actual:

                        \(actual[i])

                        Expected:

                        \(next)
                        """,
                        file: file,
                        line: line
                    )

                    return
                }

                lastIndexVerified = nextIndex
            }
        }

        // Assert elements that where unaccounted for
        let remaining = self.remaining
        if _options.exactElementCount, !remaining.isEmpty {
            XCTFail(
                """
                Unexpected elements remaining in actual sequence:

                \(remaining)

                Actual:

                \(actual)

                Expected:

                \(expected)
                """,
                file: file,
                line: line
            )
        }
    }

    private func _verifyItem(
        _ expected: T
    ) -> Int? {
        guard let index = _sequence.firstIndex(where: { $0.0 == expected && !$0.verified }) else {
            return nil
        }

        _sequence[index].verified = true
        return index
    }

    /// Options for assertions
    struct Options {
        /// Returns options fit for asserting sequences that are sets, with exact
        /// element counts.
        static var completeSet: Self {
            Self(
                orderSensitive: false,
                ignoreRepeated: true,
                exactElementCount: true
            )
        }

        /// Returns options fit for asserting sequences that are sets, with
        /// potentially more elements than where expected.
        static var partialSet: Self {
            Self(
                orderSensitive: false,
                ignoreRepeated: true,
                exactElementCount: false
            )
        }

        /// Returns options fit for asserting sequences that are arrays, with exact
        /// element counts.
        static var completeArray: Self {
            Self(
                orderSensitive: true,
                ignoreRepeated: false,
                exactElementCount: true
            )
        }

        /// Returns options fit for asserting sequences that are arrays, with
        /// potentially more elements than where expected.
        static var partialArray: Self {
            Self(
                orderSensitive: true,
                ignoreRepeated: false,
                exactElementCount: false
            )
        }

        /// If `true`, assertions are element-order-sensitive (i.e. Arrays),
        /// and if `false` assertions are not order-sensitive (i.e. Sets)
        var orderSensitive: Bool

        /// If `true`, elements that are repeated in the actual and expected
        /// sequences are shaved off before assertion.
        var ignoreRepeated: Bool

        /// If `true`, elements that where in the sequence but where not expected
        /// raise an assertion.
        var exactElementCount: Bool
    }
}

extension SequenceAsserter {
    /// Creates a sequence asserter fit for asserting the expected sequence of
    /// elements of an array.
    ///
    /// ```swift
    /// let actual = [0, 1, 3, 2, 4]
    ///
    /// SequenceAsserter
    ///     .forArray(
    ///         actual: actual
    ///     ).assert(
    ///         equals: [
    ///             0, 1, 2
    ///         ]
    ///     )
    /// // Raises test failure: 'Unexpected element at index 2:  Actual: 3 Expected: 2'
    /// ```
    static func forArray<S: Sequence>(actual: S, expectsExtraElements: Bool = false) -> SequenceAsserter where S.Element == T {
        SequenceAsserter(
            actual: actual,
            options: .init(
                orderSensitive: true,
                ignoreRepeated: false,
                exactElementCount: !expectsExtraElements
            )
        )
    }

    /// Creates a sequence asserter fit for asserting the expected elements in
    /// a set.
    ///
    /// ```swift
    /// let actual = [0, 1]
    ///
    /// SequenceAsserter
    ///     .forSet(
    ///         actual: actual
    ///     ).assert(
    ///         equals: [
    ///             0, 1, 2
    ///         ]
    ///     )
    /// // Raises test failure: 'Unexpected elements remaining in actual sequence: Actual: [0, 1] Expected: [0, 1, 2]'
    /// ```
    static func forSet<S: Sequence>(actual: S, expectsExtraElements: Bool = false) -> SequenceAsserter where S.Element == T {
        SequenceAsserter(
            actual: actual,
            options: .init(
                orderSensitive: false,
                ignoreRepeated: true,
                exactElementCount: !expectsExtraElements
            )
        )
    }
}

private func _deduplicateStable<S: Sequence>(_ elements: S) -> [S.Element] where S.Element: Equatable {
    var result: [S.Element] = []

    for element in elements {
        if !result.contains(element) {
            result.append(element)
        }
    }

    return result
}
