import XCTest
import Geometria

class Vector2_DoubleTests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    func testMatrix_identity() {
        let matrix = Vector2D.matrix()
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_translate() {
        let matrix = Vector2D.matrix(translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scale() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -20.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_rotate() {
        let matrix = Vector2D.matrix(rotate: .pi)
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0, -1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scalePrecedesRotation() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi)
        
        assertEqual(matrix.columns.0, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_rotationPrecedesTranslation() {
        let matrix = Vector2D.matrix(rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scaleRotateTranslate() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrixMultiply() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        let vec = Vector2D(x: 5.0, y: -2.0)
        
        assertEqual(vec * matrix, Vector2D(x: 7.5, y: -18.5), accuracy: accuracy)
    }
}
