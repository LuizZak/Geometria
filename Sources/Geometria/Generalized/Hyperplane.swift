/// Represents a [hyperplane](https://en.wikipedia.org/wiki/Hyperplane) with a
/// point and a normal.
///
/// In 2D, a plane equates to a line, while in 3D and higher dimensions it
/// equates to a flat 2D plane.
///
/// Hyperplanes divides the space it is contained within, producing an
/// infinitely-spanning volume of space bound at a specific point and angle.
public struct Hyperplane<Vector: VectorFloatingPoint>: GeometricType, CustomStringConvertible {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    public var description: String {
        "Hyperplane(point: \(point), normal: \(normal))"
    }
    
    /// A point on this plane.
    public var point: Vector
    
    /// The normal of the plane's surface.
    @UnitVector public var normal: Vector
    
    @_transparent
    public init(point: Vector, normal: Vector) {
        self.point = point
        self.normal = normal
    }
    
    /// Creates a ``PointNormalPlane`` that wraps the given plane object.
    @_transparent
    public init<Plane: PlaneType>(_ plane: Plane) where Plane.Vector == Vector {
        self.init(point: plane.pointOnPlane, normal: plane.normal)
    }
}

extension Hyperplane: Equatable where Vector: Equatable { }
extension Hyperplane: Hashable where Vector: Hashable { }

public extension Hyperplane {
    /// Returns a ``PointNormal`` value initialized with this plane's parameters.
    @_transparent
    var asPointNormal: PointNormal<Vector> {
        PointNormal(point: point, normal: normal)
    }
}

extension Hyperplane: PlaneType {
    @_transparent
    public var pointOnPlane: Vector { point }
}

extension Hyperplane: PointProjectablePlaneType {
    
}

extension Hyperplane: LineIntersectablePlaneType {
    
}

extension Hyperplane: ConvexType {
    /// Returns the result of a line intersection against this hyperplane.
    ///
    /// Note that hyperplanes are infinitely bounded, thus intersections with
    /// lines will consist of at most one point.
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector {
        let magnitude = unclampedNormalMagnitudeForIntersection(with: line)
        guard let magnitude = magnitude, line.containsProjectedNormalizedMagnitude(magnitude) else {
            // No intersection:

            // Figure out if line is fully contained within plane or not
            return signedDistance(to: line.a) < .zero ? .contained : .noIntersection
        }

        // Intersection:
        let point = line.projectedNormalizedMagnitude(magnitude)

        let denom = normal.dot(line.lineSlope)
        if denom < .zero {
            return .enter(.init(point: point, normal: normal))
        } else {
            return .exit(.init(point: point, normal: -normal))
        }
    }
}

extension Hyperplane: VolumetricType {
    /// Returns `true` if a given vector is contained within the enclosed space
    /// of this hyperplane.
    ///
    /// Points laying exactly on top of the plane's limit (signed distance == 0)
    /// are considered to be part of the hyperplane.
    public func contains(_ vector: Vector) -> Bool {
        return signedDistance(to: vector) >= .zero
    }
}
