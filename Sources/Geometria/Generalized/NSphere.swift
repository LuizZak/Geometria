/// Represents an N-sphere with a center point and radius.
public struct NSphere<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    public var center: Vector
    public var radius: Scalar
    
    @_transparent
    public init(center: Vector, radius: Scalar) {
        self.center = center
        self.radius = radius
    }
}

extension NSphere: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NSphere: Hashable where Vector: Hashable, Scalar: Hashable { }
extension NSphere: Encodable where Vector: Encodable, Scalar: Encodable { }
extension NSphere: Decodable where Vector: Decodable, Scalar: Decodable { }

extension NSphere: BoundableType where Vector: VectorAdditive {
    public var bounds: AABB<Vector> {
        AABB(minimum: center - radius, maximum: center + radius)
    }
}

public extension NSphere where Scalar: AdditiveArithmetic {
    @inlinable
    func expanded(by value: Scalar) -> NSphere {
        NSphere(center: center, radius: radius + value)
    }
}

public extension NSphere where Vector: VectorMultiplicative, Scalar: Comparable {
    /// Returns `true` if this N-sphere's area contains a given point by checking
    /// if the distance from the center of this N-sphere to the point is less than
    /// or equal to the radius of this N-sphere.
    ///
    /// Points at the perimeter of the N-sphere (distance to center == radius)
    /// are considered as contained within the N-sphere.
    @inlinable
    func contains(_ point: Vector) -> Bool {
        let d = point - center
        
        return d.lengthSquared <= radius * radius
    }
}

extension NSphere: ConvexType & PointProjectiveType where Vector: VectorFloatingPoint {
    /// Returns the closest point on this sphere's surface to `vector`.
    ///
    /// If `vector` == ``center``, an arbitrary point is chosen, instead.
    @inlinable
    public func project(_ vector: Vector) -> Vector {
        if vector == center {
            return Vector.one.normalized() * radius
        }
        
        return (vector - center).normalized() * radius
    }
    
    /// Returns `true` if this N-sphere's area intersects the given line type.
    @inlinable
    public func intersects<Line: LineFloatingPoint>(line: Line) -> Bool where Line.Vector == Vector {
        line.distanceSquared(to: center) <= radius * radius
    }
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// N-sphere's outer perimeter.
    @inlinable
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector {
        func normal(at point: Vector, inverted: Bool) -> Vector {
            (inverted ? center - point : point - center).normalized()
        }
        func makePointNormal(at point: Vector, inverted: Bool = false) -> PointNormal<Vector> {
            .init(
                point: point,
                normal: normal(at: point, inverted: inverted)
            )
        }
        
        let projection = line.projectAsScalar(center)
        let projected = line.projectedNormalizedMagnitude(projection)
        let d = projected.distanceSquared(to: center)
        let radiusSquared = radius * radius
        
        guard d != radiusSquared else {
            if line.containsProjectedNormalizedMagnitude(projection) {
                return .singlePoint(makePointNormal(at: projected))
            }
            
            return .noIntersection
        }
        
        guard d <= radiusSquared else {
            return .noIntersection
        }
        
        let th = (radiusSquared - d).squareRoot() / (line.a - line.b).length
        let t0 = projection - th
        let t1 = projection + th
        
        let t0p = line.projectedNormalizedMagnitude(t0)
        let t1p = line.projectedNormalizedMagnitude(t1)
        
        switch (line.containsProjectedNormalizedMagnitude(t0), line.containsProjectedNormalizedMagnitude(t1)) {
        case (true, true):
            return .enterExit(makePointNormal(at: t0p), makePointNormal(at: t1p, inverted: true))
        case (true, false):
            return .enter(makePointNormal(at: t0p))
        case (false, true):
            return .exit(makePointNormal(at: t1p, inverted: true))
        case (false, false):
            return t0.sign == t1.sign ? .noIntersection : .contained
        }
    }
}
