import RealModule

/// Represents a 2D ellipse as a double-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2D = Ellipse2<Vector2D>

/// Represents a 2D ellipse as a single-precision floating-point center with X
/// and Y radii.
public typealias Ellipse2F = Ellipse2<Vector2F>

/// Represents a 2D ellipse as a integer center with X and Y radii.
public typealias Ellipse2i = Ellipse2<Vector2i>

/// Typealias for `Ellipsoid<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Ellipse2<V: Vector2Type> = Ellipsoid<V>

public extension Ellipse2 {
    @_transparent
    var radiusX: Scalar {
        get { radius.x }
        set { radius.x = newValue }
    }
    
    @_transparent
    var radiusY: Scalar {
        get { radius.y }
        set { radius.y = newValue }
    }
}

public extension Ellipse2 where Vector: VectorReal {
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
        contains(Vector(x: x, y: y))
    }
}
