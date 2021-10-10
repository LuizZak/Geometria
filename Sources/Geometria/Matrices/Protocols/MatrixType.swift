import RealModule

/// Protocol for Matrix types.
public protocol MatrixType: Equatable {
    /// The scalar value associated with each element of this matrix.
    associatedtype Scalar: Real & DivisibleArithmetic
    
    /// Gets the [identity matrix] for this matrix type.
    ///
    /// [identity matrix]: https://en.wikipedia.org/wiki/Identity_matrix
    static var identity: Self { get }
    
    /// Gets the number of rows in this matrix.
    var rowCount: Int { get }
    
    /// Gets the number of columns in this matrix.
    var columnCount: Int { get }
    
    /// Gets or sets the scalar value on a given column/row in this matrix.
    subscript(column: Int, row: Int) -> Scalar { get set }

    /// Initializes a matrix with a flat list of values that are read in
    /// [row-major order].
    ///
    /// The list should have at least `rowCount * columnCount` elements.
    ///
    /// [row major order]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    ///
    /// - precondition: `values.count >= rowCount * columnCount`
    init(rowMajorValues values: [Scalar])

    /// Initializes a matrix with a flat list of values that are read in
    /// [column-major order].
    ///
    /// The list should have at least `rowCount * columnCount` elements.
    ///
    /// [column major order]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    ///
    /// - precondition: `values.count >= rowCount * columnCount`
    init(columnMajorValues values: [Scalar])

    /// Returns a flat array of each scalar value from this matrix ordered as a
    /// [row major] list.
    ///
    /// [row major]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    func rowMajorValues() -> [Scalar]

    /// Returns a flat array of each scalar value from this matrix ordered as a
    /// [column major] list.
    ///
    /// [column major]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    func columnMajorValues() -> [Scalar]
    
    /// Negates (i.e. flips) the signs of all the values of this matrix.
    static prefix func - (value: Self) -> Self
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    static func + (lhs: Self, rhs: Self) -> Self
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    static func - (lhs: Self, rhs: Self) -> Self
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    static func += (lhs: inout Self, rhs: Self)
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    static func -= (lhs: inout Self, rhs: Self)
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    static func * (lhs: Self, rhs: Scalar) -> Self
    
    /// Performs a scalar division between the elements of `lhs` and `rhs` and
    /// returns the result.
    static func / (lhs: Self, rhs: Scalar) -> Self
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and stores
    /// the result back into `lhs`.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    static func *= (lhs: inout Self, rhs: Scalar)
    
    /// Performs a scalar division between the elements of `lhs` and `rhs` and
    /// stores the result back into `lhs`.
    static func /= (lhs: inout Self, rhs: Scalar)
}

public extension MatrixType {
    /// Initializes a matrix with a flat list of values that are read in
    /// [row-major order].
    ///
    /// The list should have at least `rowCount * columnCount` elements.
    ///
    /// [row major order]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    ///
    /// - precondition: `values.count >= rowCount * columnCount`
    init(rowMajorValues values: [Scalar]) {
        self = .identity
        
        var index = 0
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                self[column, row] = values[index]
                index += 1
            }
        }
    }

    /// Initializes a matrix with a flat list of values that are read in
    /// [column-major order].
    ///
    /// The list should have at least `rowCount * columnCount` elements.
    ///
    /// [column major order]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    ///
    /// - precondition: `values.count >= rowCount * columnCount`
    init(columnMajorValues values: [Scalar]) {
        self = .identity
        
        var index = 0
        for column in 0..<columnCount {
            for row in 0..<rowCount {
                self[column, row] = values[index]
                index += 1
            }
        }
    }

    /// Returns a flat array of each scalar value from this matrix ordered as a
    /// [row major] list.
    ///
    /// [row major]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    func rowMajorValues() -> [Scalar] {
        var values: [Scalar] = .init(repeating: 0, count: columnCount * rowCount)

        var index = 0
        for row in 0..<rowCount {
            for column in 0..<columnCount {
                values[index] = self[column, row]
                index += 1
            }
        }

        return values
    }

    /// Returns a flat array of each scalar value from this matrix ordered as a
    /// [column major] list.
    ///
    /// [column major]: https://en.wikipedia.org/wiki/Row-_and_column-major_order
    func columnMajorValues() -> [Scalar] {
        var values: [Scalar] = .init(repeating: 0, count: columnCount * rowCount)

        var index = 0
        for column in 0..<columnCount {
            for row in 0..<rowCount {
                values[index] = self[column, row]
                index += 1
            }
        }

        return values
    }
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    @_transparent
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    @_transparent
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and stores
    /// the result back into `lhs`.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    @_transparent
    static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
    
    /// Performs a scalar division between the elements of `lhs` and `rhs` and
    /// stores the result back into `lhs`.
    static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
}
