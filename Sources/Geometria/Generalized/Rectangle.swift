import RealModule

/// Represents a double-precision floating-point 2D rectangle.
public typealias Rectangle2D = Rectangle<Vector2D>

/// Represents a single-precision floating-point 2D rectangle.
public typealias Rectangle2F = Rectangle<Vector2F>

/// Represents an integer 2D rectangle.
public typealias Rectangle2i = Rectangle<Vector2i>

/// Represents an N-dimensional rectangle with a vector describing its origin
/// and a size vector that describes the span of the rectangle.
public struct Rectangle<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// The top-left location of this rectangle.
    public var location: Vector
    
    /// The size of this rectangle.
    /// Must be `>= Vector.zero`
    public var size: Vector
    
    /// Initializes a Rectangle with the location + size of a rectangle.
    @inlinable
    public init(location: Vector, size: Vector) {
        self.location = location
        self.size = size
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location.
    @inlinable
    public func withLocation(_ location: Vector) -> Rectangle {
        return Rectangle(location: location, size: size)
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location.
    @inlinable
    public func withSize(_ size: Vector) -> Rectangle {
        return Rectangle(location: location, size: size)
    }
}

extension Rectangle: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Rectangle: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Rectangle: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Rectangle: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Rectangle where Vector: VectorAdditive {
    /// Returns `true` if the size of this rectangle is zero.
    @inlinable
    var isSizeZero: Bool {
        size == .zero
    }
    
    /// Minimum point for this rectangle.
    ///
    /// When set, the maximal point on the opposite corner is kept fixed.
    @inlinable
    var minimum: Vector {
        get { return location }
        set {
            let diff = newValue - minimum
            
            location = newValue
            size = size - diff
        }
    }
    
    /// Maximum point for this rectangle.
    ///
    /// When set, the minimal point on the opposite corner is kept fixed.
    @inlinable
    var maximum: Vector {
        get { return location + size }
        set {
            size = newValue - location
        }
    }
    
    /// Returns this `Rectangle` represented as a `Box`
    @inlinable
    var asBox: Box<Vector> {
        Box(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes a `Rectangle` instance out of the given minimum and maximum
    /// coordinates.
    ///
    /// - precondition: `minimum <= maximum`
    @inlinable
    init(minimum: Vector, maximum: Vector) {
        self.init(location: minimum, size: maximum - minimum)
    }
    
    /// Returns a copy of this Rectangle with the minimum and maximum coordinates
    /// offset by a given amount.
    @inlinable
    func offsetBy(_ vector: Vector) -> Rectangle {
        return Rectangle(location: location + vector, size: size)
    }
}

public extension Rectangle where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if `size >= .zero`.
    @inlinable
    var isValid: Bool {
        size >= .zero
    }
    
    /// Initializes a Rectangle containing the minimum area capable of containing
    /// all supplied points.
    ///
    /// If no points are supplied, an empty Rectangle is created instead.
    @inlinable
    init(of points: Vector...) {
        self = Rectangle(points: points)
    }
    
    /// Initializes a Rectangle out of a set of points, expanding to the
    /// smallest bounding box capable of fitting each point.
    @inlinable
    init<C: Collection>(points: C) where C.Element == Vector {
        guard let first = points.first else {
            location = .zero
            size = .zero
            return
        }
        
        location = first
        size = .zero
        
        expand(toInclude: points)
    }
    
    /// Expands the bounding box of this Rectangle to include the given point.
    @inlinable
    mutating func expand(toInclude point: Vector) {
        minimum = Vector.pointwiseMin(minimum, point)
        maximum = Vector.pointwiseMax(maximum, point)
    }
    
    /// Expands the bounding box of this Rectangle to include the given set of
    /// points.
    ///
    /// Same as calling `expand(toInclude:Vector2D)` over each point.
    /// If the array is empty, nothing is done.
    @inlinable
    mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this bounding box.
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @inlinable
    func contains(_ point: Vector) -> Bool {
        return point >= minimum && point <= maximum
    }
    
    /// Returns whether a given Rectangle rests completely inside the boundaries
    /// of this Rectangle.
    @inlinable
    func contains(rectangle: Rectangle) -> Bool {
        return rectangle.minimum >= minimum && rectangle.maximum <= maximum
    }
    
    /// Returns whether this Rectangle intersects the given Rectangle instance.
    /// This check is inclusive, so the edges of the bounding box are considered
    /// to intersect the other bounding box's edges as well.
    @inlinable
    func intersects(_ other: Rectangle) -> Bool {
        return minimum <= other.maximum && maximum >= other.minimum
    }
    
    /// Returns a Rectangle which is the minimum Rectangle that can fit this
    /// Rectangle with another given Rectangle.
    @inlinable
    func union(_ other: Rectangle) -> Rectangle {
        return Rectangle.union(self, other)
    }
    
    /// Returns a Rectangle which is the minimum Rectangle that can fit two
    /// given Rectangles.
    @inlinable
    static func union(_ left: Rectangle, _ right: Rectangle) -> Rectangle {
        return Rectangle(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
                         maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

public extension Rectangle where Vector: VectorMultiplicative {
    /// Returns an empty rectangle
    @inlinable
    static var zero: Rectangle { Rectangle(location: .zero, size: .zero) }
    
    /// Initializes an empty Rectangle instance.
    @inlinable
    init() {
        location = .zero
        size = .zero
    }
    
    /// Returns a Rectangle with the same position as this Rectangle, with its
    /// size multiplied by the coordinates of the given vector.
    @inlinable
    func scaledBy(vector: Vector) -> Rectangle {
        return Rectangle(location: location, size: size * vector)
    }
}

public extension Rectangle where Vector: VectorDivisible {
    /// Gets the center point of this Rectangle.
    @inlinable
    var center: Vector {
        get {
            return location + size / 2
        }
        set {
            location = newValue - size / 2
        }
    }
    
    /// Returns a Rectangle which is an inflated version of this Rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    @inlinable
    func inflatedBy(_ size: Vector) -> Rectangle {
        return Rectangle(minimum: minimum - size / 2, maximum: maximum + size / 2)
    }
    
    /// Returns a Rectangle which is an inset version of this Rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    @inlinable
    func insetBy(_ size: Vector) -> Rectangle {
        return Rectangle(minimum: minimum + size / 2, maximum: maximum - size / 2)
    }
    
    /// Returns a new Rectangle with the same size as the current instance,
    /// where the center of the boundaries lay on `center`.
    @inlinable
    func movingCenter(to center: Vector) -> Rectangle {
        return Rectangle(minimum: center - size / 2, maximum: center + size / 2)
    }
}

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
