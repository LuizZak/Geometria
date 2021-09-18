import RealModule

/// Plain Matrix4x4 with floating-point components.
public struct Matrix4x4<Scalar: FloatingPoint & ElementaryFunctions>: Equatable, CustomStringConvertible {
    /// The full type of this matrix's backing, as a tuple of columns.
    public typealias M = (Column, Column, Column, Column)
    
    /// The type of this matrix's column.
    public typealias Column = (Scalar, Scalar, Scalar, Scalar)
    
    /// Gets or sets all coefficients of this matrix as a single 4x4 tuple.
    public var m: M
    
    /// The first column of this matrix
    ///
    /// Equivalent to `self.c.0`.
    public var c0: Column {
        @_transparent
        get { m.0 }
        @_transparent
        set { m.0 = newValue }
    }
    
    /// The second column of this matrix
    ///
    /// Equivalent to `self.c.1`.
    public var c1: Column {
        @_transparent
        get { m.1 }
        @_transparent
        set { m.1 = newValue }
    }
    
    /// The third column of this matrix
    ///
    /// Equivalent to `self.c.2`.
    public var c2: Column {
        @_transparent
        get { m.2 }
        @_transparent
        set { m.2 = newValue }
    }
    
    /// The fourth column of this matrix.
    ///
    /// Equivalent to `self.c.3`.
    public var c3: Column {
        @_transparent
        get { m.3 }
        @_transparent
        set { m.3 = newValue }
    }
    
    /// Subscripts into this matrix using column/row numbers.
    public subscript(column: Int, row: Int) -> Scalar {
        @_transparent
        get {
            switch (row, column) {
            // Row 0
            case (0, 0): return c0.0
            case (0, 1): return c0.1
            case (0, 2): return c0.2
            case (0, 3): return c0.3
            // Row 1
            case (1, 0): return c1.0
            case (1, 1): return c1.1
            case (1, 2): return c1.2
            case (1, 3): return c1.3
            // Row 2
            case (2, 0): return c2.0
            case (2, 1): return c2.1
            case (2, 2): return c2.2
            case (2, 3): return c2.3
            // Row 2
            case (3, 0): return c3.0
            case (3, 1): return c3.1
            case (3, 2): return c3.2
            case (3, 3): return c3.3
            default:
                preconditionFailure("Rows/columns for Matrix4x4 run from 0 to 3, inclusive.")
            }
        }
        set {
            switch (row, column) {
            // Row 0
            case (0, 0): c0.0 = newValue
            case (0, 1): c0.1 = newValue
            case (0, 2): c0.2 = newValue
            case (0, 3): c0.3 = newValue
            // Row 1
            case (1, 0): c1.0 = newValue
            case (1, 1): c1.1 = newValue
            case (1, 2): c1.2 = newValue
            case (1, 3): c1.3 = newValue
            // Row 2
            case (2, 0): c2.0 = newValue
            case (2, 1): c2.1 = newValue
            case (2, 2): c2.2 = newValue
            case (2, 3): c2.3 = newValue
            // Row 2
            case (3, 0): c3.0 = newValue
            case (3, 1): c3.1 = newValue
            case (3, 2): c3.2 = newValue
            case (3, 3): c3.3 = newValue
            default:
                preconditionFailure("Columns and rows for Matrix4x4 run from 0 to 3, inclusive.")
            }
        }
    }
    
    /// Returns a `String` that represents this instance.
    public var description: String {
        """
        [C00:\(c0.0) C01:\(c0.1) C02:\(c0.2) C03:\(c0.3)]\
        [C10:\(c1.0) C11:\(c1.1) C12:\(c1.2) C13:\(c1.3)]\
        [C20:\(c2.0) C21:\(c2.1) C22:\(c2.2) C23:\(c2.3)]\
        [C30:\(c3.0) C31:\(c3.1) C32:\(c3.2) C33:\(c3.3)]
        """
    }
    
    /// Initializes an identity matrix.
    public init() {
        m = ((1, 0, 0, 0),
             (0, 1, 0, 0),
             (0, 0, 1, 0),
             (0, 0, 0, 1))
    }
    
    /// Initializes a new matrix with the given column values.
    public init(columns: (Column, Column, Column, Column)) {
        m = columns
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.m == rhs.m
    }
}

/// Performs an equality check over a tuple of ``Matrix4x4`` values.
public func == <T: Equatable>(_ lhs: Matrix4x4<T>.M, _ rhs: Matrix4x4<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3
}
