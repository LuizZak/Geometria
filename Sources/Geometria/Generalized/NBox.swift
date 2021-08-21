/// Represents a box with two N-dimensional vectors that describe the minimal
/// and maximal coordinates of the box's opposite corners.
public struct NBox<Vector: VectorType> {
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
    
    /// Initializes a `NBox` with the given minimum and maximum boundary
    /// vectors.
    ///
    /// - precondition: `minimum <= maximum`
    @inlinable
    public init(minimum: Vector, maximum: Vector) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension NBox: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NBox: Hashable where Vector: Hashable, Scalar: Hashable { }
extension NBox: Encodable where Vector: Encodable, Scalar: Encodable { }
extension NBox: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension NBox where Vector: Equatable {
    /// Returns `true` if the size of this box is zero.
    @inlinable
    var isSizeZero: Bool {
        minimum == maximum
    }
}

public extension NBox where Vector: VectorComparable {
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
    func contains(box: NBox) -> Bool {
        return box.minimum >= minimum && box.maximum <= maximum
    }
    
    /// Returns whether this box intersects the given box instance.
    ///
    /// This check is inclusive, so the edges of the box are considered to
    /// intersect the other bounding box's edges as well.
    @inlinable
    func intersects(_ box: NBox) -> Bool {
        return minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Returns a box which is the minimum area that can fit `self` and the
    /// given box.
    @inlinable
    func union(_ other: NBox) -> NBox {
        return NBox.union(self, other)
    }
    
    /// Returns a box which is the minimum area that can fit the given two
    /// boxes.
    @inlinable
    static func union(_ left: NBox, _ right: NBox) -> NBox {
        return NBox(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
                   maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

public extension NBox where Vector: VectorAdditive {
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
    var asRectangle: NRectangle<Vector> {
        NRectangle(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes a NBox with zero minimal and maximal vectors.
    init() {
        minimum = .zero
        maximum = .zero
    }
    
    /// Initializes this NBox with the equivalent coordinates of a rectangle with
    /// a given location and size.
    init(location: Vector, size: Vector) {
        minimum = location
        maximum = location + size
    }
}

public extension NBox where Vector: VectorAdditive & VectorComparable {
    /// Initializes a box containing the minimum area capable of containing all
    /// supplied points.
    ///
    /// If no points are supplied, an empty box is created, instead.
    @inlinable
    init(of points: Vector...) {
        self = NBox(points: points)
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
