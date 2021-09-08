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

public extension Cylinder3 {
    /// Returns a line segment with the same ``LineSegment/start`` and
    /// ``LineSegment/end`` points of this cylinder.
    @_transparent
    var asLineSegment: LineSegment<Vector> {
        LineSegment(start: start, end: end)
    }
}

extension Cylinder3: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Cylinder3: Hashable where Vector: Hashable, Scalar: Hashable { }

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
