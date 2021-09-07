/// Represents a plane type that has support for point-projection.
public protocol PointProjectablePlaneType: PlaneType, PointProjectableType {
    /// Returns the signed distance of a given point to this plane.
    ///
    /// By offsetting the point by -(signed distance x ``PlaneType/normal``), the
    /// projected point on the plane is retrieved.
    func signedDistance(to vector: Vector) -> Vector.Scalar
}

extension PointProjectablePlaneType {
    @inlinable
    public func signedDistance(to vector: Vector) -> Vector.Scalar {
        let v = vector - pointOnPlane
        
        return v.dot(normal)
    }
    
    /// Projects a given vector on this plane.
    ///
    /// Returns the closest point on this plane to `vector`.
    @inlinable
    public func project(_ vector: Vector) -> Vector {
        let d = signedDistance(to: vector)
        
        return vector.addingProduct(-d, normal)
    }
}
