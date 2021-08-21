/// Represents a 2D box with two double-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2D = Box<Vector2D>

/// Represents a 2D box with two single-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2F = Box<Vector2F>

/// Represents a 2D box with two integer vectors that describe the minimal and
/// maximal coordinates of the box's opposite corners.
public typealias Box2i = Box<Vector2i>

/// Represents a box with two N-dimensional vectors that describe the minimal
/// and maximal coordinates of the box's opposite corners.
public struct Box<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// The minimal coordinate of this box.
    /// Must be `<= maximum`.
    public var minimum: Vector
    
    /// The maximal coordinate of this box.
    /// Must be `>= minimum`.
    public var maximum: Vector
    
    /// The location of this Box corresponding to its minimal vector.
    /// Alias for `minimum`.
    public var location: Vector { minimum }
    
    /// Initializes a `Box` with the given minimum and maximum boundary
    /// vectors.
    ///
    /// - precondition: `minimum <= maximum`
    @inlinable
    public init(minimum: Vector, maximum: Vector) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension Box: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Box: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Box: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Box: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Box where Vector: Equatable {
    /// Returns `true` if the size of this box is zero.
    @inlinable
    var isSizeZero: Bool {
        minimum == maximum
    }
}

public extension Box where Vector: VectorComparable {
    /// Returns `true` if `minimum <= maximum`.
    @inlinable
    var isValid: Bool {
        minimum <= maximum
    }
    
    /// Expands this box to include the given point.
    @inlinable
    mutating func expand(toInclude point: Vector) {
        minimum = Vector.pointwiseMin(minimum, point)
        maximum = Vector.pointwiseMax(maximum, point)
    }
    
    /// Expands this box to fully include the given set of points.
    ///
    /// Same as calling `expand(toInclude:Vector2D)` over each point.
    /// If the array is empty, nothing is done.
    @inlinable
    mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @inlinable
    func contains(_ point: Vector) -> Bool {
        return point >= minimum && point <= maximum
    }
    
    /// Returns whether a given box rests completely inside the boundaries of
    /// this box.
    @inlinable
    func contains(box: Box) -> Bool {
        return box.minimum >= minimum && box.maximum <= maximum
    }
    
    /// Returns whether this box intersects the given box instance.
    ///
    /// This check is inclusive, so the edges of the box are considered to
    /// intersect the other bounding box's edges as well.
    @inlinable
    func intersects(_ box: Box) -> Bool {
        return minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Returns a box which is the minimum area that can fit `self` and the
    /// given box.
    @inlinable
    func union(_ other: Box) -> Box {
        return Box.union(self, other)
    }
    
    /// Returns a box which is the minimum area that can fit the given two
    /// boxes.
    @inlinable
    static func union(_ left: Box, _ right: Box) -> Box {
        return Box(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
                   maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

public extension Box where Vector: VectorAdditive {
    /// Returns a box with all coordinates set to zero.
    @inlinable
    static var zero: Self { Self(minimum: .zero, maximum: .zero) }
    
    /// Gets the size of this box.
    @inlinable
    var size: Vector {
        maximum - minimum
    }
    
    /// Returns `true` if this box is a `Box2.zero` instance.
    @inlinable
    var isZero: Bool {
        minimum == .zero && maximum == .zero
    }
    
    /// Returns this `Box` represented as a `Rectangle`
    @inlinable
    var asRectangle: Rectangle<Vector> {
        Rectangle(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes a Box with zero minimal and maximal vectors.
    init() {
        minimum = .zero
        maximum = .zero
    }
    
    /// Initializes this Box with the equivalent coordinates of a rectangle with
    /// a given location and size.
    init(location: Vector, size: Vector) {
        minimum = location
        maximum = location + size
    }
}

public extension Box where Vector: VectorAdditive & VectorComparable {
    /// Initializes a box containing the minimum area capable of containing all
    /// supplied points.
    ///
    /// If no points are supplied, an empty box is created, instead.
    @inlinable
    init(of points: Vector...) {
        self = Box(points: points)
    }
    
    /// Initializes a box out of a set of points, expanding to the smallest
    /// area capable of fitting each point.
    @inlinable
    init<C: Collection>(points: C) where C.Element == Vector {
        guard let first = points.first else {
            minimum = .zero
            maximum = .zero
            return
        }
        
        minimum = first
        maximum = first
        
        expand(toInclude: points)
    }
}

extension Box: CustomStringConvertible where Vector: Vector2Type {
    public var description: String {
        return "\(type(of: self))(left: \(minimum.x), top: \(minimum.y), right: \(maximum.x), bottom: \(maximum.y))"
    }
}

public extension Box where Vector: Vector2Type {
    /// The x coordinate of the left corner of this 2d box.
    ///
    /// Alias for `minimum.x`.
    @inlinable
    var x: Scalar { minimum.x }
    
    /// The y coordinate of the top corner of this 2d box.
    ///
    /// Alias for `minimum.y`.
    @inlinable
    var y: Scalar { minimum.y }
    
    /// The x coordinate of the left corner of this 2d box.
    ///
    /// Alias for `minimum.x`.
    @inlinable
    var left: Scalar { minimum.x }
    
    /// The y coordinate of the top corner of this 2d box.
    ///
    /// Alias for `minimum.y`.
    @inlinable
    var top: Scalar { minimum.y }
    
    /// The x coordinate of the right corner of this 2d box.
    ///
    /// Alias for `maximum.x`.
    @inlinable
    var right: Scalar { maximum.x }
    
    /// The y coordinate of the bottom corner of this 2d box.
    ///
    /// Alias for `maximum.y`.
    @inlinable
    var bottom: Scalar { maximum.y }
    
    /// The top-left corner of the 2d box.
    @inlinable
    var topLeft: Vector { minimum }
    
    /// The top-right corner of the 2d box.
    @inlinable
    var topRight: Vector { Vector(x: right, y: top) }
    
    /// The bottom-right corner of the 2d box.
    @inlinable
    var bottomRight: Vector { maximum }
    
    /// The bottom-left corner of the 2d box.
    @inlinable
    var bottomLeft: Vector { Vector(x: left, y: bottom) }
    
    /// Returns an array of vectors that represent this `Box`'s 2D corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    var corners: [Vector] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes a `Box` with the edges of a box.
    @inlinable
    init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(minimum: Vector(x: left, y: top), maximum: Vector(x: right, y: bottom))
    }
}

public extension Box where Vector: Vector2Type & VectorComparable {
    /// Returns whether a given point is contained within this 2d box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @inlinable
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector(x: x, y: y))
    }
}

public extension Box where Vector: Vector2Type & VectorAdditive {
    /// Gets the width of this box.
    @inlinable
    var width: Scalar {
        size.x
    }
    
    /// Gets the height of this box.
    @inlinable
    var height: Scalar {
        size.y
    }
    
    /// Initializes a `Box` with the coordinates of a rectangle.
    @inlinable
    init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        let minimum = Vector(x: x, y: y)
        let maximum = minimum + Vector(x: width, y: height)
        
        self.init(minimum: minimum, maximum: maximum)
    }
}
