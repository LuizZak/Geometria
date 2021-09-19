import RealModule

/// Protocol for Matrix types.
public protocol MatrixType: Equatable {
    /// The scalar value associated with each element of this matrix.
    associatedtype Scalar: FloatingPoint & ElementaryFunctions
    
    /// Gets the number of rows in this matrix.
    var rowCount: Int { get }
    
    /// Gets the number of columns in this matrix.
    var columnCount: Int { get }
    
    /// Gets or sets the scalar value on a given column/row in this matrix.
    subscript(column: Int, row: Int) -> Scalar { get set }
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    static func + (lhs: Self, rhs: Self) -> Self
    
    /// Performs a [matrix addition] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    static func += (lhs: inout Self, rhs: Self)
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and returns the
    /// result.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    static func - (lhs: Self, rhs: Self) -> Self
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    static func -= (lhs: inout Self, rhs: Self)
    
    /// Negates (i.e. flips) the signs of all the values of this matrix.
    static prefix func - (value: Self) -> Self
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    static func * (lhs: Self, rhs: Scalar) -> Self
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and stores
    /// the result back into `lhs`.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    static func *= (lhs: inout Self, rhs: Scalar)
}

public extension MatrixType {
    /// Performs a [matrix addition] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix addition]: https://en.wikipedia.org/wiki/Matrix_addition
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    /// Performs a [matrix subtraction] between `lhs` and `rhs` and stores the
    /// result back into `lhs`.
    ///
    /// [matrix subtraction]: https://en.wikipedia.org/wiki/Matrix_addition
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    /// Performs a [scalar multiplication] between `lhs` and `rhs` and stores
    /// the result back into `lhs`.
    ///
    /// [scalar multiplication]: https://en.wikipedia.org/wiki/Scalar_multiplication
    static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
}
