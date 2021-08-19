/// Describes a double-precision floating-point 2D rectangle
public typealias Rectangle2D = Rectangle2<Double>

/// Describes a single-precision floating-point 2D rectangle
public typealias Rectangle2F = Rectangle2<Float>

/// Describes a 2D rectangle
public struct Rectangle2<Scalar: VectorScalar>: Equatable, Codable {
    /// Returns an empty rectangle
    public static var zero: Rectangle2 { Rectangle2(x: 0, y: 0, width: 0, height: 0) }
    
    /// Minimum point for this rectangle.
    public var minimum: Vector2<Scalar> {
        get { return topLeft }
        set {
            let diff = newValue - minimum
            
            (x, y) = (newValue.x, newValue.y)
            (width, height) = (width - diff.x, height - diff.y)
        }
    }
    
    /// Maximum point for this rectangle.
    public var maximum: Vector2<Scalar> {
        get { return bottomRight }
        set {
            width = newValue.x - x
            height = newValue.y - y
        }
    }
    
    /// The top-left location of this rectangle
    public var location: Vector2<Scalar>
    
    /// The size of this rectangle
    public var size: Vector2<Scalar>
    
    /// Gets the X position of this Rectangle
    @inlinable
    public var x: Scalar {
        get {
            return location.x
        }
        set {
            location.x = newValue
        }
    }
    
    /// Gets the Y position of this Rectangle
    @inlinable
    public var y: Scalar {
        get {
            return location.y
        }
        set {
            location.y = newValue
        }
    }
    
    /// Gets the width of this Rectangle.
    ///
    /// When setting this value, `width` must always be `>= 0`
    @inlinable
    public var width: Scalar {
        get {
            return size.x
        }
        set {
            size.x = newValue
        }
    }
    
    /// Gets the height of this Rectangle
    ///
    /// When setting this value, `height` must always be `>= 0`
    public var height: Scalar {
        get {
            return size.y
        }
        set {
            size.y = newValue
        }
    }
    
    /// Returns true iff this Rectangle's area is empty (i.e. `width == 0 && height == 0`).
    public var isEmpty: Bool {
        return width == 0 && height == 0
    }
    
    /// The y coordinate of the top corner of this rectangle.
    ///
    /// Alias for `y`
    @inlinable
    public var top: Scalar { y }
    
    /// The x coordinate of the left corner of this rectangle.
    ///
    /// Alias for `x`
    @inlinable
    public var left: Scalar { x }
    
    /// The x coordinate of the right corner of this rectangle.
    ///
    /// Alias for `x + width`
    @inlinable
    public var right: Scalar { x + width }
    
    /// The y coordinate of the bottom corner of this rectangle.
    ///
    /// Alias for `y + height`
    @inlinable
    public var bottom: Scalar { y + height }
    
    @inlinable
    public var topLeft: Vector2<Scalar> {
        return Vector2<Scalar>(x: left, y: top)
    }
    
    @inlinable
    public var topRight: Vector2<Scalar> {
        return Vector2<Scalar>(x: right, y: top)
    }
    
    @inlinable
    public var bottomLeft: Vector2<Scalar> {
        return Vector2<Scalar>(x: left, y: bottom)
    }
    
    @inlinable
    public var bottomRight: Vector2<Scalar> {
        return Vector2<Scalar>(x: right, y: bottom)
    }
    
    /// Returns an array of vectors that represent this `Rectangle`'s corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    public var corners: [Vector2<Scalar>] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes an empty Rectangle instance
    @inlinable
    public init() {
        location = .zero
        size = .zero
    }
    
    /// Initializes a Rectangle containing the minimum area capable of containing
    /// all supplied points.
    ///
    /// If no points are supplied, an empty Rectangle is created instead.
    @inlinable
    public init(of points: Vector2<Scalar>...) {
        self = Rectangle2(points: points)
    }
    
    /// Initializes a Rectangle instance out of the given minimum and maximum
    /// coordinates.
    /// The coordinates are not checked for ordering, and will be directly
    /// assigned to `minimum` and `maximum` properties.
    @inlinable
    public init(min: Vector2<Scalar>, max: Vector2<Scalar>) {
        location = min
        size = max - min
    }
    
