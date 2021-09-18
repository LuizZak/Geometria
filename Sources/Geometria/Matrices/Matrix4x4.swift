import RealModule

/// Plain Matrix4x4 with floating-point components.
public struct Matrix4x4<Scalar: FloatingPoint & ElementaryFunctions>: Equatable, CustomStringConvertible {
    /// The full type of this matrix's backing, as a tuple of columns.
    public typealias M = (Row, Row, Row, Row)
    
    /// The type of this matrix's row.
    public typealias Row = (Scalar, Scalar, Scalar, Scalar)
    
    /// The type of this matrix's column.
    public typealias Column = (Scalar, Scalar, Scalar, Scalar)
    
    /// Gets or sets all coefficients of this matrix as a single 4x4 tuple.
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
    
    /// The third row of this matrix
    ///
    /// Equivalent to `self.m.2`.
    public var r2: Row {
        @_transparent
        get { m.2 }
        @_transparent
        set { m.2 = newValue }
    }
    
    /// The fourth row of this matrix.
    ///
    /// Equivalent to `self.m.3`.
    public var r3: Row {
        @_transparent
        get { m.3 }
        @_transparent
        set { m.3 = newValue }
    }
    
    /// The first column of this matrix
    ///
    /// Equivalent to `(self.r0.0, self.r1.0, self.r2.0, self.r3.0)`.
    public var c0: Row {
        @_transparent
        get { (r0.0, r1.0, r2.0, r3.0) }
        @_transparent
        set { (r0.0, r1.0, r2.0, r3.0) = newValue }
    }
    
    /// The second column of this matrix
    ///
    /// Equivalent to `(self.r0.1, self.r1.1, self.r2.1, self.r3.1)`.
    public var c1: Row {
        @_transparent
        get { (r0.1, r1.1, r2.1, r3.1) }
        @_transparent
        set { (r0.1, r1.1, r2.1, r3.1) = newValue }
    }
    
    /// The third column of this matrix
    ///
    /// Equivalent to `(self.r0.2, self.r1.2, self.r2.2, self.r3.2)`.
    public var c2: Row {
        @_transparent
        get { (r0.2, r1.2, r2.2, r3.2) }
        @_transparent
        set { (r0.2, r1.2, r2.2, r3.2) = newValue }
    }
    
    /// The fourth column of this matrix
    ///
    /// Equivalent to `(self.r0.3, self.r1.3, self.r2.3, self.r3.3)`.
    public var c3: Row {
        @_transparent
        get { (r0.3, r1.3, r2.3, r3.3) }
        @_transparent
        set { (r0.3, r1.3, r2.3, r3.3) = newValue }
    }
    
    /// Subscripts into this matrix using column/row numbers.
    public subscript(column: Int, row: Int) -> Scalar {
        @_transparent
        get {
            switch (row, column) {
            // Row 0
            case (0, 0): return r0.0
            case (0, 1): return r0.1
            case (0, 2): return r0.2
            case (0, 3): return r0.3
            // Row 1
            case (1, 0): return r1.0
            case (1, 1): return r1.1
            case (1, 2): return r1.2
            case (1, 3): return r1.3
            // Row 2
            case (2, 0): return r2.0
            case (2, 1): return r2.1
            case (2, 2): return r2.2
            case (2, 3): return r2.3
            // Row 2
            case (3, 0): return r3.0
            case (3, 1): return r3.1
            case (3, 2): return r3.2
            case (3, 3): return r3.3
            default:
                preconditionFailure("Rows/columns for Matrix4x4 run from 0 to 3, inclusive.")
            }
        }
        set {
            switch (row, column) {
            // Row 0
            case (0, 0): r0.0 = newValue
            case (0, 1): r0.1 = newValue
            case (0, 2): r0.2 = newValue
            case (0, 3): r0.3 = newValue
            // Row 1
            case (1, 0): r1.0 = newValue
            case (1, 1): r1.1 = newValue
            case (1, 2): r1.2 = newValue
            case (1, 3): r1.3 = newValue
            // Row 2
            case (2, 0): r2.0 = newValue
            case (2, 1): r2.1 = newValue
            case (2, 2): r2.2 = newValue
            case (2, 3): r2.3 = newValue
            // Row 2
            case (3, 0): r3.0 = newValue
            case (3, 1): r3.1 = newValue
            case (3, 2): r3.2 = newValue
            case (3, 3): r3.3 = newValue
            default:
                preconditionFailure("Columns and rows for Matrix4x4 run from 0 to 3, inclusive.")
            }
        }
    }
    
    /// Returns a `String` that represents this instance.
    public var description: String {
        """
        [M00:\(r0.0) M01:\(r0.1) M02:\(r0.2) M03:\(r0.3)]\
        [M10:\(r1.0) M11:\(r1.1) M12:\(r1.2) M13:\(r1.3)]\
        [M20:\(r2.0) M21:\(r2.1) M22:\(r2.2) M23:\(r2.3)]\
        [M30:\(r3.0) M31:\(r3.1) M32:\(r3.2) M33:\(r3.3)]
        """
    }
    
    /// Initializes an identity matrix.
    public init() {
        m = ((1, 0, 0, 0),
             (0, 1, 0, 0),
             (0, 0, 1, 0),
             (0, 0, 0, 1))
    }
    
    /// Initializes a new matrix with the given row values.
    public init(rows: (Row, Row, Row, Row)) {
        m = rows
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.m == rhs.m
    }
}

/// Performs an equality check over a tuple of ``Matrix4x4`` values.
public func == <T: Equatable>(_ lhs: Matrix4x4<T>.M, _ rhs: Matrix4x4<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3
}
