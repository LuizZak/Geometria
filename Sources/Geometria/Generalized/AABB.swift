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
    public func contains(box: AABB) -> Bool {
        box.minimum >= minimum && box.maximum <= maximum
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
    ///     .init(x: 1, y: 6)
    /// )
    ///
    /// print(box) // Prints "(minimum: (x: -5, y: -2), maximum: (x: 3, y: 6))"
    /// ```
    @_transparent
    init(of points: Vector...) {
        self = AABB(points: points)
    }
    
    /// Initializes a box out of a set of points, expanding to the smallest
    /// area capable of fitting each point.
    ///
    /// ```swift
    /// let box = AABB2D(points: [
    ///     .init(x: -5, y: 4),
    ///     .init(x: 3, y: -2),
    ///     .init(x: 1, y: 6)
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

extension AABB: ConvexType where Vector: VectorFloatingPoint & VectorComparable {
    /// Returns `true` if this AABB's area intersects the given line type.
    @inlinable
    public func intersects<Line: LineFloatingPoint>(line: Line) -> Bool where Line.Vector == Vector {
        // Derived from C# implementation at: https://stackoverflow.com/a/3115514
        let beginToEnd = line.b - line.a
        
        let beginToMin = minimum - line.a
        let beginToMax = maximum - line.a
        var tNear = -Scalar.infinity
        var tFar = Scalar.infinity
        
        let t1 = beginToMin / beginToEnd
        let t2 = beginToMax / beginToEnd
        let tMin = min(t1, t2)
        let tMax = max(t1, t2)
        
        var index = 0
        while index < beginToEnd.scalarCount {
            defer { index += 1 }
            guard beginToEnd[index] != 0 else {
                continue
            }
            
            tNear = max(tNear, tMin[index])
            tFar = min(tFar, tMax[index])
            
            if tNear > tFar {
                return false
            }
        }
        
        let near = line.projectedNormalizedMagnitude(tNear)
        let far = line.projectedNormalizedMagnitude(tFar)
        
        let nearNormDotLine = normalMagnitude(for: near).dot(beginToEnd)
        let farNormDotLine = normalMagnitude(for: far).dot(beginToEnd)
        
        return (line.containsProjectedNormalizedMagnitude(tNear) && nearNormDotLine != .zero) ||
               (line.containsProjectedNormalizedMagnitude(tFar) && farNormDotLine != .zero)
    }
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// AABB's outer perimeter.
    @inlinable
    public func intersection<Line: LineFloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector {
        // Derived from C# implementation at: https://stackoverflow.com/a/3115514
        let beginToEnd = line.b - line.a
        
        let beginToMin = minimum - line.a
        let beginToMax = maximum - line.a
        var tNear = -Scalar.infinity
        var tFar = Scalar.infinity
        
        let t1 = beginToMin / beginToEnd
        let t2 = beginToMax / beginToEnd
        let tMin = min(t1, t2)
        let tMax = max(t1, t2)
        
        var index = 0
        while index < beginToEnd.scalarCount {
            defer { index += 1 }
            guard beginToEnd[index] != 0 else {
                continue
            }
            
            tNear = max(tNear, tMin[index])
            tFar = min(tFar, tMax[index])
            
            if tNear > tFar {
                return .noIntersection
            }
        }
        
        // TODO: Attempt to derive normal during computation above
        func makePointNormal(_ point: Vector) -> PointNormal<Vector> {
            let normal = normalMagnitude(for: point)
            
            return PointNormal(
                point: point,
                normal: normal.withSign(of: -beginToEnd)
            )
        }
        
        let near = line.projectedNormalizedMagnitude(tNear)
        let far = line.projectedNormalizedMagnitude(tFar)
        
        let nearNormDotLine = normalMagnitude(for: near).dot(beginToEnd)
        let farNormDotLine = normalMagnitude(for: far).dot(beginToEnd)
        
        switch (line.containsProjectedNormalizedMagnitude(tNear) && nearNormDotLine != .zero,
                line.containsProjectedNormalizedMagnitude(tFar) && farNormDotLine != .zero) {
        case (true, true):
            return .enterExit(
                makePointNormal(near),
                makePointNormal(far)
            )
            
        case (true, false):
            return .enter(
                makePointNormal(near)
            )
            
        case (false, true):
            return .exit(
                makePointNormal(far)
            )
            
        default:
            return .noIntersection
        }
    }
    
    @usableFromInline
    internal func normalMagnitude(for point: Vector) -> Vector {
        var offsetPoint = point
        var normalIndex = 0
        var max = -Scalar.infinity
        
        offsetPoint -= center
        
        for index in 0..<offsetPoint.scalarCount {
            let distance = abs(offsetPoint[index]) / size[index]
            
            if distance > max {
                max = distance
                normalIndex = index
            }
        }
        
        var normal = Vector.zero
        
        normal[normalIndex] = 1
        
        return normal
    }
}

extension AABB: DivisibleRectangleType where Vector: VectorDivisible {
    
}
