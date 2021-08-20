import XCTest
import Geometria

class Vector2_FloatTests: XCTestCase {
    private let accuracy: Float = 1.0e-6
    
    func testNormalized() {
        let vec = Vector2F(x: -10, y: 20)
        
        assertEqual(vec.normalized(), Vector2F(x: -0.44721362, y: 0.89442724), accuracy: 1e-7)
    }
    
    func testDot() {
        let v1 = Vector2F(x: 10, y: 20)
        let v2 = Vector2F(x: 30, y: 40)
        
        XCTAssertEqual(v1.dot(v2), 1100.0)
    }
    
    func testDistanceTo() {
        let v1 = Vector2F(x: 10, y: 20)
        let v2 = Vector2F(x: 30, y: 40)
        
        XCTAssertEqual(v1.distance(to: v2), 28.284271247461902)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector2F(x: 10, y: 20)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testDistanceSquared() {
        let v1 = Vector2F(x: 10, y: 20)
        let v2 = Vector2F(x: 30, y: 40)
        
        XCTAssertEqual(v1.distanceSquared(to: v2), 800.0)
    }
    
    func testDistanceSquared_zeroDistance() {
        let vec = Vector2F(x: 10, y: 20)
        
        XCTAssertEqual(vec.distanceSquared(to: vec), 0.0)
    }
    
    func testCross() {
        let v1 = Vector2F(x: 10, y: 20)
        let v2 = Vector2F(x: 30, y: 40)
        
        XCTAssertEqual(v1.cross(v2), -200.0)
    }
    
    func testMatrix_identity() {
        let matrix = Vector2F.matrix()
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_translate() {
        let matrix = Vector2F.matrix(translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, 1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scale() {
        let matrix = Vector2F.matrix(scale: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -20.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_rotate() {
        let matrix = Vector2F.matrix(rotate: .pi)
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0, -1.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scalePrecedesRotation() {
        let matrix = Vector2F.matrix(scale: Vector2F(x: 0.5, y: 0.75),
                                     rotate: .pi)
        
        assertEqual(matrix.columns.0, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, 0.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_rotationPrecedesTranslation() {
        let matrix = Vector2F.matrix(rotate: .pi,
                                     translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -1.0, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrix_scaleRotateTranslate() {
        let matrix = Vector2F.matrix(scale: Vector2F(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2F(x: 10, y: -20))
        
        assertEqual(matrix.columns.0, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.columns.1, [0.0, -0.75, -20.0], accuracy: accuracy)
        assertEqual(matrix.columns.2, [0.0, 0.0, 1.0], accuracy: accuracy)
    }
    
    func testMatrixMultiply() {
        let matrix = Vector2F.matrix(scale: Vector2F(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2F(x: 10, y: -20))
        
        let vec = Vector2F(x: 5.0, y: -2.0)
        
        assertEqual(vec * matrix, Vector2F(x: 7.5, y: -18.5), accuracy: accuracy)
    }
}
