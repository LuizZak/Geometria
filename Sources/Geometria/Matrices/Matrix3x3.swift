import RealModule

/// Plain 3-row 3-column Matrix with floating-point components.
public struct Matrix3x3<Scalar: FloatingPoint & ElementaryFunctions>: Equatable, CustomStringConvertible {
    /// Returns a 3x3 [identity matrix].
    ///
    /// [identity matrix]: https://en.wikipedia.org/wiki/Identity_matrix
    public static var idendity: Self {
        Self.init(rows: (
            (1, 0, 0),
            (0, 1, 0),
            (0, 0, 1)
        ))
    }
    
    /// The full type of this matrix's backing, as a tuple of columns.
    public typealias M = (Row, Row, Row)
    
    /// The type of this matrix's row.
    public typealias Row = (Scalar, Scalar, Scalar)
    
    /// The type of this matrix's column.
    public typealias Column = (Scalar, Scalar, Scalar)
    
    /// Gets or sets all coefficients of this matrix as a single 3x3 tuple.
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
    
    /// The first column of this matrix
    ///
    /// Equivalent to `(self.r0.0, self.r1.0, self.r2.0)`.
    public var c0: Column {
        @_transparent
        get { (r0.0, r1.0, r2.0) }
        @_transparent
        set { (r0.0, r1.0, r2.0) = newValue }
    }
    
    /// The second column of this matrix
    ///
    /// Equivalent to `(self.r0.1, self.r1.1, self.r2.1)`.
    public var c1: Column {
        @_transparent
        get { (r0.1, r1.1, r2.1) }
        @_transparent
        set { (r0.1, r1.1, r2.1) = newValue }
    }
    
    /// The third column of this matrix
    ///
    /// Equivalent to `(self.r0.2, self.r1.2, self.r2.2)`.
    public var c2: Column {
        @_transparent
        get { (r0.2, r1.2, r2.2) }
        @_transparent
        set { (r0.2, r1.2, r2.2) = newValue }
    }
    
