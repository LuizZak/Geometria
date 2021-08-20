/// Represents a 2D box with two double-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2D = Box2<Double>

/// Represents a 2D box with two single-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2F = Box2<Float>

/// Represents a 2D box with two integer vectors that describe the minimal and
/// maximal coordinates of the box's opposite corners.
public typealias Box2i = Box2<Int>

/// Represents a 2D box with two vectors that describe the minimal and maximal
/// coordinates of the box's opposite corners.
public struct Box2<Scalar> {
    /// The minimal coordinate of this
    /// Must be `<= maximum`
    public var minimum: Vector2<Scalar>
    
    /// The maximal coordinate of this box.
    /// Must be `>= minimum`.
    public var maximum: Vector2<Scalar>
    
    /// The y coordinate of the top corner of this box.
    ///
    /// Alias for `minimum.y`.
    @inlinable
    public var top: Scalar { minimum.y }
    
    /// The x coordinate of the left corner of this box.
    ///
    /// Alias for `minimum.x`.
    @inlinable
    public var left: Scalar { minimum.x }
    
    /// The y coordinate of the bottom corner of this box.
    ///
    /// Alias for `maximum.y`.
    @inlinable
    public var bottom: Scalar { maximum.y }
    
    /// The x coordinate of the right corner of this box.
    ///
    /// Alias for `maximum.x`.
    @inlinable
    public var right: Scalar { maximum.x }
    
    /// The top-left corner of the box.
    @inlinable
    public var topLeft: Vector2<Scalar> { minimum }
    
    /// The top-right corner of the box.
    @inlinable
    public var topRight: Vector2<Scalar> { Vector2(x: right, y: top) }
    
    /// The bottom-right corner of the box.
    @inlinable
    public var bottomRight: Vector2<Scalar> { maximum }
    
    /// The bottom-left corner of the box.
    @inlinable
    public var bottomLeft: Vector2<Scalar> { Vector2(x: left, y: top) }
    
    /// Returns an array of vectors that represent this `Box2`'s corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    var corners: [Vector2<Scalar>] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes a `Box2` with the given minimum and maximum boundary
    /// vectors.
    ///
    /// - precondition: `minimum <= maximum`
    @inlinable
    public init(minimum: Vector2<Scalar>, maximum: Vector2<Scalar>) {
        self.minimum = minimum
        self.maximum = maximum
    }
    
    /// Initializes a `Box2` with the edges of a box.
    @inlinable
    init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(minimum: Vector2(x: left, y: top), maximum: Vector2(x: right, y: bottom))
    }
}

extension Box2: Equatable where Scalar: Equatable { }
extension Box2: Hashable where Scalar: Hashable { }
extension Box2: Encodable where Scalar: Encodable { }
extension Box2: Decodable where Scalar: Decodable { }

public extension Box2 where Scalar: Equatable {
    /// Returns `true` if the area of this box is zero.
    @inlinable
    var isAreaZero: Bool {
        minimum == maximum
    }
}

public extension Box2 where Scalar: Comparable {
    /// Returns `true` if `minimum <= maximum`.
    @inlinable
    var isValid: Bool {
        minimum <= maximum
    }
    
    /// Expands this box to include the given point.
    @inlinable
    mutating func expand(toInclude point: Vector2<Scalar>) {
        minimum = min(minimum, point)
        maximum = max(maximum, point)
    }
    
    /// Expands this box to fully include the given set of points.
    ///
    /// Same as calling `expand(toInclude:Vector2D)` over each point.
    /// If the array is empty, nothing is done.
    @inlinable
    mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector2<Scalar> {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @inlinable
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector2<Scalar>(x: x, y: y))
    }
    
    /// Returns whether a given point is contained within this box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @inlinable
    func contains(_ point: Vector2<Scalar>) -> Bool {
        return point >= minimum && point <= maximum
    }
    
    /// Returns whether a given box rests completely inside the boundaries of
    /// this box.
    @inlinable
    func contains(box: Box2) -> Bool {
        return box.minimum >= minimum && box.maximum <= maximum
    }
    
    /// Returns whether this box intersects the given box instance.
    ///
    /// This check is inclusive, so the edges of the box are considered to
    /// intersect the other bounding box's edges as well.
    @inlinable
    func intersects(_ box: Box2) -> Bool {
        return minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Returns a box which is the minimum area that can fit `self` and the
    /// given box.
    @inlinable
    func union(_ other: Box2) -> Box2 {
        return Box2.union(self, other)
    }
    
    /// Returns a box which is the minimum area that can fit the given two
    /// boxes.
    @inlinable
    static func union(_ left: Box2, _ right: Box2) -> Box2 {
        return Box2(minimum: min(left.minimum, right.minimum),
                    maximum: max(left.maximum, right.maximum))
    }
}

public extension Box2 where Scalar: AdditiveArithmetic {
    /// Returns a box with all coordinates set to zero.
    @inlinable
    static var zero: Self { Self(minimum: .zero, maximum: .zero) }
    
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
    
    /// Gets the size of this box.
    @inlinable
    var size: Vector2<Scalar> {
        maximum - minimum
    }
    
    /// Returns `true` if this box is a `Box2.zero` instance.
    @inlinable
    var isZero: Bool {
        minimum == .zero && maximum == .zero
    }
    
    /// Returns this `Box2` represented as a `Rectangle2`
    @inlinable
    var asRectangle2: Rectangle2<Scalar> {
        Rectangle2(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes a `Box2` with the coordinates of a rectangle.
    @inlinable
    init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        let minimum = Vector2(x: x, y: y)
        let maximum = minimum + Vector2(x: width, y: height)
        
        self.init(minimum: minimum, maximum: maximum)
    }
}

public extension Box2 where Scalar: AdditiveArithmetic & Comparable {
    /// Initializes a box containing the minimum area capable of containing all
    /// supplied points.
    ///
    /// If no points are supplied, an empty box is created, instead.
    @inlinable
    init(of points: Vector2<Scalar>...) {
        self = Box2(points: points)
    }
    
    /// Initializes a box out of a set of points, expanding to the smallest
    /// area capable of fitting each point.
    @inlinable
    init<C: Collection>(points: C) where C.Element == Vector2<Scalar> {
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
