import RealModule

/// Plain 2-row 2-column Matrix with floating-point components.
public struct Matrix2x2<Scalar: FloatingPoint & ElementaryFunctions & DivisibleArithmetic>: MatrixType, CustomStringConvertible {
    /// Returns a 2x2 [identity matrix].
    ///
    /// [identity matrix]: https://en.wikipedia.org/wiki/Identity_matrix
    @_transparent
    public static var identity: Self {
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
    
    /// Returns the number of rows in this matrix.
    ///
    /// For ``Matrix2x2`` instances, this value is always `2`.
    public let rowCount: Int = 2
    
    /// Returns the number of columns in this matrix.
    ///
    /// For ``Matrix2x2`` instances, this value is always `2`.
    public let columnCount: Int = 2
    
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
    
    /// Returns the [trace] of this matrix, i.e. the sum of all the values on
    /// its diagonal:
    ///
    /// ```swift
    /// self[0, 0] + self[1, 1]
    /// ```
    ///
    /// [trace]: https://en.wikipedia.org/wiki/Trace_(linear_algebra)
    @_transparent
    public var trace: Scalar {
        r0.0 + r1.1
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
    
    /// Initializes a new matrix with the given ``Vector2Type`` values as the
    /// values for each row.
    @_transparent
    public init<Vector: Vector2Type>(rows: (Vector, Vector)) where Vector.Scalar == Scalar {
        self.init(rows: (
            (rows.0.x, rows.0.y),
            (rows.1.x, rows.1.y)
        ))
    }
    
    /// Initializes a matrix with the given scalar on all positions.
    @_transparent
    public init(repeating scalar: Scalar) {
        m = (
            (scalar, scalar),
            (scalar, scalar)
        )
    }
    
    /// Initializes a matrix with the given scalars laid out on the diagonal,
    /// with all remaining elements being `.zero`.
    @_transparent
    public init(diagonal: (Scalar, Scalar)) {
        m = (
            (diagonal.0,          0),
            (         0, diagonal.1)
        )
    }
    
    /// Initializes a matrix with the given scalar laid out on the diagonal,
    /// with all remaining elements being `.zero`.
    @_transparent
    public init(diagonal: Scalar) {
        self.init(diagonal: (diagonal, diagonal))
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
    
    /// Returns the [inverse of this matrix](https://en.wikipedia.org/wiki/Invertible_matrix).
    ///
    /// If this matrix has no inversion, `nil` is returned, instead.
    @_transparent
    public func inverted() -> Self? {
        // Use technique described in:
        // https://en.wikipedia.org/wiki/Invertible_matrix#Inversion_of_2_%C3%97_2_matrices
        
        let det = determinant()
        if det.isZero {
            return nil
        }
        
        let a = r0.0
        let b = r0.1
        let c = r1.0
        let d = r1.1
        
        let invDet = 1 / det
        
        let intermediary =
        Self(rows: (
            ( d, -b),
            (-c,  a)
        ))
        
        return intermediary * invDet
    }
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    public static func + (lhs: Self, rhs: Self) -> Self {
        let r0 = lhs.r0Vec + rhs.r0Vec
        let r1 = lhs.r1Vec + rhs.r1Vec
        
        return Self(rows: (r0, r1))
    }
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    public static func - (lhs: Self, rhs: Self) -> Self {
        let r0 = lhs.r0Vec - rhs.r0Vec
        let r1 = lhs.r1Vec - rhs.r1Vec
        
        return Self(rows: (r0, r1))
    }
    
    /// Negates (i.e. flips) the signs of all the values of this matrix.
    public static prefix func - (value: Self) -> Self {
        let r0 = -value.r0Vec
        let r1 = -value.r1Vec
        
        return Self(rows: (r0, r1))
    }
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        let r0 = lhs.r0Vec * rhs
        let r1 = lhs.r1Vec * rhs
        
        return Self(rows: (r0, r1))
    }
    
    /// Performs a scalar division between the elements of `lhs` and `rhs` and
    /// returns the result.
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        let r0 = lhs.r0Vec / rhs
        let r1 = lhs.r1Vec / rhs
        
        return Self(rows: (r0, r1))
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
    
    /// Performs an in-place [matrix multiplication] between `lhs` and `rhs`
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
