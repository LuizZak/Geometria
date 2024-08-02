import RealModule

/// Represents a 2D [arc of a circle] with double-precision floating-point components.
///
/// [arc of a circle]: https://en.wikipedia.org/wiki/Circular_arc
public typealias CircleArc2D = CircleArc2<Vector2D>

/// Represents a 2D [arc of a circle] with single-precision floating-point components.
///
/// [arc of a circle]: https://en.wikipedia.org/wiki/Circular_arc
public typealias CircleArc2F = CircleArc2<Vector2F>

/// Represents a 2D [arc of a circle] as a center, radius, and start+sweep angles.
///
/// [arc of a circle]: https://en.wikipedia.org/wiki/Circular_arc
public struct CircleArc2<Vector: Vector2Real>: GeometricType, CustomStringConvertible {
    public typealias Scalar = Vector.Scalar

    /// The center of the arc's circle.
    public var center: Vector

    /// The radius of the arc's circle.
    public var radius: Scalar

    /// The starting angle of this arc, in radians.
    public var startAngle: Angle<Scalar>

    /// The sweep angle of this arc, in radians.
    public var sweepAngle: Angle<Scalar>

    public var description: String {
        "\(type(of: self))(center: \(center), radius: \(radius), startAngle: \(startAngle), sweepAngle: \(sweepAngle))"
    }

    /// Initializes a new circular arc with the given input parameters.
    public init(
        center: Vector,
        radius: Scalar,
        startAngle: Scalar,
        sweepAngle: Scalar
    ) {
        self.init(
            center: center,
            radius: radius,
            startAngle: .init(radians: startAngle),
            sweepAngle: .init(radians: sweepAngle)
        )
    }

    /// Initializes a new circular arc with the given input parameters.
    public init(
        center: Vector,
        radius: Scalar,
        startAngle: Angle<Scalar>,
        sweepAngle: Angle<Scalar>
    ) {
        self.center = center
        self.radius = radius
        self.startAngle = startAngle
        self.sweepAngle = sweepAngle
    }

    /// Creates a new circular arc that fills the space between `startPoint` and
    /// `endPoint`, with a sweep angle of `sweepAngle`.
    public init(
        startPoint: Vector,
        endPoint: Vector,
        sweepAngle: Angle<Scalar>
    ) {
        let mid = (endPoint + startPoint) / 2
        let gapDistance = endPoint.distance(to: startPoint)
        let arcNormal = (endPoint - startPoint).normalized().rightRotated()

        let sweepTan: Scalar = Scalar.tan(sweepAngle.radians / 2)
        let a: Vector = (arcNormal / 2) * gapDistance
        let center: Vector = mid - a / sweepTan

        self.init(
            center: center,
            radius: startPoint.distance(to: center),
            startAngle: center.angle(to: startPoint),
            sweepAngle: sweepAngle
        )
    }

    /// Creates a new circular arc that fits the given start/end points on the
    /// circumference of the arc, and a center point.
    ///
    /// The sweep angle is chosen to be the shortest sweep angle that connects
    /// startAngle to endAngle.
    ///
    /// - note: The initializer assumes that `center` is equally distant to both
    /// `startPoint` and `endPoint`.
    public init(
        center: Vector,
        startPoint: Vector,
        endPoint: Vector
    ) {
        let radius = center.distance(to: startPoint)
        let startAngle = center.angle(to: startPoint)
        let endAngle = center.angle(to: endPoint)

        let (sweepAngle1, _) = startAngle.relativeAngles(to: endAngle)

        self.init(
            center: center,
            radius: radius,
            startAngle: startAngle,
            sweepAngle: sweepAngle1
        )
    }
}

extension CircleArc2: Equatable where Vector: Equatable { }
extension CircleArc2: Hashable where Vector: Hashable { }

public extension CircleArc2 {
    /// Constructs a circle with the same center + radius as this circle arc.
    var asCircle2: Circle2<Vector> {
        .init(center: center, radius: radius)
    }

    /// Constructs an angle sweep from this arc's start and sweep angles.
    var asAngleSweep: AngleSweep<Scalar> {
        .init(start: startAngle, sweep: sweepAngle)
    }

    /// Returns the stop angle of this sweep, as the sum of `startAngle` + `sweepAngle`.
    var stopAngle: Angle<Scalar> {
        startAngle + sweepAngle
    }

