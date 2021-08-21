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
    
    public var left: Scalar
    public var top: Scalar
    public var right: Scalar
    public var bottom: Scalar
    
    public init(left: Scalar,
                top: Scalar,
                right: Scalar,
                bottom: Scalar) {
        
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public init(_ value: Scalar) {
        left = value
        top = value
        right = value
        bottom = value
    }
}

extension EdgeInsets2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension EdgeInsets2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension EdgeInsets2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension EdgeInsets2: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension EdgeInsets2 where Vector: VectorAdditive {
    @inlinable
    static var zero: Self {
        EdgeInsets2(left: .zero, top: .zero, right: .zero, bottom: .zero)
    }
    
    func inset(rectangle: NRectangle<Vector>) -> NRectangle<Vector> {
        return rectangle.inset(self)
    }
}
