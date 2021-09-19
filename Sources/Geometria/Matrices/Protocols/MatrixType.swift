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
}
