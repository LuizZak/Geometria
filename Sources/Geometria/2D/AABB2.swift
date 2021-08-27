/// Represents a 2D axis-aligned bounding box with two double-precision
/// floating-point vectors that describe the minimal and maximal coordinates
/// of the box's opposite corners.
public typealias AABB2D = AABB2<Vector2D>

/// Represents a 2D axis-aligned bounding box with two single-precision
/// floating-point vectors that describe the minimal and maximal coordinates
/// of the box's opposite corners.
public typealias AABB2F = AABB2<Vector2F>

/// Represents a 2D axis-aligned bounding box with two integer vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias AABB2i = AABB2<Vector2i>

/// Typealias for `AABB<V>`, where `V` is constrained to `Vector2Type`.
public typealias AABB2<V: Vector2Type> = AABB<V>

extension AABB2: CustomStringConvertible {
    public var description: String {
        return "\(type(of: self))(left: \(minimum.x), top: \(minimum.y), right: \(maximum.x), bottom: \(maximum.y))"
    }
}

public extension AABB2 {
    /// The x coordinate of the left corner of this 2d box.
    ///
    /// Alias for `minimum.x`.
    @_transparent
    var x: Scalar { minimum.x }
    
    /// The y coordinate of the top corner of this 2d box.
    ///
    /// Alias for `minimum.y`.
    @_transparent
    var y: Scalar { minimum.y }
    
    /// The x coordinate of the left corner of this 2d box.
    ///
    /// Alias for `minimum.x`.
    @_transparent
    var left: Scalar { minimum.x }
    
    /// The y coordinate of the top corner of this 2d box.
    ///
    /// Alias for `minimum.y`.
    @_transparent
    var top: Scalar { minimum.y }
    
    /// The x coordinate of the right corner of this 2d box.
    ///
    /// Alias for `maximum.x`.
    @_transparent
    var right: Scalar { maximum.x }
    
    /// The y coordinate of the bottom corner of this 2d box.
    ///
    /// Alias for `maximum.y`.
    @_transparent
    var bottom: Scalar { maximum.y }
    
    /// The top-left corner of the 2d box.
    @_transparent
    var topLeft: Vector { minimum }
    
    /// The top-right corner of the 2d box.
    @_transparent
    var topRight: Vector { Vector(x: right, y: top) }
    
    /// The bottom-right corner of the 2d box.
    @_transparent
    var bottomRight: Vector { maximum }
    
    /// The bottom-left corner of the 2d box.
    @_transparent
    var bottomLeft: Vector { Vector(x: left, y: bottom) }
    
    /// Returns an array of vectors that represent this `AABB`'s 2D corners in
    /// clockwise order, starting from the top-left corner.
    ///
    /// Always contains 4 elements.
    @inlinable
    var corners: [Vector] {
        return [topLeft, topRight, bottomRight, bottomLeft]
    }
    
    /// Initializes a `AABB` with the edges of a box.
    @_transparent
    init(left: Scalar, top: Scalar, right: Scalar, bottom: Scalar) {
        self.init(minimum: Vector(x: left, y: top), maximum: Vector(x: right, y: bottom))
    }
}

public extension AABB2 where Vector: VectorComparable {
    /// Returns whether a given point is contained within this 2d box.
    ///
    /// The check is inclusive, so the edges of the box are considered to
    /// contain the point as well.
    @_transparent
    func contains(x: Scalar, y: Scalar) -> Bool {
        return contains(Vector(x: x, y: y))
    }
}

public extension AABB2 where Vector: VectorAdditive {
    /// Gets the width of this box.
    @_transparent
    var width: Scalar {
        size.x
    }
    
    /// Gets the height of this box.
    @_transparent
    var height: Scalar {
        size.y
    }
    
    /// Initializes a `AABB` with the coordinates of a rectangle.
    @inlinable
    init(x: Scalar, y: Scalar, width: Scalar, height: Scalar) {
        let minimum = Vector(x: x, y: y)
        let maximum = minimum + Vector(x: width, y: height)
        
        self.init(minimum: minimum, maximum: maximum)
    }
}
