/// Represents an axis-aligned bounding box with two N-dimensional vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public struct AABB<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`.
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
    /// Returns `self`.
    @_transparent
    public var bounds: AABB<Vector> {
        self
    }
}

public extension AABB where Vector: Equatable {
    /// Returns `true` if the size of this box is zero.
    ///
    /// Size is zero when `minimum == maximum`.
    ///
    /// ```swift
    /// let box = AABB2D(left: 1.0, top: 2.0, right: 1.0, bottom: 2.0)
    ///
    /// print(box.isSizeZero) // Prints "true"
    /// ```
    @_transparent
    var isSizeZero: Bool {
        minimum == maximum
    }
}

extension AABB: VolumetricType where Vector: VectorComparable {
    /// Returns `true` iff `minimum <= maximum`.
    @_transparent
    public var isValid: Bool {
        minimum <= maximum
    }
    
    /// Initializes a box containing the minimum area capable of containing the
    /// two supplied points.
    ///
    /// ```swift
    /// let box = AABB2D(of:
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: -2)
    /// )
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 4))"
    /// ```
    @_transparent
    public init(of p1: Vector, _ p2: Vector) {
        let min = Vector.pointwiseMin(p1, p2)
        let max = Vector.pointwiseMax(p1, p2)
        
        self.init(minimum: min, maximum: max)
    }
    
    /// Initializes a box containing the minimum area capable of containing the
    /// three supplied points.
    ///
    /// ```swift
    /// let box = AABB2D(of:
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: 0),
    ///     .init(x: 2, y: -2)
    /// )
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 4))"
    /// ```
    @_transparent
    public init(of p1: Vector, _ p2: Vector, _ p3: Vector) {
        let min = Vector.pointwiseMin(p1, Vector.pointwiseMin(p2, p3))
        let max = Vector.pointwiseMax(p1, Vector.pointwiseMax(p2, p3))
        
        self.init(minimum: min, maximum: max)
    }
    
    /// Initializes a box containing the minimum area capable of containing the
    /// four supplied points.
    ///
    /// ```swift
    /// let box = AABB2D(of:
    ///     .init(x: -2, y: 4),
    ///     .init(x: 3, y: 0),
    ///     .init(x: 2, y: -2),
    ///     .init(x: -5, y: 3)
    /// )
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 4))"
    /// ```
    @_transparent
    public init(of p1: Vector, _ p2: Vector, _ p3: Vector, _ p4: Vector) {
        let min = Vector.pointwiseMin(p1, Vector.pointwiseMin(p2, Vector.pointwiseMin(p3, p4)))
        let max = Vector.pointwiseMax(p1, Vector.pointwiseMax(p2, Vector.pointwiseMax(p3, p4)))
        
        self.init(minimum: min, maximum: max)
    }
    
    /// Expands this box to include the given point.
    ///
    /// The resulting box is the minimal AABB capable of enclosing the original
    /// AABB and vector `point`.
    ///
    /// ```swift
    /// var box = AABB2D(left: 1, top: 1, right: 3, bottom: 3)
    ///
    /// box.expand(toInclude: .init(x: -5, y: 6))
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: 1), maximum: (x: 3, y: 6))"
    /// ```
    @_transparent
    public mutating func expand(toInclude point: Vector) {
        minimum = Vector.pointwiseMin(minimum, point)
        maximum = Vector.pointwiseMax(maximum, point)
    }
    
    /// Expands this box to fully include the given set of points.
    ///
    /// Equivalent to calling ``expand(toInclude:)-3z3he`` over each point.
    /// If the array is empty, nothing is done.
    ///
    /// The resulting box is the minimal AABB capable of enclosing the original
    /// AABB and all vectors in `points`.
    ///
    /// ```swift
    /// var box = AABB2D(left: 1, top: 1, right: 3, bottom: 3)
    ///
    /// box.expand(toInclude: [
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: -2),
    ///     .init(x: 1, y: 6)
    /// ])
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 6))"
    /// ```
    @inlinable
    public mutating func expand<S: Sequence>(toInclude points: S) where S.Element == Vector {
        for p in points {
            expand(toInclude: p)
        }
    }
    
    /// Clamps a given vector's coordinates to the confines of this AABB.
    ///
    /// Points inside the AABB remain unchanged, while points outside are
    /// projected along the edges to the closest point to `vector` that is
    /// within this AABB.
    ///
    /// ```swift
    /// let box = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    ///
    /// print(box.clamp(.init(x: -3, y: 2))) // Prints "(x: -1, y: 2)"
    /// print(box.clamp(.init(x: -3, y: -3))) // Prints "(x: -1, y: -2)"
    /// print(box.clamp(.init(x: 5, y: 1))) // Prints "(x: 3, y: 1)"
    /// ```
    @_transparent
    public func clamp(_ vector: Vector) -> Vector {
        Vector.pointwiseMax(minimum, Vector.pointwiseMin(maximum, vector))
    }
    
    /// Returns whether a given point is contained within this box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    ///
    /// ```swift
    /// let box = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    ///
    /// print(box.contains(.init(x: -3, y: 2))) // Prints "false"
    /// print(box.contains(.init(x: 1, y: 4))) // Prints "true"
    /// ```
    @_transparent
    public func contains(_ point: Vector) -> Bool {
        point >= minimum && point <= maximum
    }
}

