import Geometria

public protocol SpatialTreeType where Bounds.Vector == Element.Vector, Element.Vector: VectorDivisible & VectorComparable {
    associatedtype Element: BoundableType
    associatedtype Bounds: DivisibleRectangleType & ConstructableRectangleType


}
