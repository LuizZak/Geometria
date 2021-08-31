public extension RectangleType where Vector: Vector2Type {
    /// Gets the X position of this Rectangle.
    @_transparent
    var x: Vector.Scalar { location.x }
    
    /// Gets the Y position of this Rectangle.
    @_transparent
    var y: Vector.Scalar { location.y }
    
    /// Gets the width of this Rectangle.
    @_transparent
    var width: Vector.Scalar { size.x }
    
    /// Gets the height of this Rectangle.
    @_transparent
    var height: Vector.Scalar { size.y }
    
    /// The y coordinate of the top corner of this rectangle.
    ///
    /// Alias for `y`.
    @_transparent
    var top: Vector.Scalar { y }
    
    /// The x coordinate of the left corner of this rectangle.
    ///
    /// Alias for `x`.
    @_transparent
    var left: Vector.Scalar { x }
    
    /// The top-left corner of the rectangle.
    @_transparent
    var topLeft: Vector { Vector(x: left, y: top) }
}