    /// Initializes a Rectangle with the coordinates of a rectangle
    @inlinable
    public init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        location = Vector2<Scalar>(x: x, y: y)
        size = Vector2<Scalar>(x: width, y: height)
    }
    
    /// Initializes a Rectangle with the location + size of a rectangle
    @inlinable
    public init(location: Vector2<Scalar>, size: Vector2<Scalar>) {
        self.location = location
        self.size = size
    }
    
    /// Initializes a Rectangle with the corners of a rectangle
    @inlinable
    public init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    /// Initializes a Rectangle out of a set of points, expanding to the
    /// smallest bounding box capable of fitting each point.
    public init<C: Collection>(points: C) where C.Element == Vector2<Scalar> {
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
    public mutating func expand(toInclude point: Vector2<Scalar>) {
        minimum = min(minimum, point)
        maximum = max(maximum, point)
    }
    
    /// Expands the bounding box of this Rectangle to include the given set of
    /// points.
    ///
    /// Same as calling `expand(toInclude:Vector2D)` over each point.
    /// If the array is empty, nothing is done.
    public mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector2<Scalar> {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this bounding box.
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @inlinable
    public func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns whether a given point is contained within this bounding box.
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @inlinable
    public func contains(_ point: Vector2<Scalar>) -> Bool {
        return point >= minimum && point <= maximum
    }
    
    /// Returns whether a given Rectangle rests completely inside the boundaries
    /// of this Rectangle.
    @inlinable
    public func contains(rectangle: Rectangle2) -> Bool {
        return rectangle.minimum >= minimum && rectangle.maximum <= maximum
    }
    
    /// Returns whether this Rectangle intersects the given Rectangle instance.
    /// This check is inclusive, so the edges of the bounding box are considered
    /// to intersect the other bounding box's edges as well.
    @inlinable
    public func intersects(_ box: Rectangle2) -> Bool {
        return minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location
    @inlinable
    public func withLocation(_ location: Vector2<Scalar>) -> Rectangle2 {
        return Rectangle2(location: location, size: size)
    }
    
    /// Returns a rectangle that matches this Rectangle's size with a new location
    @inlinable
    public func withLocation(x: Scalar, y: Scalar) -> Rectangle2 {
        return withLocation(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location
    @inlinable
    public func withSize(_ size: Vector2<Scalar>) -> Rectangle2 {
        return Rectangle2(location: minimum, size: size)
    }
    
    /// Returns a Rectangle that matches this Rectangle's size with a new location
    @inlinable
    public func withSize(width: Scalar, height: Scalar) -> Rectangle2 {
        return withSize(Vector2<Scalar>(x: width, y: height))
    }
    
    /// Returns a Rectangle with the same position as this Rectangle, with its
    /// width and height multiplied by the coordinates of the given vector
    @inlinable
    public func scaledBy(vector: Vector2<Scalar>) -> Rectangle2 {
        return scaledBy(x: vector.x, y: vector.y)
    }
    
    /// Returns a Rectangle with the same position as this Rectangle, with its
    /// width and height multiplied by the coordinates of the given vector
    @inlinable
    public func scaledBy(x: Scalar, y: Scalar) -> Rectangle2 {
        return Rectangle2(x: x, y: y, width: width * x, height: height * y)
    }
    
    /// Returns a copy of this Rectangle with the minimum and maximum coordinates
    /// offset by a given amount.
    @inlinable
    public func offsetBy(_ vector: Vector2<Scalar>) -> Rectangle2 {
        return Rectangle2(location: location + vector, size: size)
    }
    
    /// Returns a copy of this Rectangle with the minimum and maximum coordinates
    /// offset by a given amount.
    @inlinable
    public func offsetBy(x: Scalar, y: Scalar) -> Rectangle2 {
        return offsetBy(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns a Rectangle which is the minimum Rectangle that can fit this
    /// Rectangle with another given Rectangle.
    @inlinable
    public func union(_ other: Rectangle2) -> Rectangle2 {
        return Rectangle2.union(self, other)
    }
    
    /// Returns an `Rectangle` that is the intersection between this and another
    /// `Rectangle` instance.
    ///
    /// Result is an empty Rectangle if the two rectangles do not intersect
    @inlinable
    public func intersection(_ other: Rectangle2) -> Rectangle2 {
        return Rectangle2.intersect(self, other)
    }
    
    /// Insets this Rectangle with a given set of edge inset values.
    public func inset(_ inset: EdgeInsets2<Scalar>) -> Rectangle2 {
        return Rectangle2(left: left + inset.left,
                          top: top + inset.top,
                          right: right - inset.right,
                          bottom: bottom - inset.bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `top` lays on `value`.
    public func movingTop(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: left, top: value, right: right, bottom: value + height)
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `bottom` lays on `value`.
    public func movingBottom(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: left, top: value - height, right: right, bottom: value)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `left` lays on `value`.
    public func movingLeft(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: value, top: top, right: value + width, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `right` lays on `value`.
    public func movingRight(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: value - width, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and bottom as the current
    /// instance, where the `top` lays on `value`.
    public func stretchingTop(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: left, top: value, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same left, right, and top as the current
    /// instance, where the `bottom` lays on `value`.
    public func stretchingBottom(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: left, top: top, right: right, bottom: value)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and right as the current
    /// instance, where the `left` lays on `value`.
    public func stretchingLeft(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: value, top: top, right: right, bottom: bottom)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and left as the current
    /// instance, where the `right` lays on `value`.
    public func stretchingRight(to value: Scalar) -> Rectangle2 {
        return Rectangle2(left: left, top: top, right: value, bottom: bottom)
    }
    
    /// Returns a Rectangle which is the minimum Rectangle that can fit two
    /// given Rectangles.
    @inlinable
    public static func union(_ left: Rectangle2, _ right: Rectangle2) -> Rectangle2 {
        return Rectangle2(min: min(left.minimum, right.minimum), max: max(left.maximum, right.maximum))
    }
    
    /// Returns an `Rectangle` that is the intersection between two rectangle
    /// instances.
    ///
    /// Return is `zero`, if they do not intersect.
    @inlinable
    public static func intersect(_ a: Rectangle2, _ b: Rectangle2) -> Rectangle2 {
        let x1 = max(a.left, b.left)
        let x2 = min(a.right, b.right)
        let y1 = max(a.top, b.top)
        let y2 = min(a.bottom, b.bottom)
        
        if x2 >= x1 && y2 >= y1 {
            return Rectangle2(left: x1, top: y1, right: x2, bottom: y2)
        }
        
        return .zero
    }
}

public extension Rectangle2 where Scalar: DivisibleArithmetic {
    /// Gets the middle X position of this Rectangle
    @inlinable
    var midX: Scalar {
        return center.x
    }
    /// Gets the middle Y position of this Rectangle
    @inlinable
    var midY: Scalar {
        return center.y
    }
    
    @inlinable
    var center: Vector2<Scalar> {
        get {
            return location + size / 2
        }
        set {
            location = newValue - size / 2
        }
    }
    
    /// Returns a Rectangle which is an inflated version of this Rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same)
    @inlinable
    func inflatedBy(_ size: Vector2<Scalar>) -> Rectangle2 {
        if size == .zero {
            return self
        }
        
        return Rectangle2(min: minimum - size / 2, max: maximum + size / 2)
    }
    
    /// Returns a Rectangle which is an inflated version of this Rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same)
    @inlinable
    func inflatedBy(x: Scalar, y: Scalar) -> Rectangle2 {
        return inflatedBy(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns a Rectangle which is an inset version of this Rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same)
    @inlinable
    func insetBy(_ size: Vector2<Scalar>) -> Rectangle2 {
        if size == .zero {
            return self
        }
        
        return Rectangle2(min: minimum + size / 2, max: maximum - size / 2)
    }
    
    /// Returns a Rectangle which is an inset version of this Rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same)
    @inlinable
    func insetBy(x: Scalar, y: Scalar) -> Rectangle2 {
        return insetBy(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same width and height as the current
    /// instance, where the center of the boundaries lay on the coordinates
    /// composed of `[x, y]`
    @inlinable
    func movingCenter(toX x: Scalar, y: Scalar) -> Rectangle2 {
        return movingCenter(to: Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same width and height as the current
    /// instance, where the center of the boundaries lay on `center`
    @inlinable
    func movingCenter(to center: Vector2<Scalar>) -> Rectangle2 {
        return Rectangle2(min: center - size / 2, max: center + size / 2)
    }
}

public extension Rectangle2 where Scalar: FloatingPoint {
    /// Initializes a Rectangle with the coordinates of a rectangle
    @inlinable
    init<B: BinaryInteger>(x: B, y: B, width: B, height: B) {
        self.init(x: Scalar(x), y: Scalar(y), width: Scalar(width), height: Scalar(height))
    }
}

public extension Rectangle2 where Scalar == Double {
    /// Applies the given Matrix on all corners of this Rectangle, returning a new
    /// minimal Rectangle capable of containing the transformed points.
    func transformedBounds(_ matrix: Matrix2D) -> Rectangle2D {
        return matrix.transform(self)
    }
}

extension Rectangle2: CustomStringConvertible {
    public var description: String {
        return "\(type(of: self))(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}

public extension Rectangle2 {
    /// Returns a `RoundRectangle` which has the same bounds as this rectangle,
    /// with the given radius vector describing the dimensions of the corner arcs
    /// on the X and Y axis.
    func rounded(radius: Vector2<Scalar>) -> RoundRectangle2<Scalar> {
        return RoundRectangle2(bounds: self, radius: radius)
    }
    
    /// Returns a `RoundRectangle` which has the same bounds as this rectangle,
    /// with the given radius value describing the dimensions of the corner arcs
    /// on the X and Y axis.
    func rounded(radius: Scalar) -> RoundRectangle2<Scalar> {
        return RoundRectangle2(bounds: self, radiusX: radius, radiusY: radius)
    }
}
