import Geometria

/// An exclusive-disjunction boolean parametric that outputs the non-shared area
/// between two or more geometries.
public struct ExclusiveDisjunction2Parametric<Vector: Vector2Real & Hashable>: Boolean2Parametric {
    public typealias Contour = Parametric2Contour<Vector>

    public let contours: [Contour]
    public let tolerance: Scalar

    public init<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        tolerance: T1.Scalar = .leastNonzeroMagnitude
    ) where T1.Vector == T2.Vector, T1.Vector == Vector, T1.Vector: Hashable {
        self.init(
            contours: lhs.allContours() + rhs.allContours(),
            tolerance: tolerance
        )
    }

    public init(
        contours: [Contour],
        tolerance: Scalar = .leastNonzeroMagnitude
    ) {
        self.contours = contours
        self.tolerance = tolerance
    }

    @inlinable
    public func allContours() -> [Contour] {
        // An exclusive disjunction can be expressed as a union followed by a
        // subtraction of the intersection
        let union = union(tolerance: tolerance, contours: self.contours)
        let intersection = intersection(tolerance: tolerance, contours: self.contours)

        return subtraction(tolerance: tolerance, union, [intersection]).allContours()
    }

    @inlinable
    public static func exclusiveDisjunction<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        tolerance: Vector.Scalar = .leastNonzeroMagnitude,
        _ lhs: T1,
        _ rhs: T2
    ) -> Compound2Parametric<Vector> where T1.Vector == T2.Vector, T1.Vector == Vector, T1.Vector: Hashable {
        let op = Self(lhs, rhs, tolerance: tolerance)
        return .init(contours: op.allContours())
    }
}

/// Performs an exclusive disjunction operation across all given parametric
/// geometries.
///
/// - precondition: `shapes` is not empty.
@inlinable
public func exclusiveDisjunction<Vector: Hashable>(
    tolerance: Vector.Scalar = .leastNonzeroMagnitude,
    _ shapes: [some ParametricClip2Geometry<Vector>]
) -> Compound2Parametric<Vector> {
    return exclusiveDisjunction(
        tolerance: tolerance,
        contours: shapes.flatMap({ $0.allContours() })
    )
}

/// Performs an exclusive disjunction operation across all given parametric
/// geometries.
@inlinable
public func exclusiveDisjunction<Vector: Hashable>(
    tolerance: Vector.Scalar = .leastNonzeroMagnitude,
    contours: [Parametric2Contour<Vector>]
) -> Compound2Parametric<Vector> {
    let op = ExclusiveDisjunction2Parametric(contours: contours, tolerance: tolerance)
    return Compound2Parametric(contours: op.allContours())
}
