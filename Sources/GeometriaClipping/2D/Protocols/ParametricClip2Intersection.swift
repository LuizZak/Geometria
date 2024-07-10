/// Contains information relating to the intersection of two solid parametric
/// geometries.
public enum ParametricClip2Intersection<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry> {
    /// The compact information present for intersections.
    public typealias Atom = (self: T1.Period, other: T2.Period)

    /// An intersection that occurs at a single point.
    case singlePoint(Atom)

    /// A dual intersection- or an intersection that has an entrance and an exit
    /// on the left-hand side of the intersection.
    case dual(Atom, Atom)
}
