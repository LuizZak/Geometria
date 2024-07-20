import Geometria

/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Subtraction2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
    where T1.Vector == T2.Vector, T1.Vector: Hashable
{
    public typealias Vector = T1.Vector
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar = .leastNonzeroMagnitude) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allContours() -> [Contour] {
        let rhsReversed = rhs.reversed()

        // A subtraction is a union of a geometry and a reverse-wound input geometry
        let union = Union2Parametric(lhs, rhsReversed, tolerance: tolerance)
        return union.allContours()
    }

    public static func subtraction(
        tolerance: Vector.Scalar = .leastNonzeroMagnitude,
        _ lhs: T1,
        _ rhs: T2
    ) -> Compound2Parametric<Vector> {
        let op = Self(lhs, rhs, tolerance: tolerance)
        return .init(contours: op.allContours())
    }
}

/// Performs a subtraction operation by removing all given parametric geometries
/// from `shape1`.
public func subtraction<Vector: Hashable>(
    tolerance: Double = .leastNonzeroMagnitude,
    _ shape1: some ParametricClip2Geometry<Vector>,
    _ shapes: [some ParametricClip2Geometry<Vector>]
) -> Compound2Parametric<Vector> {
    let shapes = shapes.map({ Compound2Parametric($0.reversed()) })
    return union([Compound2Parametric(shape1)] + shapes)
}
