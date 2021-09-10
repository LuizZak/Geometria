/// When initializes with a ``Vector2Type``, allows referencing pairs of
/// coordinates to form other ``Vector2Type``s out of.
public struct TakeVector2<Vector: Vector3Type> {
    /// Convenience for `Vector.SubVector2`
    public typealias SubVector2 = Vector.SubVector2
    
    @usableFromInline
    var underlying: Vector
    
    /// Gets a new `SubVector2` wieh the coordinates of `x`, `y`, in that order.
    @_transparent
    public var xy: SubVector2 {
        .init(x: underlying.x, y: underlying.y)
    }
    
    /// Gets a new `SubVector2` wieh the coordinates of `y`, `x`, in that order.
    @_transparent
    public var yx: SubVector2 {
        .init(x: underlying.y, y: underlying.x)
    }
    
    /// Gets a new `SubVector2` wieh the coordinates of `x`, `z`, in that order.
    @_transparent
    public var xz: SubVector2 {
        .init(x: underlying.x, y: underlying.z)
    }
    
    /// Gets a new `SubVector2` wieh the coordinates of `z`, `x`, in that order.
    @_transparent
    public var zx: SubVector2 {
        .init(x: underlying.z, y: underlying.x)
    }
    
    /// Gets a new `SubVector2` wieh the coordinates of `y`, `z`, in that order.
    @_transparent
    public var yz: SubVector2 {
        .init(x: underlying.y, y: underlying.z)
    }
    
    /// Gets a new `SubVector2` wieh the coordinates of `z`, `y`, in that order.
    @_transparent
    public var zy: SubVector2 {
        .init(x: underlying.z, y: underlying.y)
    }
    
    @_transparent
    public init(underlying: Vector) {
        self.underlying = underlying
    }
}
