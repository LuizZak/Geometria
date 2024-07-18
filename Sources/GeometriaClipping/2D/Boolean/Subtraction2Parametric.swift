/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Subtraction2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
    where T1.Vector == T2.Vector, T1.Vector: Hashable
{
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allContours() -> [Contour] {
        typealias State = GeometriaClipping.State<T1.Period>

        let rhsReversed = rhs.reversed()

        // A subtraction is a union of a geometry and a reverse-wound input geometry
        let union = Union2Parametric(lhs, rhsReversed, tolerance: tolerance)
        return union.allContours()
    }
}
