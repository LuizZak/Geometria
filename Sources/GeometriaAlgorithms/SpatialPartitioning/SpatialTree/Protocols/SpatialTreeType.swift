import Geometria

public protocol SpatialTreeType where Bounds.Vector == Element.Vector, Element.Vector: VectorDivisible & VectorComparable {
    typealias Vector = Element.Vector

    associatedtype Element: BoundableType
    associatedtype Bounds: DivisibleRectangleType & ConstructableRectangleType

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds contain a given point.
    func queryPoint(_ point: Vector) -> [Element]

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds intersect a given line.
    func queryLine<Line: LineFloatingPoint>(
        _ line: Line
    ) -> [Element] where Line.Vector == Vector
}
