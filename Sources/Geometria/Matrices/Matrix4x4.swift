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
    
    /// Gets the first row of this matrix in a Vector4.
    public var r0Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(r0) }
    }
    
    /// Gets the second row of this matrix in a Vector4.
    public var r1Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(r1) }
    }
    
    /// Gets the third row of this matrix in a Vector4.
    public var r2Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(r2) }
    }
    
    /// Gets the fourth row of this matrix in a Vector4.
    public var r3Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(r3) }
    }
    
    /// Gets the first column of this matrix in a Vector4.
    public var c0Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(c0) }
    }
    
    /// Gets the second column of this matrix in a Vector4.
    public var c1Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(c1) }
    }
    
    /// Gets the third column of this matrix in a Vector4.
    public var c2Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(c2) }
    }
    
    /// Gets the fourth column of this matrix in a Vector4.
    public var c3Vec: Vector4<Scalar> {
        @_transparent
        get { Vector4(c3) }
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
        @_transparent
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
        "\(type(of: self))(rows: \(m))"
    }
    
    /// Initializes an identity matrix.
    @_transparent
    public init() {
        m = ((1, 0, 0, 0),
             (0, 1, 0, 0),
             (0, 0, 1, 0),
             (0, 0, 0, 1))
    }
    
    /// Initializes a new matrix with the given row values.
    @_transparent
    public init(rows: (Row, Row, Row, Row)) {
        m = rows
    }
    
    /// Creates a matrix that when applied to a vector, scales each coordinate
    /// by the given ammount.
    public static func makeScale(x: Scalar, y: Scalar, z: Scalar) -> Self {
        Self(rows: (
            (x, 0, 0, 0),
            (0, y, 0, 0),
            (0, 0, z, 0),
            (0, 0, 0, 1)
        ))
    }
    
    /// Creates a matrix that when applied to a vector, scales each coordinate
    /// by the corresponding coordinate on a supplied vector.
    public static func makeScale<Vector: Vector3Type>(_ vec: Vector) -> Self where Vector.Scalar == Scalar {
        makeScale(x: vec.x, y: vec.y, z: vec.z)
    }
    
    /// Performs a [matrix multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [matrix multiplication]: http://en.wikipedia.org/wiki/Matrix_multiplication
    @_transparent
    public static func * (lhs: Self, rhs: Self) -> Self {
        let r00 = lhs.r0Vec.dot(rhs.c0Vec)
        let r01 = lhs.r0Vec.dot(rhs.c1Vec)
        let r02 = lhs.r0Vec.dot(rhs.c2Vec)
        let r03 = lhs.r0Vec.dot(rhs.c3Vec)
        let r10 = lhs.r1Vec.dot(rhs.c0Vec)
        let r11 = lhs.r1Vec.dot(rhs.c1Vec)
        let r12 = lhs.r1Vec.dot(rhs.c2Vec)
        let r13 = lhs.r1Vec.dot(rhs.c3Vec)
        let r20 = lhs.r2Vec.dot(rhs.c0Vec)
        let r21 = lhs.r2Vec.dot(rhs.c1Vec)
        let r22 = lhs.r2Vec.dot(rhs.c2Vec)
        let r23 = lhs.r2Vec.dot(rhs.c3Vec)
        let r30 = lhs.r3Vec.dot(rhs.c0Vec)
        let r31 = lhs.r3Vec.dot(rhs.c1Vec)
        let r32 = lhs.r3Vec.dot(rhs.c2Vec)
        let r33 = lhs.r3Vec.dot(rhs.c3Vec)
        
        return Self(rows: ((r00, r01, r02, r03),
                           (r10, r11, r12, r13),
                           (r20, r21, r22, r23),
                           (r30, r31, r32, r33)))
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

/// Performs an equality check over a tuple of ``Matrix4x4`` values.
@_transparent
public func == <T>(_ lhs: Matrix4x4<T>.M, _ rhs: Matrix4x4<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3
}