    /// Gets the first row of this matrix in a Vector3.
    public var r0Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(r0) }
    }
    
    /// Gets the second row of this matrix in a Vector3.
    public var r1Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(r1) }
    }
    
    /// Gets the third row of this matrix in a Vector3.
    public var r2Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(r2) }
    }
    
    /// Gets the first column of this matrix in a Vector3.
    public var c0Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(c0) }
    }
    
    /// Gets the second column of this matrix in a Vector3.
    public var c1Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(c1) }
    }
    
    /// Gets the third column of this matrix in a Vector3.
    public var c2Vec: Vector3<Scalar> {
        @_transparent
        get { Vector3(c2) }
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
            // Row 1
            case (1, 0): return r1.0
            case (1, 1): return r1.1
            case (1, 2): return r1.2
            // Row 2
            case (2, 0): return r2.0
            case (2, 1): return r2.1
            case (2, 2): return r2.2
            default:
                preconditionFailure("Rows/columns for Matrix3x3 run from [0, 0] to [2, 2], inclusive.")
            }
        }
        @_transparent
        set {
            switch (row, column) {
            // Row 0
            case (0, 0): r0.0 = newValue
            case (0, 1): r0.1 = newValue
            case (0, 2): r0.2 = newValue
            // Row 1
            case (1, 0): r1.0 = newValue
            case (1, 1): r1.1 = newValue
            case (1, 2): r1.2 = newValue
            // Row 2
            case (2, 0): r2.0 = newValue
            case (2, 1): r2.1 = newValue
            case (2, 2): r2.2 = newValue
            default:
                preconditionFailure("Rows/columns for Matrix3x3 run from [0, 0] to [2, 2], inclusive.")
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
        m = ((1, 0, 0),
             (0, 1, 0),
             (0, 0, 1))
    }
    
    /// Initializes a new matrix with the given row values.
    @_transparent
    public init(rows: (Row, Row, Row)) {
        m = rows
    }
    
    /// Initializes a matrix with the given scalar on all positions.
    @_transparent
    public init(repeating scalar: Scalar) {
        m = (
            (scalar, scalar, scalar),
            (scalar, scalar, scalar),
            (scalar, scalar, scalar)
        )
    }
    
    /// Returns the [determinant] of this matrix.
    ///
    /// [determinant]: https://en.wikipedia.org/wiki/Determinant
    public func determinant() -> Scalar {
        // Use Rule os Sarrus (https://en.wikipedia.org/wiki/Rule_of_Sarrus)
        // to simplify 3x3 det computation here
        
        // | a b c |   | r0 |
        // | d e f | = | r1 |
        // | g h i |   | r2 |
        
        let (a, b, c) = r0
        let (d, e, f) = r1
        let (g, h, i) = r2
        
        let d1: Scalar = a * e * i
        let d2: Scalar = b * f * g
        let d3: Scalar = c * d * h
        
        let d4: Scalar = g * e * c
        let d5: Scalar = h * f * a
        let d6: Scalar = i * d * b
        
        let det: Scalar = d1 + d2 + d3 - d4 - d5 - d6
        
        return det
    }
    
    // TODO: Support specifying row-major/column-major when multiplying vectors.
    
    /// Transforms a given vector as a point, applying scaling, rotation and
    /// translation to the vector.
    @_transparent
    public func transformPoint<Vector: Vector3FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let px = vec.dot(.init(r0Vec))
        let py = vec.dot(.init(r1Vec))
        let pz = vec.dot(.init(r2Vec))
        
        return Vector(x: px, y: py, z: pz)
    }
    
    /// Transforms a given vector as a point, applying scaling, rotation and
    /// translation to the vector.
    @_transparent
    public func transformPoint<Vector: Vector2FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let vec3 = Vector3(vec, z: 1)
        
        let result = transformPoint(vec3)
        
        // Normalize z component
        if result.z != 0 && result.z != 1 {
            return Vector(x: result.x, y: result.y) / result.z
        }
        
        return Vector(x: result.x, y: result.y)
    }
    
    /// Returns a new ``Matrix3x3`` that is a [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    @_transparent
    public func transposed() -> Self {
        Self(rows: (
            c0, c1, c2
        ))
    }
    
    /// Performs an in-place [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    @_transparent
    public mutating func transpose() {
        self = transposed()
    }
    
    /// Creates a matrix that when applied to a vector, scales each coordinate
    /// by the given amount.
    @_transparent
    public static func makeScale(x: Scalar, y: Scalar) -> Self {
        Self(rows: (
            (x, 0, 0),
            (0, y, 0),
            (0, 0, 1)
        ))
    }
    
    /// Creates a matrix that when applied to a vector, scales each coordinate
    /// by the corresponding coordinate on a supplied vector.
    @_transparent
    public static func makeScale<Vector: Vector2Type>(_ vec: Vector) -> Self where Vector.Scalar == Scalar {
        makeScale(x: vec.x, y: vec.y)
    }
    
    /// Creates a rotation matrix that when applied to a vector, rotates it
    /// around the origin by a specified radian amount.
    @_transparent
    public static func makeRotation(_ angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(rows: (
            ( c, s, 0),
            (-s, c, 0),
            ( 0, 0, 1)
        ))
    }
    
    /// Creates a translation matrix that when applied to a vector, moves it
    /// according to the specified amounts.
    @_transparent
    public static func makeTranslation(x: Scalar, y: Scalar) -> Self {
        Self(rows: (
            (1, 0, x),
            (0, 1, y),
            (0, 0, 1)
        ))
    }
    
    /// Creates a translation matrix that when applied to a vector, moves it
    /// according to the specified amounts.
    @_transparent
    public static func makeTranslation<Vector: Vector2Type>(_ vec: Vector) -> Self where Vector.Scalar == Scalar {
        makeTranslation(x: vec.x, y: vec.y)
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
        let r10 = lhs.r1Vec.dot(rhs.c0Vec)
        let r11 = lhs.r1Vec.dot(rhs.c1Vec)
        let r12 = lhs.r1Vec.dot(rhs.c2Vec)
        let r20 = lhs.r2Vec.dot(rhs.c0Vec)
        let r21 = lhs.r2Vec.dot(rhs.c1Vec)
        let r22 = lhs.r2Vec.dot(rhs.c2Vec)
        
        return Self(rows: (
            (r00, r01, r02),
            (r10, r11, r12),
            (r20, r21, r22)
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

/// Performs an equality check over a tuple of ``Matrix3x3`` values.
@_transparent
public func == <T>(_ lhs: Matrix3x3<T>.M, _ rhs: Matrix3x3<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
}
