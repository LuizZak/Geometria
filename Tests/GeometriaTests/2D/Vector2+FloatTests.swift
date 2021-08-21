import XCTest
import Geometria

class Vector2_FloatTests: XCTestCase {
    private let accuracy: Float = 1.0e-6
    
    func testSimdMatrix_identity() {
        let matrix = Vector2F.simdMatrix()
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_translate() {
        let matrix = Vector2F.simdMatrix(translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_scale() {
        let matrix = Vector2F.simdMatrix(scale: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -20.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_rotate() {
        let matrix = Vector2F.simdMatrix(rotate: .pi)
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0, -1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_scalePrecedesRotation() {
        let matrix = Vector2F.simdMatrix(scale: Vector2F(x: 0.5, y: 0.75),
                                         rotate: .pi)
        
        assertEqual(matrix.columns.0, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_rotationPrecedesTranslation() {
        let matrix = Vector2F.simdMatrix(rotate: .pi,
                                         translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrix_scaleRotateTranslate() {
        let matrix = Vector2F.simdMatrix(scale: Vector2F(x: 0.5, y: 0.75),
                                         rotate: .pi,
                                         translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testSimdMatrixMultiply() {
        let matrix = Vector2F.simdMatrix(scale: Vector2F(x: 0.5, y: 0.75),
                                         rotate: .pi,
                                         translate: Vector2F(x: 10, y: -20))
        
        let vec = Vector2F(x: 5.0, y: -2.0)
        
        assertEqual(vec * matrix, Vector2F(x: 7.5, y: -18.5), accuracy: accuracy)
    }
}
