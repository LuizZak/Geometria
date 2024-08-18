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
    public func intersection(with other: Self) -> ClosedShape2Intersection<Vector> {
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
        let distSquared: Scalar = (dist * dist)
        let dist2: Scalar = dist * 2
        let a: Scalar = (r0s - r1s + distSquared) / dist2
        let h: Scalar = (r0s - (a * a)).squareRoot()

        let normCenter: Vector = (other.center - center) / dist
        let p2: Vector = center + a * normCenter

        let h_x: Scalar = h * normCenter.y
        let x3_0: Scalar = p2.x + h_x
        let x3_1: Scalar = p2.x - h_x

        let h_y: Scalar = h * normCenter.x
        let y3_0: Scalar = p2.y - h_y
        let y3_1: Scalar = p2.y + h_y

        return .twoPoints(pointNormal(x3_0, y3_0), pointNormal(x3_1, y3_1))
    }
}

public extension Circle2 where Vector: Vector2Real {
    /// Returns a point on this circle represented by a given angle.
    @_transparent
    @inlinable
    func pointOnAngle(_ angle: Angle<Scalar>) -> Vector {
        let c = angle.cos
        let s = angle.sin

        let point = Vector(x: c, y: s) * radius

        return center + point
    }

    /// Generates an arc from this circle.
    func arc(startAngle: Angle<Scalar>, sweepAngle: Angle<Scalar>) -> CircleArc2<Vector> {
        .init(center: center, radius: radius, startAngle: startAngle, sweepAngle: sweepAngle)
    }

    /// Generates an arc from this circle.
    func arc(startAngle: Scalar, sweepAngle: Scalar) -> CircleArc2<Vector> {
        .init(center: center, radius: radius, startAngle: startAngle, sweepAngle: sweepAngle)
    }

    /// Computes the two points that are touching the tangents of this circie
    /// starting from `point`.
    ///
    /// - precondition: `point` is at least `radius`-distance away from `self.center`.
    func tangents(to point: Vector) -> (Vector, Vector) {
        let t = (point.distanceSquared(to: center) - radius * radius).squareRoot()
        let r2t2: Scalar = radius * radius + t * t

        let u1x: Scalar = (radius * (point.x - center.x) as Scalar - t * (point.y - center.y) as Scalar) / r2t2
        let u1y: Scalar = (radius * (point.y - center.y) as Scalar + t * (point.x - center.x) as Scalar) / r2t2

        let u2x: Scalar = (radius * (point.x - center.x) as Scalar + t * (point.y - center.y) as Scalar) / r2t2
        let u2y: Scalar = (radius * (point.y - center.y) as Scalar - t * (point.x - center.x) as Scalar) / r2t2

        let u1 = Vector(x: u1x, y: u1y)
        let u2 = Vector(x: u2x, y: u2y)

        let t1 = center + u1 * radius
        let t2 = center + u2 * radius

        return (t1, t2)
    }

    /// Computes the [outer tangents] between circles `self` and `other`, returning
    /// the two tangent lines.
    ///
    /// The two tangents are ordered as the top and bottom, respectively, of a setup
    /// where `self` is aligned exactly to the left of `other`, with both tangents
    /// pointing from `self` to `other`.
    ///
    /// [outer tangents]: https://en.wikipedia.org/wiki/Tangent_lines_to_circles#Outer_tangent
    func outerTangents(to other: Self) -> (LineSegment2<Vector>, LineSegment2<Vector>) {
        let r3 = radius - other.radius
        let centerToCenter = other.center - center
        let centerToCenterAngle = centerToCenter.angle
        let centerToCenterLength = centerToCenter.length
        let r3CenterAcos = Scalar.acos(r3 / centerToCenterLength)
        let theta1 = centerToCenterAngle - r3CenterAcos
        let theta2 = centerToCenterAngle + r3CenterAcos

        let theta1Vec = Vector(x: Scalar.cos(theta1), y: Scalar.sin(theta1))
        let theta2Vec = Vector(x: Scalar.cos(theta2), y: Scalar.sin(theta2))

        let t1a = center + radius * theta1Vec
        let t1b = other.center + other.radius * theta1Vec

        let t2a = center + radius * theta2Vec
        let t2b = other.center + other.radius * theta2Vec

        return (
            .init(start: t1a, end: t1b),
            .init(start: t2a, end: t2b)
        )
    }
}
