/// Protocol for [square matrices], or matrices with the same number of rows and
/// columns.
///
/// [square matrices]: https://en.wikipedia.org/wiki/Square_matrix
public protocol SquareMatrixType: TransposableMatrixType where Transpose == Self {
    /// Returns the [determinant] of this square matrix.
    ///
    /// [determinant]: https://en.wikipedia.org/wiki/Determinant
    func determinant() -> Scalar
    
    /// Returns the [inverse of this matrix](https://en.wikipedia.org/wiki/Invertible_matrix).
    ///
    /// If this matrix has no inversion, `nil` is returned, instead.
    func inverted() -> Self?

    /// Performs a [matrix multiplication] between `lhs` and `rhs` and returns
    /// the result.
    ///
    /// [matrix multiplication]: http://en.wikipedia.org/wiki/Matrix_multiplication
    static func * (lhs: Self, rhs: Self) -> Self
}
