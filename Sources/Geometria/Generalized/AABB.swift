/// Represents an axis-aligned bounding box with two N-dimensional vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public struct AABB<Vector: VectorType>: GeometricType {
    public typealias Scalar = Vector.Scalar
    
    /// The minimal coordinate of this box.
    /// Must be `<= maximum`.
    public var minimum: Vector
    
    /// The maximal coordinate of this box.
    /// Must be `>= minimum`.
    public var maximum: Vector
    
    /// The location of this Box corresponding to its minimal vector.
    /// Alias for `minimum`.
    @_transparent
    public var location: Vector { minimum }
    
    /// Initializes a `NBox` with the given minimum and maximum boundary
    /// vectors.
    ///
    /// - precondition: `minimum <= maximum`
    @_transparent
    public init(minimum: Vector, maximum: Vector) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension AABB: Equatable where Vector: Equatable, Scalar: Equatable { }
extension AABB: Hashable where Vector: Hashable, Scalar: Hashable { }
extension AABB: Encodable where Vector: Encodable, Scalar: Encodable { }
extension AABB: Decodable where Vector: Decodable, Scalar: Decodable { }

extension AABB: BoundableType {
    @_transparent
    public var bounds: AABB<Vector> {
        self
    }
}

public extension AABB where Vector: Equatable {
    /// Returns `true` if the size of this box is zero.
    @_transparent
    var isSizeZero: Bool {
        minimum == maximum
    }
}

extension AABB: VolumetricType where Vector: VectorComparable {
    /// Returns `true` if `minimum <= maximum`.
    @_transparent
    public var isValid: Bool {
        minimum <= maximum
    }
    
    /// Expands this box to include the given point.
    @_transparent
    public mutating func expand(toInclude point: Vector) {
        minimum = Vector.pointwiseMin(minimum, point)
        maximum = Vector.pointwiseMax(maximum, point)
    }
    
    /// Expands this box to fully include the given set of points.
    ///
    /// Same as calling `expand(toInclude:Vector2D)` over each point.
    /// If the array is empty, nothing is done.
    @inlinable
    public mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Clamps a given vector's coordinates to the confines of this AABB.
    /// Points inside the AABB remain unchanced, while points outside are
    /// projected along the edges to the closest point to `vector` that is
    /// within this AABB.
    @inlinable
    public func clamp(_ vector: Vector) -> Vector {
        return Vector.pointwiseMax(minimum, Vector.pointwiseMin(maximum, vector))
    }
    
    /// Returns whether a given point is contained within this box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @_transparent
    public func contains(_ point: Vector) -> Bool {
        point >= minimum && point <= maximum
    }
    
    /// Returns whether a given box rests completely inside the boundaries of
    /// this box.
    @_transparent
    public func contains(box: AABB) -> Bool {
        box.minimum >= minimum && box.maximum <= maximum
    }
    
    /// Returns whether this box intersects the given box instance.
    ///
    /// This check is inclusive, so the edges of the box are considered to
    /// intersect the other bounding box's edges as well.
    @_transparent
    public func intersects(_ box: AABB) -> Bool {
        minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Returns a box which is the minimum area that can fit `self` and the
    /// given box.
    @_transparent
    public func union(_ other: AABB) -> AABB {
        AABB.union(self, other)
    }
    
    /// Returns a box which is the minimum area that can fit the given two
    /// boxes.
    @_transparent
    public static func union(_ left: AABB, _ right: AABB) -> AABB {
        AABB(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
             maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

public extension AABB where Vector: VectorAdditive {
    /// Returns a box with all coordinates set to zero.
    @_transparent
    static var zero: Self { Self(minimum: .zero, maximum: .zero) }
    
    /// Gets the size of this box.
    @_transparent
    var size: Vector {
        maximum - minimum
    }
    
    /// Returns `true` if this box is a `Box2.zero` instance.
    @_transparent
    var isZero: Bool {
        minimum == .zero && maximum == .zero
    }
    
    /// Returns this `Box` represented as a `Rectangle`
    @_transparent
    var asRectangle: NRectangle<Vector> {
        NRectangle(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes a NBox with zero minimal and maximal vectors.
    @_transparent
    init() {
        minimum = .zero
        maximum = .zero
    }
    
    /// Initializes this NBox with the equivalent coordinates of a rectangle with
    /// a given location and size.
    @_transparent
    init(location: Vector, size: Vector) {
        minimum = location
        maximum = location + size
    }
}

public extension AABB where Vector: VectorAdditive & VectorComparable {
    /// Initializes a box containing the minimum area capable of containing all
    /// supplied points.
    ///
    /// If no points are supplied, an empty box is created, instead.
    @_transparent
    init(of points: Vector...) {
        self = AABB(points: points)
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
