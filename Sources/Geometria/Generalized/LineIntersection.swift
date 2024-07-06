/// The result of a ``LineIntersectableType``-line intersection test.
public struct LineIntersection<Vector: VectorFloatingPoint> {
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

        /// Represents an intersection that is non-directional.
        case point(PointNormal<Vector>)

        /// Gets the point normal associated with this intersection
        public var pointNormal: PointNormal<Vector> {
            switch self {
            case .enter(let pn), .exit(let pn), .point(let pn):
                return pn
            }
        }
    }
}

extension LineIntersection.Intersection: Equatable where Vector: Equatable { }
extension LineIntersection.Intersection: Hashable where Vector: Hashable { }
extension LineIntersection: Equatable where Vector: Equatable { }
extension LineIntersection: Hashable where Vector: Hashable { }