extension AABB: SelfIntersectableRectangleType where Vector: VectorAdditive & VectorComparable {
    /// Returns whether a given box is completely contained inside the
    /// boundaries of this box.
    ///
    /// Returns `true` for `aabb.contains(aabb)`.
    ///
    /// ```swift
    /// let box1 = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    /// let box2 = AABB2D(left: 0, top: 1, right: 2, bottom: 3)
    /// let box3 = AABB2D(left: 1, top: 1, right: 5, bottom: 5)
    ///
    /// print(box1.contains(box: box1)) // Prints "true"
    /// print(box1.contains(box: box2)) // Prints "true"
    /// print(box1.contains(box: box3)) // Prints "false"
    /// ```
    @_transparent
    public func contains(_ other: AABB) -> Bool {
        other.minimum >= minimum && other.maximum <= maximum
    }
    
    /// Returns whether this box intersects the given box instance.
    ///
    /// This check is inclusive, so edges of the box are considered to intersect
    /// the other bounding box's edges as well.
    ///
    /// ```swift
    /// let box1 = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    /// let box2 = AABB2D(left: 0, top: 1, right: 2, bottom: 3)
    /// let box3 = AABB2D(left: 1, top: 1, right: 5, bottom: 5)
    /// let box4 = AABB2D(left: -1, top: 5, right: 3, bottom: 7)
    ///
    /// print(box1.intersects(box: box1)) // Prints "true"
    /// print(box1.intersects(box: box2)) // Prints "true"
    /// print(box1.intersects(box: box3)) // Prints "true"
    /// print(box1.intersects(box: box4)) // Prints "false"
    /// ```
    @_transparent
    public func intersects(_ box: AABB) -> Bool {
        minimum <= box.maximum && maximum >= box.minimum
    }
    
    /// Creates a rectangle which is equal to the positive area shared between
    /// this rectangle and `other`.
    ///
    /// If the AABBs do not intersect (i.e. produce a rectangle with < 0 bounds),
    /// `nil` is returned, instead.
    @inlinable
    public func intersection(_ other: Self) -> Self? {
        let min = Vector.pointwiseMax(minimum, other.minimum)
        let max = Vector.pointwiseMin(maximum, other.maximum)
        
        if min > max {
            return nil
        }
        
        return Self(minimum: min, maximum: max)
    }
    
    /// Returns a box which is the minimum box capable of fitting `self` and the
    /// given box.
    ///
    /// Returns `aabb` for `aabb.union(aabb)`.
    ///
    /// ```swift
    /// let box1 = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    /// let box2 = AABB2D(left: 0, top: -3, right: 5, bottom: 3)
    ///
    /// print(box1.union(box2)) // Prints (minimum: (x: -1, y: -3), maximum: (x: 5, y: 4))
    /// ```
    @_transparent
    public func union(_ other: AABB) -> AABB {
        AABB.union(self, other)
    }
    
