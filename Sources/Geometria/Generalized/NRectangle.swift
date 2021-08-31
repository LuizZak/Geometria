/// Represents an N-dimensional rectangle with a vector describing its origin
/// and a size vector that describes the span of the rectangle.
public struct NRectangle<Vector: VectorType>: GeometricType {
    public typealias Scalar = Vector.Scalar
    
    /// The top-left location of this rectangle.
    public var location: Vector
    
    /// The size of this rectangle.
    /// Must be `>= Vector.zero`
    public var size: Vector
    
    /// Initializes a NRectangle with the location + size of a rectangle.
    @_transparent
    public init(location: Vector, size: Vector) {
        self.location = location
        self.size = size
    }
    
    /// Returns a NRectangle that matches this NRectangle's size with a new location.
    @_transparent
    public func withLocation(_ location: Vector) -> NRectangle {
        NRectangle(location: location, size: size)
    }
    
    /// Returns a NRectangle that matches this NRectangle's size with a new location.
    @_transparent
    public func withSize(_ size: Vector) -> NRectangle {
        NRectangle(location: location, size: size)
    }
    
    /// Returns a `RoundNRectangle` which has the same bounds as this rectangle,
    /// with the given radius vector describing the dimensions of the corner
    /// arcs.
    @inlinable
    public func rounded(radius: Vector) -> RoundNRectangle<Vector> {
        RoundNRectangle(rectangle: self, radius: radius)
    }
    
    /// Returns a `RoundNRectangle` which has the same bounds as this rectangle,
    /// with the given radius value describing the dimensions of the corner
    /// arcs.
    ///
    /// Alias for `rounded(radius: Vector(repeating: radius))`
    @_transparent
    public func rounded(radius: Scalar) -> RoundNRectangle<Vector> {
        rounded(radius: .init(repeating: radius))
    }
}

extension NRectangle: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NRectangle: Hashable where Vector: Hashable, Scalar: Hashable { }
extension NRectangle: Encodable where Vector: Encodable, Scalar: Encodable { }
extension NRectangle: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension NRectangle where Vector: VectorAdditive {
    /// Returns `true` if the size of this rectangle is zero.
    @_transparent
    var isSizeZero: Bool {
        size == .zero
    }
    
    /// Minimum point for this rectangle.
    ///
    /// When set, the maximal point on the opposite corner is kept fixed.
    @_transparent
    var minimum: Vector {
        get {
            location
        }
        set {
            let diff = newValue - minimum
            
            location = newValue
            size -= diff
        }
    }
    
    /// Maximum point for this rectangle.
    ///
    /// When set, the minimal point on the opposite corner is kept fixed.
    @_transparent
    var maximum: Vector {
        get {
            location + size
        }
        set {
            size = newValue - location
        }
    }
    
    /// Returns this `Rectangle` represented as an `AABB`
    @_transparent
    var asAABB: AABB<Vector> {
        AABB(minimum: minimum, maximum: maximum)
    }
    
    /// Returns an empty rectangle
    @_transparent
    static var zero: NRectangle { NRectangle(location: .zero, size: .zero) }
    
    /// Initializes an empty NRectangle instance.
    @_transparent
    init() {
        location = .zero
        size = .zero
    }
    
    /// Initializes a `NRectangle` instance out of the given minimum and maximum
    /// coordinates.
    ///
    /// - precondition: `minimum <= maximum`
    @_transparent
    init(minimum: Vector, maximum: Vector) {
        self.init(location: minimum, size: maximum - minimum)
    }
    
    /// Returns a copy of this NRectangle with its location offset by a given
    /// Vector amount.
    @_transparent
    func offsetBy(_ vector: Vector) -> NRectangle {
        NRectangle(location: location + vector, size: size)
    }
}

extension NRectangle: BoundableType where Vector: VectorAdditive {
    /// Returns this `Rectangle` represented as an `AABB`
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(minimum: minimum, maximum: maximum)
    }
}

