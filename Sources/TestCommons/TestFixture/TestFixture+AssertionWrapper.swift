extension AssertionWrapperType {
    public func assertEquals<T: Equatable>(
        _ actual: T,
        _ expected: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        fixture.assertEquals(actual, expected, file: file, line: line)

        if actual != expected {
            visualize()
        }
    }

    public func assertTrue(
        _ actual: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        fixture.assertTrue(actual, file: file, line: line)

        if actual != true {
            visualize()
        }
    }

    public func assertFalse(
        _ actual: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        fixture.assertFalse(actual, file: file, line: line)

        if actual != false {
            visualize()
        }
    }
}