    /// Returns a box which is the minimum box capable of fitting `left` and
    /// `right`.
    ///
    /// Returns `aabb` for `AABB.union(aabb, aabb)`.
    ///
    /// ```swift
    /// let box1 = AABB2D(left: -1, top: -2, right: 3, bottom: 4)
    /// let box2 = AABB2D(left: 0, top: -3, right: 5, bottom: 3)
    ///
    /// print(AABB.union(box1, box2)) // Prints (minimum: (x: -1, y: -3), maximum: (x: 5, y: 4))
    /// ```
    @_transparent
    public static func union(_ left: AABB, _ right: AABB) -> AABB {
        AABB(minimum: Vector.pointwiseMin(left.minimum, right.minimum),
             maximum: Vector.pointwiseMax(left.maximum, right.maximum))
    }
}

extension AABB: RectangleType & ConstructableRectangleType & AdditiveRectangleType where Vector: VectorAdditive {
    /// Returns a box with ``minimum`` and ``maximum`` set to `Vector.zero`.
    @_transparent
    public static var zero: Self { Self(minimum: .zero, maximum: .zero) }
    
    /// Gets the size of this box.
    @_transparent
    public var size: Vector {
        maximum - minimum
    }
    
    /// Returns `true` if this box is a `AABB.zero` instance.
    @_transparent
    public var isZero: Bool {
        minimum == .zero && maximum == .zero
    }
    
    /// Returns this `Box` represented as a `Rectangle`
    @_transparent
    public var asRectangle: NRectangle<Vector> {
        NRectangle(minimum: minimum, maximum: maximum)
    }
    
    /// Initializes an AABB with zero minimal and maximal vectors.
    @_transparent
    public init() {
        minimum = .zero
        maximum = .zero
    }
    
    /// Initializes this AABB with the equivalent coordinates of a rectangle
    /// with a given location and size.
    @_transparent
    public init(location: Vector, size: Vector) {
        minimum = location
        maximum = location + size
    }
}

public extension AABB where Vector: VectorAdditive & VectorComparable {
    /// Initializes a box containing the minimum area capable of containing all
    /// supplied points.
    ///
    /// If no points are supplied, a ``AABB/zero`` box is created, instead.
    ///
    /// Convenience for ``init(points:)``.
    ///
    /// ```swift
    /// let box = AABB2D(of:
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: -2),
    ///     .init(x: 1, y: 3),
    ///     .init(x: 2, y: 1),
    ///     .init(x: 2, y: 6)
    /// )
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 6))"
    /// ```
    @_transparent
    init(of p1: Vector, _ p2: Vector, _ p3: Vector, _ p4: Vector, _ remaining: Vector...) {
        self = AABB(points: [p1, p2, p3, p4] + remaining)
    }
    
    /// Initializes a box out of a set of points, expanding to the smallest
    /// area capable of fitting each point.
    ///
    /// ```swift
    /// let box = AABB2D(points: [
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: -2),
    ///     .init(x: 1, y: 3),
    ///     .init(x: 2, y: 1),
    ///     .init(x: 2, y: 6)
    /// ])
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 6))"
    /// ```
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

public extension AABB where Vector: VectorMultiplicative {
    /// Returns an ``AABB`` with minimum `.zero` and maximum `.one`.
    @_transparent
    static var unit: Self {
        Self(minimum: .zero, maximum: .one)
    }
}

extension AABB: DivisibleRectangleType where Vector: VectorDivisible {
    
}