extension NRectangle: VolumetricType where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if `size >= .zero`.
    @_transparent
    public var isValid: Bool {
        size >= .zero
    }
    
    /// Initializes a NRectangle containing the minimum area capable of containing
    /// all supplied points.
    ///
    /// If no points are supplied, an empty NRectangle is created instead.
    @_transparent
    public init(of points: Vector...) {
        self = NRectangle(points: points)
    }
    
    /// Initializes a NRectangle out of a set of points, expanding to the
    /// smallest bounding box capable of fitting each point.
    @inlinable
    public init<C: Collection>(points: C) where C.Element == Vector {
        guard let first = points.first else {
            location = .zero
            size = .zero
            return
        }
        
        location = first
        size = .zero
        
        expand(toInclude: points)
    }
    
    /// Expands the bounding box of this NRectangle to include the given point.
    @_transparent
    public mutating func expand(toInclude point: Vector) {
        minimum = Vector.pointwiseMin(minimum, point)
        maximum = Vector.pointwiseMax(maximum, point)
    }
    
    /// Expands the bounding box of this NRectangle to include the given set of
    /// points.
    ///
    /// Same as calling ``expand(toInclude:)-970h`` over each point.
    /// If the array is empty, nothing is done.
    @inlinable
    public mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this bounding box.
    /// The check is inclusive, so the edges of the bounding box are considered
    /// to contain the point as well.
    @_transparent
    public func contains(_ point: Vector) -> Bool {
        point >= minimum && point <= maximum
    }
    
    /// Returns whether a given NRectangle rests completely inside the boundaries
    /// of this NRectangle.
    @_transparent
    public func contains(rectangle: NRectangle) -> Bool {
        rectangle.minimum >= minimum && rectangle.maximum <= maximum
    }
    
    /// Returns whether this NRectangle intersects the given NRectangle instance.
    /// This check is inclusive, so the edges of the bounding box are considered
    /// to intersect the other bounding box's edges as well.
    @_transparent
    public func intersects(_ other: NRectangle) -> Bool {
        minimum <= other.maximum && maximum >= other.minimum
    }
    
    /// Returns a NRectangle which is the minimum NRectangle that can fit this
    /// NRectangle with another given NRectangle.
    @_transparent
    public func union(_ other: NRectangle) -> NRectangle {
        NRectangle.union(self, other)
    }
    
    /// Returns a NRectangle which is the minimum NRectangle that can fit two
    /// given Rectangles.
    @_transparent
    public static func union(_ left: NRectangle, _ right: NRectangle) -> NRectangle {
        NRectangle(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
                   maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

public extension NRectangle where Vector: VectorMultiplicative {
    /// Returns a NRectangle with the same position as this NRectangle, with its
    /// size multiplied by the coordinates of the given vector.
    @inlinable
    func scaledBy(vector: Vector) -> NRectangle {
        NRectangle(location: location, size: size * vector)
    }
}

public extension NRectangle where Vector: VectorDivisible {
    /// Gets the center point of this Rectangle.
    @inlinable
    var center: Vector {
        get {
            location + size / 2
        }
        @_transparent
        set {
            self = movingCenter(to: newValue)
        }
    }
    
    /// Returns a NRectangle which is an inflated version of this NRectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    ///
    /// Equivalent to inseting the rectangle by a negative amount.
    ///
    /// - seealso: insetBy
    @_transparent
    func inflatedBy(_ size: Vector) -> NRectangle {
        NRectangle(minimum: minimum - size / 2, maximum: maximum + size / 2)
    }
    
    /// Returns a NRectangle which is an inset version of this NRectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    ///
    /// Equivalent to inflating the rectangle by a negative amount.
    ///
    /// - seealso: inflatedBy
    @_transparent
    func insetBy(_ size: Vector) -> NRectangle {
        NRectangle(minimum: minimum + size / 2, maximum: maximum - size / 2)
    }
    
    /// Returns a new NRectangle with the same size as the current instance,
    /// where the center of the boundaries lay on `center`.
    @_transparent
    func movingCenter(to center: Vector) -> NRectangle {
        NRectangle(minimum: center - size / 2, maximum: center + size / 2)
    }
}
