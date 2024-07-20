import Geometria

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

// MARK: Intersection assertions

extension AssertionWrapperType where Value: LineIntersectableType, Value.Vector: Vector2FloatingPoint, Value.Vector.Scalar: CustomStringConvertible {
    public func assertIntersections(
        with lineSegment: LineSegment2<Value.Vector>,
        _ expected: LineIntersection<Value.Vector>,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        let intersections = value.intersections(with: lineSegment)

        fixture.assertEquals(intersections, expected, file: file, line: line)

        if intersections != expected {
            visualize()
        }
    }

    public func assertIntersections(
        with lineSegment: LineSegment2<Value.Vector>,
        _ expected: LineIntersection<Value.Vector>,
        file: StaticString = #file,
        line: UInt = #line
    ) where Value.Vector: VisualizableGeometricType2 {

        let intersections = value.intersections(with: lineSegment)

        fixture.assertEquals(intersections, expected, file: file, line: line)

        if intersections != expected {
            fixture.add(lineSegment)
            fixture.add(intersections)
            visualize()
        }
    }
}
