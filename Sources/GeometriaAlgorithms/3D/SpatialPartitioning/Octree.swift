import Geometria

/// A specialization of a 3-dimensional spatial tree that is used to store large
/// number of elements in a partitioned 3-dimensional space for querying as points,
/// lines, and AABBs.
///
/// Each octree subdivides a 3-dimensional space into eight equally-sized
/// subdivisions using AABBs.
///
/// - see: https://en.wikipedia.org/wiki/Octree
public typealias Octree<Element: BoundableType> = SpatialTree<Element> where Element.Vector: Vector3Type & VectorComparable & VectorDivisible
