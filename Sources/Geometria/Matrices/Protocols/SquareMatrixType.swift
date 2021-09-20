import RealModule
import simd

/// Protocol for matrices where the number of rows and columns are the same.
public protocol SquareMatrixType: MatrixType {
    /// Returns the [determinant] of this square matrix.
    ///
    /// [determinant]: https://en.wikipedia.org/wiki/Determinant
    func determinant() -> Scalar
    
    /// Returns a new matrix that is a [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    func transposed() -> Self
    
    /// Returns the [inverse of this matrix](https://en.wikipedia.org/wiki/Invertible_matrix).
    ///
    /// If this matrix has no inversion, `nil` is returned, instead.
    func inverted() -> Self?
}
