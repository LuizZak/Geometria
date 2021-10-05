import RealModule

/// Represents a double-precision floating-point 2D rectangle.
public typealias Rectangle2D = Rectangle2<Vector2D>

/// Represents a single-precision floating-point 2D rectangle.
public typealias Rectangle2F = Rectangle2<Vector2F>

/// Represents an integer 2D rectangle.
public typealias Rectangle2i = Rectangle2<Vector2i>

/// Typealias for `NRectangle<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Rectangle2<V: Vector2Type> = NRectangle<V>

extension Rectangle2: CustomStringConvertible {
    public var description: String {
        "\(type(of: self))(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}

public extension Rectangle2 where Vector: VectorAdditive {
    /// The x coordinate of the right corner of this rectangle.
    ///
    /// Alias for `x + width`.
    @_transparent
    var right: Scalar { x + width }
    
    /// The y coordinate of the bottom corner of this rectangle.
    ///
    /// Alias for `y + height`.
    @_transparent
    var bottom: Scalar { y + height }
    
    /// The top-right corner of the rectangle.
    @_transparent
    var topRight: Vector {
        Vector(x: right, y: top)
    }
    
    /// The bottom-left corner of the rectangle.
    @_transparent
    var bottomLeft: Vector {
        Vector(x: left, y: bottom)
    }
    
    /// The bottom-right corner of the rectangle.
    @_transparent
    var bottomRight: Vector {
        Vector(x: right, y: bottom)
    }
    
    /// Returns an array of vectors that represent this `Rectangle`'s corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    var corners: [Vector] {
        [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes a `Rectangle` with the edges of a box.
    @_transparent
    init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `right` lays on `value`.
    @inlinable
    func movingRight(to value: Scalar) -> Self {
        Self(left: value - width, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `bottom` lays on `value`.
    @inlinable
    func movingBottom(to value: Scalar) -> Self {
        Self(left: left, top: value - height, right: right, bottom: value)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and right as the current
    /// instance, where the `left` lays on `value`.
    @inlinable
    func stretchingLeft(to value: Scalar) -> Self {
        Self(left: value, top: top, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and bottom as the current
    /// instance, where the `top` lays on `value`.
    @inlinable
    func stretchingTop(to value: Scalar) -> Self {
        Self(left: left, top: value, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and left as the current
    /// instance, where the `right` lays on `value`.
    @inlinable
    func stretchingRight(to value: Scalar) -> Self {
        Self(left: left, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and top as the current
    /// instance, where the `bottom` lays on `value`.
    @inlinable
    func stretchingBottom(to value: Scalar) -> Self {
        Self(left: left, top: top, right: right, bottom: value)
    }
    
    /// Insets this Rectangle with a given set of edge inset values.
    @inlinable
    func inset(_ inset: EdgeInsets2<Vector>) -> Self {
        Self(left: left + inset.left,
             top: top + inset.top,
             right: right - inset.right,
             bottom: bottom - inset.bottom)
    }
}

public extension Rectangle2 where Vector: VectorReal {
    /// Applies the given Matrix on all corners of this Rectangle, returning a new
    /// minimal Rectangle capable of containing the transformed points.
    @_transparent
    func transformedBounds(_ matrix: Matrix3x2<Scalar>) -> Self {
        matrix.transform(self)
    }
}

public extension Rectangle2 where Vector: VectorAdditive & VectorComparable {
    /// Returns whether a given point is contained within this bounding box.
    ///
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @_transparent
    func contains(x: Scalar, y: Scalar) -> Bool {
        contains(Vector(x: x, y: y))
    }
}

public extension Rectangle2 where Vector: VectorMultiplicative {
    /// Returns a Rectangle with the same position as this Rectangle, with its
    /// width and height multiplied by the coordinates of the given vector.
    @_transparent
    func scaledBy(x: Scalar, y: Scalar) -> Self {
        scaledBy(vector: Vector(x: x, y: y))
    }
}

public extension Rectangle2 where Scalar: FloatingPoint {
    /// Initializes a Rectangle with the coordinates of a rectangle.
    @_transparent
    init<B: BinaryInteger>(x: B, y: B, width: B, height: B) {
        self.init(x: Scalar(x), y: Scalar(y), width: Scalar(width), height: Scalar(height))
    }
}

extension Rectangle2: Convex2Type where Vector: Vector2FloatingPoint {
    
}
