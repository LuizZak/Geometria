public extension Triangle where Scalar: Equatable {
    /// Defines the normalized [barycentric coordinates] for a ``Triangle``.
    ///
    /// [barycentric coordinates]: https://en.wikipedia.org/wiki/Barycentric_coordinate_system#Barycentric_coordinates_on_triangles
    struct Coordinates: Equatable {
        /// Weight of vertex ``Triangle/a``.
        public var wa: Scalar
        
        /// Weight of vertex ``Triangle/b``.
        public var wb: Scalar
        
        /// Weight of vertex ``Triangle/c``.
        public var wc: Scalar
        
        @_transparent
        public init(wa: Scalar, wb: Scalar, wc: Scalar) {
            self.wa = wa
            self.wb = wb
            self.wc = wc
        }
    }
}

public extension Triangle.Coordinates where Vector.Scalar: AdditiveArithmetic {
    /// Returns zerod-out barycentric coordinates.
    @_transparent
    static var zero: Self { Self(wa: .zero, wb: .zero, wc: .zero) }
}

extension Triangle where Vector: VectorMultiplicative {
    /// Projects the given barycentric coordinates back into world space.
    @inlinable
    public func projectToWorld(_ proj: Coordinates) -> Vector {
        proj.wa * a + proj.wb * b + proj.wc * c
    }
}
