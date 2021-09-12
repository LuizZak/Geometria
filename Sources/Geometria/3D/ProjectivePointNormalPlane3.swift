/// Represents a 3D projective plane as a point, normal, right, and up-axis
/// vectors in 3D space with double-precision floating-point scalars.
public typealias ProjectivePointNormalPlane3D = ProjectivePointNormalPlane3<Vector3D>

/// Represents a 3D projective plane as a point, normal, right, and up-axis
/// vectors in 3D space with single-precision floating-point scalars.
public typealias ProjectivePointNormalPlane3F = ProjectivePointNormalPlane3<Vector3F>

/// A point-normal plane with a separate up and right vector used to control
/// projection on the axis of the plane and compute the local X and Y axis.
public struct ProjectivePointNormalPlane3<Vector: Vector3FloatingPoint>: PointProjectablePlaneType {
    /// A point on this plane.
    public var point: Vector
    
    /// The normal of the plane's surface.
    @UnitVector public var normal: Vector
    
    /// A normalized vector perpendicular to ``normal`` and ``rightAxis`` which
    /// defines the up, or y, axis for the projective plane.
    @UnitVector public var upAxis: Vector
    
    /// A normalized vector perpendicular to ``normal`` and ``upAxis`` which
    /// defines the right, or x, axis for the projective plane.
    ///
    /// This value is derived from ``normal`` and ``upAxis``, and is provided
    /// along with those values to reduce recomputations when handling projections.
    @UnitVector public var rightAxis: Vector
    
    @_transparent
    public var pointOnPlane: Vector { point }
    
    public init(point: Vector, normal: Vector, upAxis: Vector, rightAxis: Vector) {
        self.point = point
        self.normal = normal
        self.upAxis = upAxis
        self.rightAxis = rightAxis
    }
    
    /// Updates the value of this instance's ``point``.
    ///
    /// All other values remain the same.
    @_transparent
    public mutating func changePoint(_ point: Vector) {
        self = self.changingPoint(point)
    }
    
    /// Returns a new ``ProjectivePointNormalPlane3`` with the same ``normal``,
    /// ``upAxis``, and ``rightAxis`` as this plane's, but with ``point``
    /// swapped out to a specified value.
    @_transparent
    public func changingPoint(_ point: Vector) -> Self {
        .init(point: point, normal: normal, upAxis: upAxis, rightAxis: rightAxis)
    }
    
    /// Replaces this instance with a new ``ProjectivePointNormalPlane3`` with
    /// the same ``point``, but with ``normal``, ``upAxis``, and ``rightAxis``
    /// swapped out to specified values. The ``rightAxis`` value is computed
    /// from the provided `normal` and `upAxis` values.
    @_transparent
    public mutating func changeNormal(_ normal: Vector, upAxis: Vector) {
        self = changingNormal(normal, upAxis: upAxis)
    }
    
    /// Returns a new ``ProjectivePointNormalPlane3`` with the same ``point`` as
    /// this plane's, but with ``normal`` and ``upAxis``, and ``rightAxis``
    /// swapped out to specified values. The ``rightAxis`` value is computed
    /// from the provided `normal` and `upAxis` values.
    @_transparent
    public func changingNormal(_ normal: Vector, upAxis: Vector) -> Self {
        Self.makeCorrectedPlane(point: point, normal: normal, upAxis: upAxis)
    }
}

extension ProjectivePointNormalPlane3: Equatable where Vector: Equatable { }
extension ProjectivePointNormalPlane3: Hashable where Vector: Hashable { }

public extension ProjectivePointNormalPlane3 {
    /// Creates a new ``ProjectivePointNormalPlane3`` by computing ``rightAxis``
    /// as well as correcting ``upAxis`` during creation to ensure it is fully
    /// perpendicular to `normal`.
    ///
    /// - Parameters:
    ///   - point: The center point (origin) to this projective plane.
    ///   - normal: The normal of the plane.
    ///   - upAxis: The up-axis of the plane.
    @inlinable
    static func makeCorrectedPlane(point: Vector, normal: Vector, upAxis: Vector) -> Self {
        let normal = normal.normalized()
        let upAxis = upAxis.normalized()
        let rightAxis = normal.cross(upAxis)
        let newUpAxis = rightAxis.cross(normal)
        
        return Self(point: point, normal: normal, upAxis: newUpAxis, rightAxis: rightAxis)
    }
    
    /// Returns a point normal plane with the same point and normal as this
    /// plane's.
    var asPointNormalPlane: PointNormalPlane3<Vector> {
        return PointNormalPlane3(self)
    }
}

extension ProjectivePointNormalPlane3: ProjectiveSpace {
    public typealias Coordinates = Vector.SubVector2
    
    /// With a given line, perform a plane-line intersection and project the
    /// resulting intersection vector into this projective plane.
    ///
    /// Returns `nil` if this plane and the given line do not intersect.
    public func projectLineIntersection<Line: Line3FloatingPoint>(_ line: Line) -> Coordinates? where Line.Vector == Vector {
        let plane = asPointNormalPlane
        guard let point = plane.intersection(with: line) else {
            return nil
        }
        
        return project2D(point)
    }
   
    /// Performs a projection of a given vector onto this plane.
    public func project2D(_ vector: Vector) -> Coordinates {
        // Mathematical reference:
        // https://stackoverflow.com/a/23474396
        let diff = vector - point
        let x = diff.dot(rightAxis)
        let y = diff.dot(upAxis)
        
        return .init(x: x, y: y)
    }
    
    @inlinable
    public func attemptProjection(_ vector: Vector) -> Coordinates? {
        return project2D(vector)
    }
    
    @inlinable
    public func projectOut(_ proj: Coordinates) -> Vector {
        let x: Vector = rightAxis * proj.x
        let y: Vector = upAxis * proj.y
        return point + x + y
    }
}

extension ProjectivePointNormalPlane3: PlaneProjectiveSpace {
    
}
