/// Represents an N-dimensional rectangle with a vector describing its origin
/// and a size vector that describes the span of the rectangle.
public struct NRectangle<Vector: VectorType>: ConstructableRectangleType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The starting location of this rectangle with the minimal coordinates
    /// contained within the rectangle.
    public var location: Vector
    
    /// The size of this rectangle, which when added to ``location`` produce the
    /// maximal coordinates contained within this rectangle.
    ///
    /// Must be `>= Vector.zero`
    public var size: Vector
    
    /// Initializes a NRectangle with the location + size of a rectangle.
    @_transparent
    public init(location: Vector, size: Vector) {
        self.location = location
        self.size = size
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

extension NRectangle: AdditiveRectangleType where Vector: VectorAdditive {
    /// Returns an empty rectangle
    @_transparent
    public static var zero: NRectangle { NRectangle(location: .zero, size: .zero) }
    
    /// Returns `true` if the size of this rectangle is zero.
    @_transparent
    public var isSizeZero: Bool {
        size == .zero
    }
    
    /// Minimum point for this rectangle.
    ///
    /// When set, the maximal point on the opposite corner is kept fixed.
    @_transparent
    public var minimum: Vector {
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
    public var maximum: Vector {
        get {
            location + size
        }
        set {
            size = newValue - location
        }
    }
    
    /// Returns this `Rectangle` represented as an `AABB`
    @_transparent
    public var asAABB: AABB<Vector> {
        AABB(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes an empty NRectangle instance.
    @_transparent
    public init() {
        location = .zero
        size = .zero
    }
    
    /// Initializes a `NRectangle` instance out of the given minimum and maximum
    /// coordinates.
    ///
    /// - precondition: `minimum <= maximum`
    @_transparent
    public init(minimum: Vector, maximum: Vector) {
        self.init(location: minimum, size: maximum - minimum)
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
        self = Self(points: points)
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
    public mutating func expand<S: Sequence>(
        toInclude points: S
    ) where S.Element == Vector {

        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Returns whether a given point is contained within this bounding box.
    ///
    /// Points at the perimeter of the N-rectangle (distance to nearest edge ==
    /// 0) are considered as contained within the N-rectangle.
    @_transparent
    public func contains(_ point: Vector) -> Bool {
        point >= minimum && point <= maximum
    }
}

extension NRectangle: SelfIntersectableRectangleType where Vector: VectorAdditive & VectorComparable {
    /// Returns whether a given NRectangle rests completely inside the boundaries
    /// of this NRectangle.
    @_transparent
    public func contains(_ other: Self) -> Bool {
        other.minimum >= minimum && other.maximum <= maximum
    }
    
    /// Returns whether this NRectangle intersects the given NRectangle instance.
    /// This check is inclusive, so the edges of the bounding box are considered
    /// to intersect the other bounding box's edges as well.
    @_transparent
    public func intersects(_ other: Self) -> Bool {
        minimum <= other.maximum && maximum >= other.minimum
    }
    
    /// Returns a NRectangle which is the minimum NRectangle that can fit this
    /// NRectangle with another given NRectangle.
    @_transparent
    public func union(_ other: Self) -> Self {
        Self.union(self, other)
    }
    
    /// Creates a rectangle which is equal to the positive area shared between
    /// this rectangle and `other`.
    ///
    /// If the rectangles do not intersect (i.e. produce a rectangle with < 0
    /// bounds), `nil` is returned, instead.
    @inlinable
    public func intersection(_ other: Self) -> Self? {
        let min = Vector.pointwiseMax(minimum, other.minimum)
        let max = Vector.pointwiseMin(maximum, other.maximum)
        
        if min > max {
            return nil
        }
        
        return Self(minimum: min, maximum: max)
    }
    
    /// Returns a NRectangle which is the minimum NRectangle that can fit two
    /// given Rectangles.
    @_transparent
    public static func union(_ left: Self, _ right: Self) -> Self {
        Self(
            minimum: .pointwiseMin(left.minimum, right.minimum),
            maximum: .pointwiseMax(left.maximum, right.maximum)
        )
    }
}

public extension NRectangle where Vector: VectorMultiplicative {
    /// Returns an ``NRectangle`` with location `.zero` and size `.one`.
    @_transparent
    static var unit: Self {
        Self(location: .zero, size: .one)
    }
    
    /// Returns a NRectangle with the same position as this NRectangle, with its
    /// size multiplied by the coordinates of the given vector.
    @inlinable
    func scaledBy(vector: Vector) -> Self {
        Self(location: location, size: size * vector)
    }
}

extension NRectangle: DivisibleRectangleType where Vector: VectorDivisible & VectorComparable {
    
    /// Subdivides this rectangle into `2 ^ D` (where `D` is the dimensional size
    /// of `Self.Vector`) rectangles that occupy the same area as this rectangle
    /// but subdivide it into equally-sized rectangles.
    ///
    /// The ordering of the subdivisions is not defined.
    @inlinable
    public func subdivided() -> [Self] {
        let center = self.center
        let vertices = self.vertices

        return vertices.map { v in
            let minimum = Vector.pointwiseMin(center, v)
            let maximum = Vector.pointwiseMax(center, v)

            return Self(
                location: minimum,
                size: maximum - minimum
            )
        }
    }
}

extension NRectangle: ConvexType where Vector: VectorFloatingPoint {
    /// Returns `true` if this NRectangle's area intersects the given line type.
    @_transparent
    public func intersects<Line>(
        line: Line
    ) -> Bool where Line : LineFloatingPoint, Vector == Line.Vector {

        bounds.intersects(line: line)
    }
    
    @_transparent
    public func intersection<Line>(
        with line: Line
    ) -> ConvexLineIntersection<Vector> where Line: LineFloatingPoint, Vector == Line.Vector {
        
        bounds.intersection(with: line)
    }
}

extension NRectangle: SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    @_transparent
    public func signedDistance(to point: Vector) -> Vector.Scalar {
        bounds.signedDistance(to: point)
    }
}
