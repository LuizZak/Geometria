/// Represents a 3D sphere with a double-precision floating-point center point
/// and radius parameters.
public typealias Sphere3D = Sphere3<Vector3D>

/// Represents a 3D sphere with a single-precision floating-point center point
/// and radius parameters.
public typealias Sphere3F = Sphere3<Vector3F>

/// Typealias for `NSphere<V>`, where `V` is constrained to ``Vector3Type``.
public typealias Sphere3<V: Vector3Type> = NSphere<V>

extension Sphere3: Convex3Type where Vector: Vector3FloatingPoint {
    
}

extension Sphere3: ProjectiveSpace where Vector: Vector3Real {
    @inlinable
    public func attemptProjection(_ vector: Vector) -> SphereCoordinates<Scalar>? {
        if vector == center {
            return nil
        }
        
        let diff = vector - center
        
        return SphereCoordinates(azimuth: diff.azimuth, elevation: diff.elevation)
    }
    
    @inlinable
    public func projectOut(_ proj: SphereCoordinates<Scalar>) -> Vector {
        let cosEle = Scalar.cos(proj.elevation)
        let sinEle = Scalar.sin(proj.elevation)
        let cosAzi = Scalar.cos(proj.azimuth)
        let sinAzi = Scalar.sin(proj.azimuth)
        
        let x = radius * cosEle * cosAzi
        let y = radius * cosEle * sinAzi
        let z = radius * sinEle
        
        return center + Vector(x: x, y: y, z: z)
    }
}

extension Sphere3: SphereProjectiveSpace where Vector: Vector3Real {
    
}
