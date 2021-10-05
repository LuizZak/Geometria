/// Protocol for rectangle geometric types that can be combined as intersection
/// and unions with other rectangles of the same type.
public protocol SelfIntersectableRectangleType: RectangleType {
    /// Returns whether a given rectangle rests completely inside the boundaries
    /// of this rectangle.
    func contains(_ other: Self) -> Bool
    
    /// Returns whether this rectangle intersects the given rectangle instance.
    /// This check is inclusive, so the edges of the bounding box are considered
    /// to intersect the other bounding box's edges as well.
    func intersects(_ other: Self) -> Bool
    
    /// Returns a rectangle which is the minimum rectangle that can fit this
    /// rectangle and `other`.
    func union(_ other: Self) -> Self
    
    /// Creates a rectangle which is equal to the non-zero area shared between
    /// this rectangle and `other`.
    ///
    /// If the rectangles do not intersect (i.e. produce a rectangle with < 0
    /// bounds), `nil` is returned, instead.
    func intersection(_ other: Self) -> Self?
}
