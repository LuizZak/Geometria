/// Represents a 2D circle with a double-precision floating-point center point
/// and radius parameters.
public typealias Circle2D = Circle2<Vector2D>

/// Represents a 2D circle with a single-precision floating-point center point
/// and radius parameters.
public typealias Circle2F = Circle2<Vector2F>

/// Typealias for `NSphere<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Circle2<V: Vector2Type> = NSphere<V>

public extension Circle2 {
    /// Initializes a circle centered at a given point with a given radius.
    init(x: Scalar, y: Scalar, radius: Scalar) {
        self.init(center: .init(x: x, y: y), radius: radius)
    }
}

public extension Circle2 where Vector: VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this circle's area contains a given point.
    ///
    /// Points at the perimeter of the circle (distance to center == radius)
    /// are considered as contained within the circle.
    @_transparent
    func contains(x: Scalar, y: Scalar) -> Bool {
        contains(.init(x: x, y: y))
    }
}

extension Circle2: Convex2Type where Vector: Vector2FloatingPoint {
    /// Returns the result of the intersection between `self` and another `Circle2`.
    ///
    /// If the circles are coincident on the same center, and have the same radius,
    /// the result is `.noIntersection`.
    public func intersection(with other: Self) -> Convex2Convex2Intersection<Vector> {
        func pointNormal(_ p: Vector, normal: Vector) -> PointNormal<Vector> {
            .init(point: p, normal: normal)
        }
        func pointNormal(_ p: Vector) -> PointNormal<Vector> {
            pointNormal(p, normal: (p - center).normalized())
        }
        func pointNormal(_ x: Scalar, _ y: Scalar) -> PointNormal<Vector> {
            pointNormal(.init(x: x, y: y))
        }

        let dist: Scalar = center.distance(to: other.center)
        if dist > radius + other.radius {
            return .noIntersection
        }
        if dist < (radius - other.radius).magnitude {
            return radius > other.radius ? .contains : .contained
        }

        let direction: Vector = (other.center - center).normalized()

        if dist == radius + other.radius {
            return .singlePoint(
                pointNormal(
                    center + direction * radius,
                    normal: direction
                )
            )
        }

        let r0s: Scalar = radius * radius
        let r1s: Scalar = other.radius * other.radius
        let a: Scalar = (r0s - r1s + (dist * dist)) / (dist * 2)
        let h: Scalar = (r0s - (a * a)).squareRoot()

        let h_x: Scalar = (h * (other.center.y - center.y) / dist)

        let p2: Vector = center + (a * (other.center - center)) / dist

        let x3_0: Scalar = p2.x + h_x
        let x3_1: Scalar = p2.x - h_x

        let h_y: Scalar = (h * (other.center.x - center.x) / dist)
        let y3_0: Scalar = p2.y + h_y
        let y3_1: Scalar = p2.y - h_y

        return .twoPoints(pointNormal(x3_0, y3_0), pointNormal(x3_1, y3_1))
    }
}
