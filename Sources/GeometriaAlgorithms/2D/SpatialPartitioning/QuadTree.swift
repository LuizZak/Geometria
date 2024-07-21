import Geometria

/// A specialization of a 2-dimensional spatial tree that is used to store large
/// number of elements in a partitioned 2-dimensional space for querying as points,
/// lines, and AABBs.
///
/// Each quad-tree subdivides a 2-dimensional space into four equally-sized
/// subdivisions using AABBs.
///
/// - see: https://en.wikipedia.org/wiki/QuadTree
public typealias QuadTree<Element: BoundableType> = SpatialTree<Element> where Element.Vector: Vector2Type & VectorComparable & VectorDivisible
