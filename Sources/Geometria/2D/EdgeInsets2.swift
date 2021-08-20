/// Represents a 2D edge inset with double-precision floating-point parameters.
public typealias EdgeInsets2D = EdgeInsets2<Double>

/// Represents a 2D edge inset with single-precision floating-point parameters.
public typealias EdgeInsets2F = EdgeInsets2<Float>

/// Represents a 2D edge inset as relative inset values for each of the four
/// edges of a rectangular 2D perimeter.
public struct EdgeInsets2<Scalar> {
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

extension EdgeInsets2: Equatable where Scalar: Equatable { }
extension EdgeInsets2: Hashable where Scalar: Hashable { }
extension EdgeInsets2: Encodable where Scalar: Encodable { }
extension EdgeInsets2: Decodable where Scalar: Decodable { }

extension EdgeInsets2 where Scalar: AdditiveArithmetic {
    public func inset(rectangle: Rectangle2<Scalar>) -> Rectangle2<Scalar> {
        return rectangle.inset(self)
    }
}

extension EdgeInsets2 where Scalar: Numeric {
    @inlinable
    static var zero: Self { EdgeInsets2(top: 0, left: 0, bottom: 0, right: 0) }
}
