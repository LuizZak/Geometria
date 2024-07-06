// TODO: Consider relaxing validity checks to allow definition of cylinders where
// TODO: start == end (and project as a disk, like a 2-Stadium can be a sphere.)

/// Represents a regular 3-dimensional [Cylinder](https://en.wikipedia.org/wiki/Cylinder)
/// as a pair of end points and a radius with double-precision floating-point
/// numbers.
public typealias Cylinder3D = Cylinder3<Vector3D>

/// Represents a regular 3-dimensional [Cylinder](https://en.wikipedia.org/wiki/Cylinder)
/// as a pair of end points and a radius with double-precision floating-point
/// numbers.
public typealias Cylinder3F = Cylinder3<Vector3F>

/// Represents a regular 3-dimensional [Cylinder](https://en.wikipedia.org/wiki/Cylinder)
/// as a pair of end points and a radius with integers.
public typealias Cylinder3i = Cylinder3<Vector3i>

/// Represents a regular 3-dimensional [Cylinder](https://en.wikipedia.org/wiki/Cylinder)
/// as a pair of end points and a radius.
public struct Cylinder3<Vector: Vector3Type>: GeometricType {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar

    /// The starting point of this cylinder.
    public var start: Vector

    /// The end point of this cylinder
    public var end: Vector

    /// The radius of this cylinder.
    public var radius: Scalar

    public init(start: Vector, end: Vector, radius: Scalar) {
        self.start = start
        self.end = end
        self.radius = radius
    }
}

extension Cylinder3: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Cylinder3: Hashable where Vector: Hashable, Scalar: Hashable { }

public extension Cylinder3 {
    /// Returns a line segment with the same ``LineSegment/start`` and
    /// ``LineSegment/end`` points of this cylinder.
    @_transparent
    var asLineSegment: LineSegment<Vector> {
        LineSegment(start: start, end: end)
    }

    /// Returns a ``Capsule3`` with the same ``start``, ``end``, and ``radius``
    /// parameter sas this cylinder.
    @_transparent
    var asCapsule: Capsule3<Vector> {
        Capsule3(start: start, end: end, radius: radius)
    }
}

public extension Cylinder3 where Vector: Equatable, Scalar: Comparable & AdditiveArithmetic {
    /// Returns whether this cylinder's parameters produce a valid, non-empty
    /// cylinder.
    ///
    /// A cylinder is valid when ``start`` != ``end`` and ``radius`` is greater
    /// than zero.
    @_transparent
    var isValid: Bool {
        start != end && radius > .zero
    }
}

extension Cylinder3: BoundableType where Vector: Vector3FloatingPoint {
    @inlinable
    public var bounds: AABB<Vector> {
        // Degenerate cylinder
        if start == end {
            return .zero
        }

        return startAsDisk.bounds.union(endAsDisk.bounds)
    }
}

extension Cylinder3: VolumetricType where Vector: Vector3FloatingPoint {
    /// Returns the disk that represents the top- or start, section of this
    /// cylinder, centered around ``start`` with a radius of ``radius``, and a
    /// normal pointing away from the center of the cylinder.
    @inlinable
    public var startAsDisk: Disk3<Vector> {
        Disk3<Vector>(
            center: start,
            normal: start - end,
            radius: radius
        )
    }

    /// Returns the disk that represents the bottom- or end, section of this
    /// cylinder, centered around ``end`` with a radius of ``radius``, and a
    /// normal pointing away from the center of the cylinder.
    @inlinable
    public var endAsDisk: Disk3<Vector> {
        Disk3<Vector>(
            center: end,
            normal: end - start,
            radius: radius
        )
    }

    /// Returns `true` if a given vector is fully contained within this
    /// cylinder.
    ///
    /// Points at the perimeter of the cylinder are considered as contained
    /// within the cylinder (inclusive).
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        let line = asLineSegment

        let magnitude = line.projectAsScalar(vector)
        if !line.containsProjectedNormalizedMagnitude(magnitude) {
            return false
        }

        let pointOnLine = line.projectedNormalizedMagnitude(magnitude)

        return pointOnLine.distanceSquared(to: vector) <= radius * radius
    }
}

extension Cylinder3: PointProjectableType where Vector: Vector3FloatingPoint {
    /// Projects a given point onto this cylinder, returning the closest point
    /// on the outer surface of the cylinder to `vector`.
    @inlinable
    public func project(_ vector: Vector) -> Vector {
        let line = asLineSegment
        let projectedScalar = line.projectAsScalar(vector)
        let projected = line.project(vector)

        // If the point when projected onto the line is within its bounds,
        // compute a direction to the vector and return a point on the radius
        // of the cylinder.
        if line.containsProjectedNormalizedMagnitude(projectedScalar) {
            var direction = (vector - projected)
            // Can choose any axis here
            if direction == .zero {
                direction = .unitX
            }

            let onEdge = projected + direction.normalized() * radius
            let onEdgeDist = vector.distanceSquared(to: onEdge)

            // Check that the point is not closer to one of the ends of the
            // cylinder instead of the edges
            let onStartDisk = startAsDisk.project(vector)
            if onStartDisk.distanceSquared(to: vector) < onEdgeDist {
                return onStartDisk
            }
            let onEndDisk = endAsDisk.project(vector)
            if onEndDisk.distanceSquared(to: vector) < onEdgeDist {
                return onEndDisk
            }

            return onEdge
        }

        // Create a disk with the same radius as this cylinder, with a normal of
        // the direction of start/end, centered around the projected point on
        // the imaginary line between start/end, and then use it's .project(_:)
        // result as a return value.
        let disk = Disk3(center: projected, normal: start - end, radius: radius)
        return disk.project(vector)
    }
}

