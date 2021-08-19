/// Describes a 2D edge inset with double-precision floating-point parameters
public typealias EdgeInsets2D = EdgeInsets2<Double>

/// Describes a 2D edge inset with single-precision floating-point parameters
public typealias EdgeInsets2F = EdgeInsets2<Float>

/// Describes a 2D edge inset
public struct EdgeInsets2<Scalar: VectorScalar>: Equatable {
    public static var zero: Self { EdgeInsets2(top: 0, left: 0, bottom: 0, right: 0) }

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

    public func inset(rectangle: Rectangle2<Scalar>) -> Rectangle2<Scalar> {
        return rectangle.inset(self)
    }
}
