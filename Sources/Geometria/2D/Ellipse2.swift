import RealModule

/// Represents a 2D ellipse as a double-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2D = Ellipsoid<Vector2D>

/// Represents a 2D ellipse as a single-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2F = Ellipsoid<Vector2F>

/// Represents a 2D ellipse as a integer center with X and Y radii.
public typealias Ellipse2i = Ellipsoid<Vector2i>

public extension Ellipsoid where Vector: Vector2Type {
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
}

public extension Ellipsoid where Vector: Vector2Type & VectorReal {
    @_transparent
    init(center: Vector, radiusX: Scalar, radiusY: Scalar) {
        self.init(center: center, radius: Vector(x: radiusX, y: radiusY))
    }
    
    /// Returns `true` if the point described by the given coordinates is
    /// contained within this ellipse.
    ///
    /// The method returns `true` for points that lie on the outer perimeter of
    /// the ellipse (inclusive)
    @_transparent
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector(x: x, y: y))
    }
}