extension Cylinder3: SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    @inlinable
    public func signedDistance(to point: Vector) -> Vector.Scalar {
        // Derived from:
        // https://iquilezles.org/www/articles/distfunctions/distfunctions.htm

        let ba = end - start
        let pa = point - start
        let baba: Scalar = ba.lengthSquared
        let paba: Scalar = pa.dot(ba)
        let half: Scalar = 1 / 2
        let x: Scalar = ((pa * baba) as Vector - (ba * paba) as Vector).length - (radius * baba) as Scalar
        let y: Scalar = abs(paba - baba * half) as Scalar - (baba * half) as Scalar
        let x2: Scalar = x * x
        let y2: Scalar = y * y * baba
        let d: Scalar
        if max(x, y) < .zero {
            d = -min(x2, y2)
        } else {
            d = ((x > .zero) ? x2 : .zero) + ((y > .zero) ? y2 : .zero)
        }

        return d.signValue * abs(d).squareRoot() / baba
    }
}

extension Cylinder3: Convex3Type where Vector: Vector3Real {
    /// Returns the intersection points of a given line along this cylinder's
    /// surface.
    public func intersection<Line>(with line: Line) -> ConvexLineIntersection<Vector> where Line: Line3FloatingPoint, Vector == Line.Vector {

        // Procedure:
        // 1: Create a plane along the line
        // 2: Pin the normal of this plane to the perpendicular of the cylinder's
        //    line
        // 3: Project cylinder onto plane as an AABB
        // 4: Perform 2D line-aabb intersection
        // 5: Compute 3D coordinates and normal

        typealias Vector2 = Vector.SubVector2
        typealias Line2 = Line.SubLine2

        let cylinderLine = asLineSegment

        let cylinderSlope: Vector = cylinderLine.lineSlope
        let lineSlope: Vector = line.lineSlope

        var crossSlope: Vector = cylinderSlope.cross(lineSlope).normalized()

        // Line is parallel to cylinder's line - choose a normal based on the
        // direction from the cylinder's center line to the line
        if crossSlope == .zero {
            crossSlope = (line.projectUnclamped(start) - start).normalized()
        }

        // Create a 2D version of the problem by cross-sectioning the cylinder
        // with a plane which is parallel to both the line and the cylinder's
        // axis and solve a bounding-box/line intersection

        let pl = ProjectivePointNormalPlane3<Vector>
            .makeCorrectedPlane(
                point: line.a,
                normal: crossSlope,
                upAxis: cylinderSlope
            )

        // Find the rectangle that represents the cylinder's cross section on
        // the plane

        // Rectangle's height: cylinder's height
        // Rectangle's width: 2 * √(r² − distance-to-center²)
        let rectHeight = cylinderLine.length
        let rectHalfWidth: Scalar

        // The depth of the cross-section is the distance between start (or end)
        // to its projection on cross-section plane pl.
        let depthSquared: Scalar = pl.project(start).distanceSquared(to: start)
        // If depth > radius, the plane is not intersecting the cylinder
        let radiusSquared: Scalar = radius * radius
        if depthSquared > radiusSquared {
            return .noIntersection
        }

        rectHalfWidth = Scalar.sqrt(radiusSquared - depthSquared)

        let cylStartProj: Vector2 = pl.project2D(start)
        let cylEndProj: Vector2 = cylStartProj + Vector2(x: 0, y: rectHeight)

        let aabb = AABB2<Vector2>(
            minimum: cylStartProj - Vector2(x: rectHalfWidth, y: 0),
            maximum: cylEndProj + Vector2(x: rectHalfWidth, y: 0)
        )

        let lineAProj = pl.project2D(line.a)
        let lineBProj = pl.project2D(line.b)

        let line2d: Line2 = Line.make2DLine(lineAProj, lineBProj)

        let intersection: ConvexLineIntersection<Vector2> = aabb.intersection(with: line2d)

        func mapPointNormal(_ pn: LineIntersectionPointNormal<Vector2>) -> LineIntersectionPointNormal<Vector> {
            let worldPoint: Vector = pl.projectOut(pn.point)
            var normal: Vector = normalForVector(worldPoint)

            // Use the normal that has the least value (pointing towards the
            // start of the line)
            if lineSlope.dot(-normal) < lineSlope.dot(normal) {
                normal = -normal
            }

            return LineIntersectionPointNormal(
                normalizedMagnitude: pn.normalizedMagnitude,
                point: worldPoint,
                normal: normal
            )
        }

        switch intersection {
        case .noIntersection:
            return .noIntersection

        case .contained:
            return .contained

        case .enter(let pn):
            return .enter(mapPointNormal(pn))

            // TODO: Cover this case in unit tests
        case .singlePoint(let pn):
            return .singlePoint(mapPointNormal(pn))

        case .exit(let pn):
            return .exit(mapPointNormal(pn))

        case let .enterExit(pn1, pn2):
            return .enterExit(
                mapPointNormal(pn1),
                mapPointNormal(pn2)
            )
        }
    }

    /// Returns the normal of the face closest to the given vector.
    @inlinable
    func normalForVector(_ vector: Vector) -> Vector {
        let line = asLineSegment
        let magnitude = line.projectAsScalar(vector)

        if magnitude <= 0 {
            return -line.lineSlope.normalized()
        }
        if magnitude >= 1 {
            return line.lineSlope.normalized()
        }

        let onLine = line.projectedNormalizedMagnitude(magnitude)
        return (vector - onLine).normalized()
    }
}
