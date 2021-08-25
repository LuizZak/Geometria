import RealModule

/// Represents a 3D ellipse as a double-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3D = Ellipsoid<Vector3D>

/// Represents a 3D ellipse as a single-precision floating-point center with X,
/// Y, and Z radii.
public typealias Ellipse3F = Ellipsoid<Vector3F>

/// Represents a 3D ellipse as a integer center with X, Y, and Z radii.
public typealias Ellipse3i = Ellipsoid<Vector3i>

public extension Ellipsoid where Vector: Vector3Type {
    @_transparent
    var radiusX: Scalar {
        get {
            return radius.x
        }
        set {
            radius.x = newValue
        }
    }
    
    @_transparent
    var radiusY: Scalar {
        get {
            return radius.y
        }
        set {
            radius.y = newValue
        }
    }
    
    @_transparent
    var radiusZ: Scalar {
        get {
            return radius.z
        }
        set {
            radius.z = newValue
        }
    }
}

public extension Ellipsoid where Vector: Vector3Type & VectorReal {
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
        return contains(Vector(x: x, y: y, z: z))
    }
}
