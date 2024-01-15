/// Protocol for matrices that support transposition.
///
/// [square matrices]: https://en.wikipedia.org/wiki/Square_matrix
public protocol TransposableMatrixType: MatrixType {
    /// The resulting type of a transposition of this matrix.
    associatedtype Transpose: MatrixType
    
    /// Returns a new matrix that is a [transposition] of this matrix.
    ///
    /// [transposition]: https://en.wikipedia.org/wiki/Transpose
    func transposed() -> Transpose
}
