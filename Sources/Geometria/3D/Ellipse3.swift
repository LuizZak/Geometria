import RealModule

/// Represents a 3D ellipse as a double-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3D = Ellipse3<Vector3D>

/// Represents a 3D ellipse as a single-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3F = Ellipse3<Vector3F>

/// Represents a 3D ellipse as a integer center with X, Y, and Z radii.
public typealias Ellipse3i = Ellipse3<Vector3i>

/// Typealias for `Ellipsoid<V>`, where `V` is constrained to ``Vector3Type``.
public typealias Ellipse3<V: Vector3Type> = Ellipsoid<V>

public extension Ellipse3 {
    @_transparent
    var radiusX: Scalar {
        get {
            radius.x
        }
        set {
            radius.x = newValue
        }
    }
    
    @_transparent
    var radiusY: Scalar {
        get {
            radius.y
        }
        set {
            radius.y = newValue
        }
    }
    
    @_transparent
    var radiusZ: Scalar {
        get {
            radius.z
        }
        set {
            radius.z = newValue
        }
    }
}

public extension Ellipse3 where Vector: VectorReal {
    @_transparent
    init(center: Vector, radiusX: Scalar, radiusY: Scalar, radiusZ: Scalar) {
        self.init(center: center, radius: Vector(x: radiusX, y: radiusY, z: radiusZ))
    }
    
    /// Returns `true` if the point described by the given coordinates is
    /// contained within this ellipse.
    ///
    /// The method returns `true` for points that lie on the outer perimeter of
    /// the ellipse (inclusive)
    @_transparent
    func contains(x: Scalar, y: Scalar, z: Scalar) -> Bool {
        contains(Vector(x: x, y: y, z: z))
    }
}

extension Ellipse3: ProjectiveSpace where Vector: Vector3Real {
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
        let x = radius.x * Scalar.cos(proj.elevation) * Scalar.cos(proj.azimuth)
        let y = radius.y * Scalar.cos(proj.elevation) * Scalar.sin(proj.azimuth)
        let z = radius.z * Scalar.sin(proj.elevation)
        
        return Vector(x: x, y: y, z: z)
    }
}

extension Ellipse3: SphereProjectiveSpace where Vector: Vector3Real {
    
}
