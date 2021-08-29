import RealModule

/// Represents a 3D ellipse as a double-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3D = Ellipsoid3<Vector3D>

/// Represents a 3D ellipse as a single-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3F = Ellipsoid3<Vector3F>

/// Represents a 3D ellipse as a integer center with X, Y, and Z radii.
public typealias Ellipse3i = Ellipsoid3<Vector3i>

/// Typealias for `Ellipsoid<V>`, where `V` is constrained to `Vector3Type`.
public typealias Ellipsoid3<V: Vector3Type> = Ellipsoid<V>

public extension Ellipsoid3 {
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

public extension Ellipsoid3 where Vector: VectorReal {
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