    /// Computes the area of this [circular arc], when interpreted as a pie slice
    /// of a circle.
    ///
    /// [circular arc]: https://en.wikipedia.org/wiki/Circular_arc
    @inlinable
    var area: Scalar {
        (radius * radius * sweepAngle.radians) / 2
    }

    /// Computes the length of this [circular arc].
    ///
    /// [circular arc]: https://en.wikipedia.org/wiki/Circular_arc
    @inlinable
    var arcLength: Scalar {
        radius * sweepAngle.radians
    }

    /// Computes the length of the [chord] represented by this circular arc.
    ///
    /// [chord]: https://en.wikipedia.org/wiki/Chord_(geometry)
    @inlinable
    var chordLength: Scalar {
        let radii2: Scalar = radius * 2
        let halfSweep = (sweepAngle / 2)
        return radii2 * halfSweep.sin
    }

    /// Returns the starting point on this arc.
    @inlinable
    var startPoint: Vector {
        asCircle2.pointOnAngle(startAngle)
    }

    /// Returns the end point on this arc.
    @inlinable
    var endPoint: Vector {
        asCircle2.pointOnAngle(startAngle + sweepAngle)
    }

    /// Returns `true` if this circular arc contains a given angle in radians
    /// within its start + sweep region.
    @inlinable
    func contains(_ angleInRadians: Scalar) -> Bool {
        return contains(.init(radians: angleInRadians))
    }

    /// Returns `true` if this circular arc contains a given angle value within
    /// its start + sweep region.
    @inlinable
    func contains(_ angle: Angle<Scalar>) -> Bool {
        return asAngleSweep.contains(angle)
    }

    /// Clamps a given angle to be within this arc's startAngle + sweepAngle range.
    @inlinable
    func clamped(_ angle: Angle<Scalar>) -> Angle<Scalar> {
        return asAngleSweep.clamped(angle)
    }

    /// Returns a point on the circle represented by this arc on a given angle.
    @inlinable
    func pointOnAngle(_ angle: Angle<Scalar>) -> Vector {
        return asCircle2.pointOnAngle(angle)
    }
}

extension CircleArc2: LineIntersectableType {
    public func intersections<Line>(
        with line: Line
    ) -> LineIntersection<Vector> where Line : LineFloatingPoint, Vector == Line.Vector {
        let circle = self.asCircle2
        let intersections = circle.intersection(with: line).lineIntersectionPointNormals

        var result = LineIntersection<Vector>(
            isContained: false,
            intersections: []
        )

        for pointNormal in intersections {
            let angle = Angle(radians: (pointNormal.point - center).angle)

            if contains(angle) {
                result.intersections.append(
                    .point(pointNormal)
                )
            }
        }

        return result
    }
}

public extension CircleArc2 {
    /// Returns the minimal bounding box capable of fully containing this arc.
    func bounds() -> AABB<Vector> {
        let points = quadrants() + [startPoint, endPoint]

        return AABB<Vector>(points: points)
    }

    /// Returns the coordinates of the occupied quadrants that this arc sweeps
    /// through.
    ///
    /// The resulting array is up to four elements long, with each element
    /// representing an axis, from the arc's center point, in the +/- x and +/- y
    /// direction, if the arc's sweep includes that point.
    func quadrants() -> [Vector] {
        let quadrants: [Scalar] = [
            0, Scalar.pi / 2, Scalar.pi, Scalar.pi * 3 / 2
        ]
        let quadrantAngles: [Angle<Scalar>] =
            quadrants.map(Angle.init(radians:))

        var result: [Vector] = []

        let sweep = AngleSweep(start: startAngle, sweep: sweepAngle)
        for quadrant in quadrantAngles {
            if sweep.contains(quadrant) {
                result.append(pointOnAngle(quadrant))
            }
        }

        return result
    }

    /// Projects a given point to the closest point within this arc.
    func project(_ point: Vector) -> Vector {
        let angle = center.angle(to: point).radians
        let sweep = AngleSweep(start: startAngle, sweep: sweepAngle)

        // Full circle
        guard sweepAngle.magnitude < .pi * 2 else {
            let pointOnArc = self.asCircle2.project(point)

            return pointOnArc
        }

        let clamped = sweep.clamped(.init(radians: angle))

        let pointOnArc = pointOnAngle(clamped)

        return pointOnArc
    }

    /// Returns the squared distance to the closest point within this arc to the
    /// given point.
    func distanceSquared(to point: Vector) -> Scalar {
        let projected = project(point)
        return projected.distanceSquared(to: point)
    }
}
