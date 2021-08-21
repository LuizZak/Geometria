import RealModule

/// Represents a double-precision floating-point 2D rectangle.
public typealias Rectangle2D = Rectangle<Vector2D>

/// Represents a single-precision floating-point 2D rectangle.
public typealias Rectangle2F = Rectangle<Vector2F>

/// Represents an integer 2D rectangle.
public typealias Rectangle2i = Rectangle<Vector2i>

extension Rectangle: CustomStringConvertible where Vector: Vector2Type {
    public var description: String {
        return "\(type(of: self))(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}

public extension Rectangle where Vector: Vector2Type {
    /// Gets the X position of this Rectangle.
    @inlinable
    var x: Scalar {
        get {
            return location.x
        }
        set {
            location.x = newValue
        }
    }
    
    /// Gets the Y position of this Rectangle.
    @inlinable
    var y: Scalar {
        get {
            return location.y
        }
        set {
            location.y = newValue
        }
    }
    
    /// Gets the width of this Rectangle.
    ///
    /// When setting this value, `width` must always be `>= 0`.
    @inlinable
    var width: Scalar {
        get {
            return size.x
        }
        set {
            size.x = newValue
        }
    }
    
    /// Gets the height of this Rectangle.
    ///
    /// When setting this value, `height` must always be `>= 0`.
    @inlinable
    var height: Scalar {
        get {
            return size.y
        }
        set {
            size.y = newValue
        }
    }
    
    /// The y coordinate of the top corner of this rectangle.
    ///
    /// Alias for `y`.
    @inlinable
    var top: Scalar { y }
    
    /// The x coordinate of the left corner of this rectangle.
    ///
    /// Alias for `x`.
    @inlinable
    var left: Scalar { x }
    
    /// The top-left corner of the rectangle.
    @inlinable
    var topLeft: Vector {
        return Vector(x: left, y: top)
    }
    
    /// Initializes a Rectangle with the coordinates of a 2D rectangle.
    @inlinable
    init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        location = Vector(x: x, y: y)
        size = Vector(x: width, y: height)
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location.
    @inlinable
    func withSize(width: Scalar, height: Scalar) -> Rectangle {
        return withSize(Vector(x: width, y: height))
    }
    
    /// Returns a rectangle that matches this Rectangle's size with a new location.
    @inlinable
    func withLocation(x: Scalar, y: Scalar) -> Rectangle {
        return withLocation(Vector(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `top` lays on `value`.
    @inlinable
    func movingTop(to value: Scalar) -> Rectangle {
        return Rectangle(x: left, y: value, width: width, height: height)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `left` lays on `value`.
    @inlinable
    func movingLeft(to value: Scalar) -> Rectangle {
        return Rectangle(x: value, y: top, width: width, height: height)
    }
    
    /// Returns a `RoundRectangle` which has the same bounds as this rectangle,
    /// with the given radius vector describing the dimensions of the corner arcs
    /// on the X and Y axis.
    @inlinable
    func rounded(radius: Vector) -> RoundRectangle2<Vector> {
        return RoundRectangle2(bounds: self, radius: radius)
    }
    
    /// Returns a `RoundRectangle` which has the same bounds as this rectangle,
    /// with the given radius value describing the dimensions of the corner arcs
    /// on the X and Y axis.
    @inlinable
    func rounded(radius: Scalar) -> RoundRectangle2<Vector> {
        return RoundRectangle2(bounds: self, radiusX: radius, radiusY: radius)
    }
}

public extension Rectangle where Vector: Vector2Type & VectorAdditive {
    /// The x coordinate of the right corner of this rectangle.
    ///
    /// Alias for `x + width`.
    @inlinable
    var right: Scalar { x + width }
    
    /// The y coordinate of the bottom corner of this rectangle.
    ///
    /// Alias for `y + height`.
    @inlinable
    var bottom: Scalar { y + height }
    
    /// The top-right corner of the rectangle.
    @inlinable
    var topRight: Vector {
        return Vector(x: right, y: top)
    }
    
    /// The bottom-left corner of the rectangle.
    @inlinable
    var bottomLeft: Vector {
        return Vector(x: left, y: bottom)
    }
    
    /// The bottom-right corner of the rectangle.
    @inlinable
    var bottomRight: Vector {
        return Vector(x: right, y: bottom)
    }
    
    /// Returns an array of vectors that represent this `Rectangle`'s corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    var corners: [Vector] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes a `Rectangle` with the edges of a box.
    @inlinable
    init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    /// Returns a copy of this Rectangle with the minimum and maximum coordinates
    /// offset by a given amount.
    @inlinable
    func offsetBy(x: Scalar, y: Scalar) -> Rectangle {
        return offsetBy(Vector(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `right` lays on `value`.
    @inlinable
    func movingRight(to value: Scalar) -> Rectangle {
        return Rectangle(left: value - width, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `bottom` lays on `value`.
    @inlinable
    func movingBottom(to value: Scalar) -> Rectangle {
        return Rectangle(left: left, top: value - height, right: right, bottom: value)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and right as the current
    /// instance, where the `left` lays on `value`.
    @inlinable
    func stretchingLeft(to value: Scalar) -> Rectangle {
        return Rectangle(left: value, top: top, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and bottom as the current
    /// instance, where the `top` lays on `value`.
    @inlinable
    func stretchingTop(to value: Scalar) -> Rectangle {
        return Rectangle(left: left, top: value, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and left as the current
    /// instance, where the `right` lays on `value`.
    @inlinable
    func stretchingRight(to value: Scalar) -> Rectangle {
        return Rectangle(left: left, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and top as the current
    /// instance, where the `bottom` lays on `value`.
    @inlinable
    func stretchingBottom(to value: Scalar) -> Rectangle {
        return Rectangle(left: left, top: top, right: right, bottom: value)
    }
    
    /// Insets this Rectangle with a given set of edge inset values.
    @inlinable
    func inset(_ inset: EdgeInsets2<Vector>) -> Rectangle {
        return Rectangle(left: left + inset.left,
                         top: top + inset.top,
                         right: right - inset.right,
                         bottom: bottom - inset.bottom)
    }
}

public extension Rectangle where Vector: Vector2Type & VectorAdditive & VectorComparable, Scalar: Real {
    /// Applies the given Matrix on all corners of this Rectangle, returning a new
    /// minimal Rectangle capable of containing the transformed points.
    func transformedBounds(_ matrix: Matrix2<Scalar>) -> Rectangle<Vector> {
        return matrix.transform(self)
    }
}

public extension Rectangle where Vector: Vector2Type & VectorAdditive & VectorComparable {
    /// Returns whether a given point is contained within this bounding box.
    ///
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @inlinable
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector(x: x, y: y))
    }
}

public extension Rectangle where Vector: Vector2Type & VectorMultiplicative {
    /// Returns a Rectangle with the same position as this Rectangle, with its
    /// width and height multiplied by the coordinates of the given vector.
    @inlinable
    func scaledBy(x: Scalar, y: Scalar) -> Rectangle {
        return scaledBy(vector: Vector(x: x, y: y))
    }
}

public extension Rectangle where Vector: Vector2Type & VectorDivisible {
    /// Gets the center X position of this Rectangle.
    @inlinable
    var centerX: Scalar {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// Gets the center Y position of this Rectangle.
    @inlinable
    var centerY: Scalar {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    /// Returns a Rectangle which is an inflated version of this Rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    @inlinable
    func inflatedBy(x: Scalar, y: Scalar) -> Rectangle {
        return inflatedBy(Vector(x: x, y: y))
    }
    
    /// Returns a Rectangle which is an inset version of this Rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    @inlinable
    func insetBy(x: Scalar, y: Scalar) -> Rectangle {
        return insetBy(Vector(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same width and height as the current
    /// instance, where the center of the boundaries lay on the coordinates
    /// composed of `[x, y]`.
    @inlinable
    func movingCenter(toX x: Scalar, y: Scalar) -> Rectangle {
        return movingCenter(to: Vector(x: x, y: y))
    }
}

public extension Rectangle where Vector: Vector2Type, Scalar: FloatingPoint {
    /// Initializes a Rectangle with the coordinates of a rectangle.
    @inlinable
    init<B: BinaryInteger>(x: B, y: B, width: B, height: B) {
        self.init(x: Scalar(x), y: Scalar(y), width: Scalar(width), height: Scalar(height))
    }
}

public extension Rectangle where Vector: Vector2Type & VectorMultiplicative, Scalar: Comparable {
    /// Returns an `Rectangle` that is the intersection between this and another
    /// `Rectangle` instance.
    ///
    /// Return is `nil`, if they do not intersect.
    @inlinable
    func intersection(_ other: Rectangle) -> Rectangle? {
        return Rectangle.intersect(self, other)
    }
    
    /// Returns an `Rectangle` that is the intersection between two rectangle
    /// instances.
    ///
    /// Return is `nil`, if they do not intersect.
    @inlinable
    static func intersect(_ a: Rectangle, _ b: Rectangle) -> Rectangle? {
        let x1 = max(a.left, b.left)
        let x2 = min(a.right, b.right)
        let y1 = max(a.top, b.top)
        let y2 = min(a.bottom, b.bottom)
        
        if x2 >= x1 && y2 >= y1 {
            return Rectangle(left: x1, top: y1, right: x2, bottom: y2)
        }
        
        return nil
    }
}
