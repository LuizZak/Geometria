/// Represents a regular 3-dimensional [Cylinder](https://en.wikipedia.org/wiki/Cylinder)
/// as a pair of end points and a radius.
public struct Cylinder3<Vector: Vector3Type>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The starting point of this cylinder.
    public var start: Vector
    
    /// The end point of this cylinder.
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
        /// Degenerate cylinder
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
        Disk3<Vector>(center: start,
                      normal: start - end,
                      radius: radius)
    }
    
    /// Returns the disk that represents the bottom- or end, section of this
    /// cylinder, centered around ``end`` with a radius of ``radius``, and a
    /// normal pointing away from the center of the cylinder.
    @inlinable
    public var endAsDisk: Disk3<Vector> {
        Disk3<Vector>(center: end,
                      normal: end - start,
                      radius: radius)
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
        let projected = line.project(vector)
        
        // Create a disk with the same radius as this cylinder, with a normal of
        // the direction of start/end, centered around the projected point on
        // the imaginary line between start/end, and then use it's .project(_:)
        // result as a return value.
        let disk = Disk3(center: projected, normal: start - end, radius: radius)
        
        return disk.project(vector)
    }
}

extension Cylinder3: ConvexType where Vector: Vector3Real {
    /// Returns the intersection points of a given line along this cylinder's
    /// surface.
    public func intersection<Line>(with line: Line) -> ConvexLineIntersection<Vector> where Line: LineFloatingPoint, Vector == Line.Vector {
        
        typealias Vector2 = Vector.SubVector2
        
        let cylinderLine = asLineSegment
        
        let cylinderSlope = cylinderLine.lineSlope
        let lineSlope = line.lineSlope
        
        var crossSlope = cylinderSlope.cross(lineSlope).normalized()
        
        // Line is parallel to cylinder's line - choose a normal based on the
        // direction from the cylinder's center line to the line
        if crossSlope == .zero {
            crossSlope = (line.projectUnclamped(start) - start).normalized()
        }
        
        // Create a 2D version of the problem by cross-sectioning the cylinder
        // with a plane containing the line and parallel to the cylinder's axis
        // and solve a bounding-box/line intersection
        
        let pl: ProjectivePointNormalPlane3<Vector>
        pl = .makeCorrectedPlane(point: line.a,
                                 normal: crossSlope,
                                 upAxis: cylinderSlope)
        
        // Find the rectangle that represents the cylinder's cross section on
        // the plane
        
        // Rectangle's height: cylinder's height
        // Rectangle's width: 2 * √(r ^ 2 − distance-to-center ^ 2)
        let rectHeight = cylinderLine.length
        let rectHalfWidth: Scalar
        
        // The depth of the cross-section is the distance between start (or end)
        // to its projection on cross-section plane pl.
        let depthSquared = pl.project(start).distanceSquared(to: start)
        // If depth > radius, the plane is not intersecting the cylinder
        let radiusSquared = radius * radius
        if depthSquared > radiusSquared {
            return .noIntersection
        }
        
        rectHalfWidth = Scalar.sqrt(radiusSquared - depthSquared)
        
        let cylinStartProj = pl.project2D(start)
        let cylinEndProj = cylinStartProj + Vector2(x: 0, y: rectHeight) // pl.project2D(end)
        
        let aabb = AABB2<Vector2>(minimum: cylinStartProj - Vector2(x: rectHalfWidth, y: 0),
                                  maximum: cylinEndProj + Vector2(x: rectHalfWidth, y: 0))
        
        let lineAProj = pl.project2D(line.a)
        let lineBProj = pl.project2D(line.b)
        
        let line2d = LineSegment2<Vector2>(start: lineAProj, end: lineBProj)
        
        let intersection = aabb.intersection(with: line2d)
        
        func mapPointNormal(_ pn: PointNormal<Vector2>, negateNormal: Bool) -> PointNormal<Vector> {
            let worldPoint = pl.projectOut(pn.point)
            var normal = normalForVector(worldPoint)
            
            // Use the normal that has the least value (pointing towards the
            // start of the line)
            if lineSlope.dot(-normal) < lineSlope.dot(normal) {
                normal = -normal
            }
            
            return PointNormal(
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
            return .enter(mapPointNormal(pn, negateNormal: false))
            
            // TODO: Cover this case in unit tests
        case .singlePoint(let pn):
            return .singlePoint(mapPointNormal(pn, negateNormal: false))
            
        case .exit(let pn):
            return .exit(mapPointNormal(pn, negateNormal: true))
            
        case let .enterExit(pn1, pn2):
            return .enterExit(
                mapPointNormal(pn1, negateNormal: false),
                mapPointNormal(pn2, negateNormal: true)
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
