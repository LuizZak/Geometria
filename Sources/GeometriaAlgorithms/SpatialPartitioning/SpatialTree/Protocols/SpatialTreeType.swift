import Geometria

public protocol SpatialTreeType where Bounds.Vector == Element.Vector, Element.Vector: VectorDivisible & VectorComparable {
    associatedtype Element: BoundableType
    associatedtype Bounds: DivisibleRectangleType & ConstructableRectangleType

    typealias Vector = Element.Vector

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds contain a given point.
    ///
    /// Note: Does not check containment against the elements themselves, only
    /// their reported bounds.
    func queryPoint(_ point: Vector) -> [Element]

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds intersect a given line.
    ///
    /// Note: Does not check intersections against the elements themselves, only
    /// their reported bounds.
    func queryLine<Line: LineFloatingPoint>(
        _ line: Line
    ) -> [Element] where Line.Vector == Vector

    /// Returns all elements that overlap a given boundary within this spatial
    /// tree.
    ///
    /// Note: Does not check intersections against the elements themselves, only
    /// their reported bounds.
    func query<Bounds: BoundableType>(
        _ area: Bounds
    ) -> [Element] where Bounds.Vector == Vector
}
