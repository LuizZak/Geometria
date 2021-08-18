/// Describes an edge inset with double-precision, floating-point parameters
public typealias EdgeInsets = EdgeInsetsT<Double>

/// Describes an edge inset
public struct EdgeInsetsT<Scalar: VectorScalar>: Equatable {
    public static var zero: Self { EdgeInsetsT(top: 0, left: 0, bottom: 0, right: 0) }

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

    public func inset(rectangle: RectangleT<Scalar>) -> RectangleT<Scalar> {
        return rectangle.inset(self)
    }
}
