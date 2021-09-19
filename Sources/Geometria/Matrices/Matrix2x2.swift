import RealModule

/// Plain 2-row 2-column Matrix with floating-point components.
public struct Matrix2x2<Scalar: FloatingPoint & ElementaryFunctions>: Equatable, CustomStringConvertible {
    /// Returns a 2x2 [identity matrix].
    ///
    /// [identity matrix]: https://en.wikipedia.org/wiki/Identity_matrix
    @_transparent
    public static var idendity: Self {
        Self.init(rows: (
            (1, 0),
            (0, 1)
        ))
    }
    
    /// The full type of this matrix's backing, as a tuple of columns.
    public typealias M = (Row, Row)
    
    /// The type of this matrix's row.
    public typealias Row = (Scalar, Scalar)
    
    /// The type of this matrix's column.
    public typealias Column = (Scalar, Scalar)
    
    /// Gets or sets all coefficients of this matrix as a single 2x2 tuple.
    public var m: M
    
    /// The first row of this matrix
    ///
    /// Equivalent to `self.m.0`.
    public var r0: Row {
        @_transparent
        get { m.0 }
        @_transparent
        set { m.0 = newValue }
    }
    
    /// The second row of this matrix
    ///
    /// Equivalent to `self.m.1`.
    public var r1: Row {
        @_transparent
        get { m.1 }
        @_transparent
        set { m.1 = newValue }
    }
    
    /// The first column of this matrix
    ///
    /// Equivalent to `(self.r0.0, self.r1.0)`.
    public var c0: Column {
        @_transparent
        get { (r0.0, r1.0) }
        @_transparent
        set { (r0.0, r1.0) = newValue }
    }
    
    /// The second column of this matrix
    ///
    /// Equivalent to `(self.r0.1, self.r1.1)`.
    public var c1: Column {
        @_transparent
        get { (r0.1, r1.1) }
        @_transparent
        set { (r0.1, r1.1) = newValue }
    }
    
    /// Gets the first row of this matrix in a Vector2.
    public var r0Vec: Vector2<Scalar> {
        @_transparent
        get { Vector2(r0) }
    }
    
    /// Gets the second row of this matrix in a Vector2.
    public var r1Vec: Vector2<Scalar> {
        @_transparent
        get { Vector2(r1) }
    }
    
    /// Gets the first column of this matrix in a Vector2.
    public var c0Vec: Vector2<Scalar> {
        @_transparent
        get { Vector2(c0) }
    }
    
    /// Gets the second column of this matrix in a Vector2.
    public var c1Vec: Vector2<Scalar> {
        @_transparent
        get { Vector2(c1) }
    }
    
    /// Subscripts into this matrix using column/row numbers.
    public subscript(column: Int, row: Int) -> Scalar {
        @_transparent
        get {
            switch (row, column) {
            // Row 0
            case (0, 0): return r0.0
            case (0, 1): return r0.1
            // Row 1
            case (1, 0): return r1.0
            case (1, 1): return r1.1
            default:
                preconditionFailure("Rows/columns for Matrix2x2 run from [0, 0] to [1, 1], inclusive.")
            }
        }
        @_transparent
        set {
            switch (row, column) {
            // Row 0
            case (0, 0): r0.0 = newValue
            case (0, 1): r0.1 = newValue
            // Row 1
            case (1, 0): r1.0 = newValue
            case (1, 1): r1.1 = newValue
            default:
                preconditionFailure("Rows/columns for Matrix2x2 run from [0, 0] to [1, 1], inclusive.")
            }
        }
    }
    
    /// Returns a `String` that represents this instance.
    public var description: String {
        "\(type(of: self))(rows: \(m))"
    }
    
    /// Initializes an identity matrix.
    @_transparent
    public init() {
        m = ((1, 0), (0, 1))
    }
    
    /// Initializes a new matrix with the given row values.
    @_transparent
    public init(rows: (Row, Row)) {
        m = rows
    }
    
    /// Initializes a matrix with the given scalar on all positions.
    @_transparent
    public init(repeating scalar: Scalar) {
        m = (
            (scalar, scalar),
            (scalar, scalar)
        )
    }
    
    /// Returns the [determinant] of this matrix.
    ///
    /// [determinant]: https://en.wikipedia.org/wiki/Determinant
    @inlinable
    public func determinant() -> Scalar {
        let (a, b) = r0
        let (c, d) = r1
        
        return a * d - c * b
    }
    
    // TODO: Support specifying row-major/column-major when multiplying vectors.
    
    /// Transforms a given vector as a point, applying scaling, rotation and
    /// translation to the vector.
    @_transparent
    public func transformPoint<Vector: Vector2FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let px = vec.dot(.init(r0Vec))
        let py = vec.dot(.init(r1Vec))
        
        return Vector(x: px, y: py)
    }
    
    /// Returns a new ``Matrix2x2`` that is a [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    @_transparent
    public func transposed() -> Self {
        Self(rows: (
            c0, c1
        ))
    }
    
    /// Performs an in-place [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    @_transparent
    public mutating func transpose() {
        self = transposed()
    }
    
    /// Performs a [matrix multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [matrix multiplication]: http://en.wikipedia.org/wiki/Matrix_multiplication
    @_transparent
    public static func * (lhs: Self, rhs: Self) -> Self {
        let r00 = lhs.r0Vec.dot(rhs.c0Vec)
        let r01 = lhs.r0Vec.dot(rhs.c1Vec)
        let r10 = lhs.r1Vec.dot(rhs.c0Vec)
        let r11 = lhs.r1Vec.dot(rhs.c1Vec)
        
        return Self(rows: (
            (r00, r01),
            (r10, r11)
        ))
    }
    
    /// Performs an in-place [matrix multiplication] between `lhs` and `rhs`,
    /// and stores the result back to `lhs`.
    ///
    /// [matrix multiplication]: http://en.wikipedia.org/wiki/Matrix_multiplication
    @_transparent
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    /// Returns `true` iff all coefficients from `lhs` and `rhs` are equal.
    @_transparent
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.m == rhs.m
    }
}

/// Performs an equality check over a tuple of ``Matrix2x2`` values.
@_transparent
public func == <T>(_ lhs: Matrix2x2<T>.M, _ rhs: Matrix2x2<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1
}