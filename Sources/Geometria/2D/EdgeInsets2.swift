/// Represents a 2D edge inset with double-precision floating-point parameters.
public typealias EdgeInsets2D = EdgeInsets2<Vector2D>

/// Represents a 2D edge inset with single-precision floating-point parameters.
public typealias EdgeInsets2F = EdgeInsets2<Vector2F>

/// Represents a 2D edge inset with integer parameters.
public typealias EdgeInsets2i = EdgeInsets2<Vector2i>

/// Represents a 2D edge inset as relative inset values for each of the four
/// edges of a rectangular 2D perimeter.
public struct EdgeInsets2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var top: Scalar
    public var left: Scalar
    public var bottom: Scalar
    public var right: Scalar
    
    public init(top: Scalar,
                left: Scalar,
                bottom: Scalar,
                right: Scalar) {
        
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(_ value: Scalar) {
        top = value
        left = value
        bottom = value
        right = value
    }
}

extension EdgeInsets2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension EdgeInsets2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension EdgeInsets2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension EdgeInsets2: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension EdgeInsets2 where Vector: VectorAdditive {
    @inlinable
    static var zero: Self {
        EdgeInsets2(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
    
    func inset(rectangle: Rectangle2<Vector>) -> Rectangle2<Vector> {
        return rectangle.inset(self)
    }
}
