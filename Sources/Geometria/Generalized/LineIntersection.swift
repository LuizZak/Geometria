/// The result of a ``LineIntersectableType``-line intersection test.
public struct LineIntersection<Vector: VectorType> {
    /// A flag that is set to `true` if the line the shape was tested against is
    /// fully contained within the shape.
    public var isContained: Bool

    /// A list of intersections that where returned by a ``LineIntersectableType``.
    public var intersections: [Intersection]

    @_transparent
    public init(isContained: Bool, intersections: [Intersection]) {
        self.isContained = isContained
        self.intersections = intersections
    }

    /// Represents an intersection in a ``LineIntersection``.
    public enum Intersection {
        /// Represents an intersection that crosses to within the boundaries
        /// of the shape.
        case enter(PointNormal<Vector>)

        /// Represents an intersection that crosses to the outside of the 
        /// boundaries of the shape.
        case exit(PointNormal<Vector>)
    }
}

extension LineIntersection: Equatable where Vector: Equatable { }
extension LineIntersection: Hashable where Vector: Hashable { }
extension LineIntersection.Intersection: Equatable where Vector: Equatable { }
extension LineIntersection.Intersection: Hashable where Vector: Hashable { }
