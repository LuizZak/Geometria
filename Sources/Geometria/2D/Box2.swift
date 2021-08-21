/// Represents a 2D box with two double-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2D = Box<Vector2D>

/// Represents a 2D box with two single-precision floating-point vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias Box2F = Box<Vector2F>

/// Represents a 2D box with two integer vectors that describe the minimal and
/// maximal coordinates of the box's opposite corners.
public typealias Box2i = Box<Vector2i>

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
