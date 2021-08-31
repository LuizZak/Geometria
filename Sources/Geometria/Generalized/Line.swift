import RealModule

/// Represents a line as a pair of start and end N-dimensional vectors which
/// describe the two points an infinite line crosses.
public struct Line<Vector: VectorType>: LineType {
    public typealias Scalar = Vector.Scalar
    
    /// An initial point a line tracing from infinity passes through before
    /// being projected through `b` and extending to infinity in a straight line.
    public var a: Vector
    
    /// A secondary point a line tracing from `a` passes through before
    /// being projected to infinity in a straight line.
    public var b: Vector
    
    @_transparent
    public init(a: Vector, b: Vector) {
        self.a = a
        self.b = b
    }
}

extension Line: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Line: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Line: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Line: Decodable where Vector: Decodable, Scalar: Decodable { }

extension Line: LineFloatingPoint where Vector: VectorFloatingPoint {
    /// Returns `true` for all scalar values, which describes a [geometric line].
    ///
    /// This makes the line behave effectively like an infinitely long line when
    /// working with methods from ``LineFloatingPoint`` conformance.
    ///
    /// [geometric line]: https://en.wikipedia.org/wiki/Line_(geometry)
    @_transparent
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        true
    }
}

extension Line: LineReal where Vector: VectorReal {
    
}