extension AABB: ConvexType where Vector: VectorFloatingPoint {
    /// Returns `true` if this AABB's area intersects the given line type.
    @inlinable
    public func intersects<Line: LineFloatingPoint>(line: Line) -> Bool where Line.Vector == Vector {
        // Derived from C# implementation at: https://stackoverflow.com/a/3115514
        let lineSlope = line.lineSlope
        
        let lineToMin = minimum - line.a
        let lineToMax = maximum - line.a
        var tNear = -Scalar.infinity
        var tFar = Scalar.infinity
        
        let t1 = lineToMin / lineSlope
        let t2 = lineToMax / lineSlope
        let tMin = min(t1, t2)
        let tMax = max(t1, t2)
        
        var nearNormalIndex: Int = 0
        var farNormalIndex: Int = 0

        var index = 0
        while index < lineSlope.scalarCount {
            defer { index += 1 }
            guard lineSlope[index] != 0 else {
                continue
            }
            
            if tNear < tMin[index] {
                tNear = tMin[index]
                nearNormalIndex = index
            }
            if tFar > tMax[index] {
                tFar = tMax[index]
                farNormalIndex = index
            }
            
            if tNear > tFar {
                return false
            }
        }
        
        if line.containsProjectedNormalizedMagnitude(tNear) {
            if lineSlope[nearNormalIndex] != .zero {
                return true
            }
        }
        
        if line.containsProjectedNormalizedMagnitude(tFar) {
            if lineSlope[farNormalIndex] != .zero {
                return true
            }
        }

        return false
    }
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// AABB's outer perimeter.
    @inlinable
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector {
        // Derived from C# implementation at: https://stackoverflow.com/a/3115514
        let lineSlope = line.lineSlope
        
        let lineToMin = minimum - line.a
        let lineToMax = maximum - line.a
        var tNear = -Scalar.infinity
        var tFar = Scalar.infinity
        
        let t1 = lineToMin / lineSlope
        let t2 = lineToMax / lineSlope
        let tMin = min(t1, t2)
        let tMax = max(t1, t2)

        var nearNormalIndex: Int = 0
        var farNormalIndex: Int = 0

        var index = 0
        while index < lineSlope.scalarCount {
            defer { index += 1 }
            guard lineSlope[index] != 0 else {
                continue
            }
            
            if tNear < tMin[index] {
                tNear = tMin[index]
                nearNormalIndex = index
            }
            if tFar > tMax[index] {
                tFar = tMax[index]
                farNormalIndex = index
            }

            if tNear > tFar {
                return .noIntersection
            }
        }
        
        let nearIndexOnSlope = lineSlope[nearNormalIndex]
        let farIndexOnSlope = lineSlope[nearNormalIndex]
        
        @_transparent
        var nearNormal: Vector {
            var nearNormal: Vector = .zero
            nearNormal[nearNormalIndex] = nearIndexOnSlope > 0 ? -1 : 1
            return nearNormal
        }

        @_transparent
        var farNormal: Vector {
            var farNormal: Vector = .zero
            farNormal[farNormalIndex] = farIndexOnSlope > 0 ? -1 : 1
            return farNormal
        }

        switch (line.containsProjectedNormalizedMagnitude(tNear) && nearIndexOnSlope != .zero,
                line.containsProjectedNormalizedMagnitude(tFar) && farIndexOnSlope != .zero) {
        case (true, true):
            return .enterExit(
                PointNormal(
                    point: line.projectedNormalizedMagnitude(tNear),
                    normal: nearNormal
                ),
                PointNormal(
                    point: line.projectedNormalizedMagnitude(tFar),
                    normal: farNormal
                )
            )
            
        case (true, false):
            return .enter(
                PointNormal(
                    point: line.projectedNormalizedMagnitude(tNear),
                    normal: nearNormal
                )
            )
            
        case (false, true):
            return .exit(
                PointNormal(
                    point: line.projectedNormalizedMagnitude(tFar),
                    normal: farNormal
                )
            )
            
        default:
            // Check for containment
            if contains(line.a) && contains(line.b) {
                return .contained
            }
            
            return .noIntersection
        }
    }
}

extension AABB: SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    // Distance function derived from: https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
    public func signedDistance(to point: Vector) -> Vector.Scalar {
        let q = abs(point - center) - size / 2
        let distOutside = max(q, .zero).length
        let distInside = min(q, .zero).maximalComponent
        
        return distOutside + distInside
    }
}
