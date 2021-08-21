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
