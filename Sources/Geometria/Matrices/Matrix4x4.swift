/*
 Matrix inversion source code's license:
 
 MIT License

 Copyright (c) 2017 Wildan Mubarok

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

import RealModule

/// Plain 4-row 4-column Matrix with real components.
public struct Matrix4x4<Scalar: Real & DivisibleArithmetic>: SquareMatrixType, CustomStringConvertible {
    /// Returns a 4x4 [identity matrix].
    ///
    /// [identity matrix]: https://en.wikipedia.org/wiki/Identity_matrix
    @_transparent
    public static var identity: Self {
        Self.init(rows: (
            (1, 0, 0, 0),
            (0, 1, 0, 0),
            (0, 0, 1, 0),
            (0, 0, 0, 1)
        ))
    }
    
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
    public var c0: Column {
        @_transparent
        get { (r0.0, r1.0, r2.0, r3.0) }
        @_transparent
        set { (r0.0, r1.0, r2.0, r3.0) = newValue }
    }
    
    /// The second column of this matrix
    ///
    /// Equivalent to `(self.r0.1, self.r1.1, self.r2.1, self.r3.1)`.
    public var c1: Column {
        @_transparent
        get { (r0.1, r1.1, r2.1, r3.1) }
        @_transparent
        set { (r0.1, r1.1, r2.1, r3.1) = newValue }
    }
    
    /// The third column of this matrix
    ///
    /// Equivalent to `(self.r0.2, self.r1.2, self.r2.2, self.r3.2)`.
    public var c2: Column {
        @_transparent
        get { (r0.2, r1.2, r2.2, r3.2) }
        @_transparent
        set { (r0.2, r1.2, r2.2, r3.2) = newValue }
    }
    
    /// The fourth column of this matrix
    ///
    /// Equivalent to `(self.r0.3, self.r1.3, self.r2.3, self.r3.3)`.
    public var c3: Column {
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
    
    /// Returns the number of rows in this matrix.
    ///
    /// For ``Matrix4x4`` instances, this value is always `4`.
    public let rowCount: Int = 4
    
    /// Returns the number of columns in this matrix.
    ///
    /// For ``Matrix4x4`` instances, this value is always `4`.
    public let columnCount: Int = 4
    
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
            // Row 3
            case (3, 0): return r3.0
            case (3, 1): return r3.1
            case (3, 2): return r3.2
            case (3, 3): return r3.3
            default:
                preconditionFailure("Rows/columns for Matrix4x4 run from [0, 0] to [3, 3], inclusive.")
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
            // Row 3
            case (3, 0): r3.0 = newValue
            case (3, 1): r3.1 = newValue
            case (3, 2): r3.2 = newValue
            case (3, 3): r3.3 = newValue
            default:
                preconditionFailure("Rows/columns for Matrix4x4 run from [0, 0] to [3, 3], inclusive.")
            }
        }
    }
    
    /// Returns the [trace] of this matrix, i.e. the sum of all the values on
    /// its diagonal:
    ///
    /// ```swift
    /// self[0, 0] + self[1, 1] + self[2, 2] + self[3, 3]
    /// ```
    ///
    /// [trace]: https://en.wikipedia.org/wiki/Trace_(linear_algebra)
    @_transparent
    public var trace: Scalar {
        r0.0 + r1.1 + r2.2 + r3.3
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
    
    /// Initializes a new matrix with the given ``Vector4`` values as the values
    /// for each row.
    @_transparent
    public init<Vector: Vector4Type>(rows: (Vector, Vector, Vector, Vector)) where Vector.Scalar == Scalar {
        self.init(rows: (
            (rows.0.x, rows.0.y, rows.0.z, rows.0.w),
            (rows.1.x, rows.1.y, rows.1.z, rows.1.w),
            (rows.2.x, rows.2.y, rows.2.z, rows.2.w),
            (rows.3.x, rows.3.y, rows.3.z, rows.3.w)
        ))
    }
    
    /// Initializes a matrix with the given scalar on all positions.
    @_transparent
    public init(repeating scalar: Scalar) {
        m = (
            (scalar, scalar, scalar, scalar),
            (scalar, scalar, scalar, scalar),
            (scalar, scalar, scalar, scalar),
            (scalar, scalar, scalar, scalar)
        )
    }
    
    /// Initializes a matrix with the given scalars laid out on the diagonal,
    /// with all remaining elements being `.zero`.
    @_transparent
    public init(diagonal: (Scalar, Scalar, Scalar, Scalar)) {
        m = (
            (diagonal.0,          0,          0,          0),
            (         0, diagonal.1,          0,          0),
            (         0,          0, diagonal.2,          0),
            (         0,          0,          0, diagonal.3)
        )
    }
    
    /// Initializes a matrix with the given scalar laid out on the diagonal,
    /// with all remaining elements being `.zero`.
    @_transparent
    public init(diagonal: Scalar) {
        self.init(diagonal: (diagonal, diagonal, diagonal, diagonal))
    }
    
    /// Returns the [determinant] of this matrix.
    ///
    /// [determinant]: https://en.wikipedia.org/wiki/Determinant
    @inlinable
    public func determinant() -> Scalar {
        // Produce a determinant by multiplying the first row with the determinant
        // of the 3x3 matrices formed by the rows bellow:
        //
        // | a b c d |   | r0 |
        // | e f g h | = | r1 |
        // | i j k l |   | r2 |
        // | m n o p |   | r3 |
        //
        //
        // | a       |   |   b     |   |     c   |   |       d |
        // |   f g h | - | e   g h | + | e f   h | - | e f g   |
        // |   j k l |   | i   k l |   | i j   l |   | i j k   |
        // |   n o p |   | m   o p |   | m n   p |   | m n o   |
        //
        //                           |
        //                           V
        //
        //       | f g h |         | e g h |         | e f h |         | e f g |
        // a det | j k l | - b det | i k l | + c det | i j l | - d det | i j k |
        //       | n o p |         | m o p |         | m n p |         | m n o |
        
        let (a, b, c, d) = r0
        let (e, f, g, h) = r1
        let (i, j, k, l) = r2
        let (m, n, o, p) = r3
        
        let aMatrix =
        Matrix3x3<Scalar>(rows: (
            (f, g, h),
            (j, k, l),
            (n, o, p)
        ))
        
        let bMatrix =
        Matrix3x3<Scalar>(rows: (
            (e, g, h),
            (i, k, l),
            (m, o, p)
        ))
        
        let cMatrix =
        Matrix3x3<Scalar>(rows: (
            (e, f, h),
            (i, j, l),
            (m, n, p)
        ))
        
        let dMatrix =
        Matrix3x3<Scalar>(rows: (
            (e, f, g),
            (i, j, k),
            (m, n, o)
        ))
        
        var det: Scalar = 0
        det.addProduct( a, aMatrix.determinant())
        det.addProduct(-b, bMatrix.determinant())
        det.addProduct( c, cMatrix.determinant())
        det.addProduct(-d, dMatrix.determinant())
        
        return det
    }
    
    // TODO: Support specifying row-major/column-major when multiplying vectors.
    
    /// Transforms a given vector as a point, applying scaling, rotation and
    /// translation to the vector.
    @_transparent
    public func transformPoint<Vector: Vector4FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let px = vec.dot(.init(r0Vec))
        let py = vec.dot(.init(r1Vec))
        let pz = vec.dot(.init(r2Vec))
        let pw = vec.dot(.init(r3Vec))
        
        return Vector(x: px, y: py, z: pz, w: pw)
    }
    
    /// Transforms a given vector as a point, applying scaling, rotation and
    /// translation to the vector.
    @_transparent
    public func transformPoint<Vector: Vector3FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let vec4 = Vector4(vec, w: 1)
        
        let result = transformPoint(vec4)
        
        // Normalize w component
        if result.w != 0 && result.w != 1 {
            return Vector(x: result.x, y: result.y, z: result.z) / result.w
        }
        
        return Vector(x: result.x, y: result.y, z: result.z)
    }
    
    /// Transforms a given vector, applying scaling, rotation and translation to
    /// the vector.
    ///
    /// The matrix is transformed as a vector and is not normalized by the W
    /// vector.
    @_transparent
    public func transformVector<Vector: Vector3FloatingPoint>(_ vec: Vector) -> Vector where Vector.Scalar == Scalar {
        let vec4 = Vector4(vec, w: 1)
        
        let result = transformPoint(vec4)
        
        return Vector(x: result.x, y: result.y, z: result.z)
    }
    
    /// Returns a new ``Matrix4x4`` that is a [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    @_transparent
    public func transposed() -> Self {
        Self(rows: (
            c0, c1, c2, c3
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
    public func inverted() -> Self? {
        let a2323: Scalar = (r2.2 * r3.3) as Scalar - (r2.3 * r3.2) as Scalar
        let a1323: Scalar = (r2.1 * r3.3) as Scalar - (r2.3 * r3.1) as Scalar
        let a1223: Scalar = (r2.1 * r3.2) as Scalar - (r2.2 * r3.1) as Scalar
        let a0323: Scalar = (r2.0 * r3.3) as Scalar - (r2.3 * r3.0) as Scalar
        let a0223: Scalar = (r2.0 * r3.2) as Scalar - (r2.2 * r3.0) as Scalar
        let a0123: Scalar = (r2.0 * r3.1) as Scalar - (r2.1 * r3.0) as Scalar
        let a2313: Scalar = (r1.2 * r3.3) as Scalar - (r1.3 * r3.2) as Scalar
        let a1313: Scalar = (r1.1 * r3.3) as Scalar - (r1.3 * r3.1) as Scalar
        let a1213: Scalar = (r1.1 * r3.2) as Scalar - (r1.2 * r3.1) as Scalar
        let a2312: Scalar = (r1.2 * r2.3) as Scalar - (r1.3 * r2.2) as Scalar
        let a1312: Scalar = (r1.1 * r2.3) as Scalar - (r1.3 * r2.1) as Scalar
        let a1212: Scalar = (r1.1 * r2.2) as Scalar - (r1.2 * r2.1) as Scalar
        let a0313: Scalar = (r1.0 * r3.3) as Scalar - (r1.3 * r3.0) as Scalar
        let a0213: Scalar = (r1.0 * r3.2) as Scalar - (r1.2 * r3.0) as Scalar
        let a0312: Scalar = (r1.0 * r2.3) as Scalar - (r1.3 * r2.0) as Scalar
        let a0212: Scalar = (r1.0 * r2.2) as Scalar - (r1.2 * r2.0) as Scalar
        let a0113: Scalar = (r1.0 * r3.1) as Scalar - (r1.1 * r3.0) as Scalar
        let a0112: Scalar = (r1.0 * r2.1) as Scalar - (r1.1 * r2.0) as Scalar
        
        var det = determinant()
        if det == 0 {
            return nil
        }
        
        det = 1 / det

        // NOTE: Doing this in separate statements to ease long compilation times in Xcode 12
        let m00: Scalar = det *  ((r1.1 * a2323) as Scalar - (r1.2 * a1323) as Scalar + (r1.3 * a1223) as Scalar) as Scalar
        let m10: Scalar = det * -((r0.1 * a2323) as Scalar - (r0.2 * a1323) as Scalar + (r0.3 * a1223) as Scalar) as Scalar
        let m20: Scalar = det *  ((r0.1 * a2313) as Scalar - (r0.2 * a1313) as Scalar + (r0.3 * a1213) as Scalar) as Scalar
        let m30: Scalar = det * -((r0.1 * a2312) as Scalar - (r0.2 * a1312) as Scalar + (r0.3 * a1212) as Scalar) as Scalar
        let m01: Scalar = det * -((r1.0 * a2323) as Scalar - (r1.2 * a0323) as Scalar + (r1.3 * a0223) as Scalar) as Scalar
        let m11: Scalar = det *  ((r0.0 * a2323) as Scalar - (r0.2 * a0323) as Scalar + (r0.3 * a0223) as Scalar) as Scalar
        let m21: Scalar = det * -((r0.0 * a2313) as Scalar - (r0.2 * a0313) as Scalar + (r0.3 * a0213) as Scalar) as Scalar
        let m31: Scalar = det *  ((r0.0 * a2312) as Scalar - (r0.2 * a0312) as Scalar + (r0.3 * a0212) as Scalar) as Scalar
        let m02: Scalar = det *  ((r1.0 * a1323) as Scalar - (r1.1 * a0323) as Scalar + (r1.3 * a0123) as Scalar) as Scalar
        let m12: Scalar = det * -((r0.0 * a1323) as Scalar - (r0.1 * a0323) as Scalar + (r0.3 * a0123) as Scalar) as Scalar
        let m22: Scalar = det *  ((r0.0 * a1313) as Scalar - (r0.1 * a0313) as Scalar + (r0.3 * a0113) as Scalar) as Scalar
        let m32: Scalar = det * -((r0.0 * a1312) as Scalar - (r0.1 * a0312) as Scalar + (r0.3 * a0112) as Scalar) as Scalar
        let m03: Scalar = det * -((r1.0 * a1223) as Scalar - (r1.1 * a0223) as Scalar + (r1.2 * a0123) as Scalar) as Scalar
        let m13: Scalar = det *  ((r0.0 * a1223) as Scalar - (r0.1 * a0223) as Scalar + (r0.2 * a0123) as Scalar) as Scalar
        let m23: Scalar = det * -((r0.0 * a1213) as Scalar - (r0.1 * a0213) as Scalar + (r0.2 * a0113) as Scalar) as Scalar
        let m33: Scalar = det *  ((r0.0 * a1212) as Scalar - (r0.1 * a0212) as Scalar + (r0.2 * a0112) as Scalar) as Scalar

        return Self(rows: (
            (m00, m10, m20, m30) as Row,
            (m01, m11, m21, m31) as Row,
            (m02, m12, m22, m32) as Row,
            (m03, m13, m23, m33) as Row
        ))
    }
    
    /// Creates a matrix that when applied to a vector, scales each coordinate
    /// by the given amount.
    @_transparent
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
    @_transparent
    public static func makeScale<Vector: Vector3Type>(_ vec: Vector) -> Self where Vector.Scalar == Scalar {
        makeScale(x: vec.x, y: vec.y, z: vec.z)
    }
    
    /// Creates an X rotation matrix that when applied to a vector, rotates it
    /// around the X axis by a specified radian amount.
    @_transparent
    public static func makeXRotation(_ angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(rows: (
            (1,  0, 0, 0),
            (0,  c, s, 0),
            (0, -s, c, 0),
            (0,  0, 0, 1)
        ))
    }
    
    /// Creates an Y rotation matrix that when applied to a vector, rotates it
    /// around the Y axis by a specified radian amount.
    @_transparent
    public static func makeYRotation(_ angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(rows: (
            (c, 0, -s, 0),
            (0, 1,  0, 0),
            (s, 0,  c, 0),
            (0, 0,  0, 1)
        ))
    }
    
    /// Creates a Z rotation matrix that when applied to a vector, rotates it
    /// around the Z axis by a specified radian amount.
    @_transparent
    public static func makeZRotation(_ angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(rows: (
            ( c, s, 0, 0),
            (-s, c, 0, 0),
            ( 0, 0, 1, 0),
            ( 0, 0, 0, 1)
        ))
    }
    
    /// Creates a translation matrix that when applied to a vector, moves it
    /// according to the specified amounts.
    @_transparent
    public static func makeTranslation(x: Scalar, y: Scalar, z: Scalar) -> Self {
        Self(rows: (
            (1, 0, 0, x),
            (0, 1, 0, y),
            (0, 0, 1, z),
            (0, 0, 0, 1)
        ))
    }
    
    /// Creates a translation matrix that when applied to a vector, moves it
    /// according to the specified amounts.
    @_transparent
    public static func makeTranslation<Vector: Vector3Type>(_ vec: Vector) -> Self where Vector.Scalar == Scalar {
        makeTranslation(x: vec.x, y: vec.y, z: vec.z)
    }
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    public static func + (lhs: Self, rhs: Self) -> Self {
        let r0 = lhs.r0Vec + rhs.r0Vec
        let r1 = lhs.r1Vec + rhs.r1Vec
        let r2 = lhs.r2Vec + rhs.r2Vec
        let r3 = lhs.r3Vec + rhs.r3Vec
        
        return Self(rows: (r0, r1, r2, r3))
    }
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    public static func - (lhs: Self, rhs: Self) -> Self {
        let r0 = lhs.r0Vec - rhs.r0Vec
        let r1 = lhs.r1Vec - rhs.r1Vec
        let r2 = lhs.r2Vec - rhs.r2Vec
        let r3 = lhs.r3Vec - rhs.r3Vec
        
        return Self(rows: (r0, r1, r2, r3))
    }
    
    /// Negates (i.e. flips) the signs of all the values of this matrix.
    public static prefix func - (value: Self) -> Self {
        let r0 = -value.r0Vec
        let r1 = -value.r1Vec
        let r2 = -value.r2Vec
        let r3 = -value.r3Vec
        
        return Self(rows: (r0, r1, r2, r3))
    }
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        let r0 = lhs.r0Vec * rhs
        let r1 = lhs.r1Vec * rhs
        let r2 = lhs.r2Vec * rhs
        let r3 = lhs.r3Vec * rhs
        
        return Self(rows: (r0, r1, r2, r3))
    }
    
    /// Performs a scalar division between the elements of `lhs` and `rhs` and
    /// returns the result.
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        let r0 = lhs.r0Vec / rhs
        let r1 = lhs.r1Vec / rhs
        let r2 = lhs.r2Vec / rhs
        let r3 = lhs.r3Vec / rhs
        
        return Self(rows: (r0, r1, r2, r3))
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
        
        return Self(rows: (
            (r00, r01, r02, r03),
            (r10, r11, r12, r13),
            (r20, r21, r22, r23),
            (r30, r31, r32, r33)
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

/// Performs an equality check over a tuple of ``Matrix4x4`` values.
@_transparent
public func == <T>(_ lhs: Matrix4x4<T>.M, _ rhs: Matrix4x4<T>.M) -> Bool {
    lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3
}
