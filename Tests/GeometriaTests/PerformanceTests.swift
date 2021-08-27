import XCTest
import Geometria

class PerformanceTests: XCTestCase {
    func xtestLineProject2D() {
        typealias Vector = Vector2D
        
        let line = Line<Vector>(x1: 0, y1: 0, x2: 10, y2: 10)
        let point = Vector(x: 0, y: 10)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.project(point + Double(i))
            }
        }
    }
    
    func xtestLineProject3D() {
        typealias Vector = Vector3D
        
        let line = Line<Vector>(x1: 0, y1: 0, z1: 0, x2: 10, y2: 10, z2: 10)
        let point = Vector(x: 10, y: 10, z: 0)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.project(point + Double(i))
            }
        }
    }
    
    func xtestLineProject2D_simd() {
        typealias Vector = SIMD2<Double>
        
        let line = Line<Vector>(x1: 0, y1: 0, x2: 10, y2: 10)
        let point = Vector(x: 0, y: 10)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.project(point + Double(i))
            }
        }
    }
    
    func xtestLineProject3D_simd() {
        typealias Vector = SIMD3<Double>
        
        let line = Line<Vector>(x1: 0, y1: 0, z1: 0, x2: 10, y2: 10, z2: 10)
        let point = Vector(x: 10, y: 10, z: 0)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.project(point + Double(i))
            }
        }
    }
    
    func xtestDirectionalRayProject2D() {
        typealias Vector = Vector2D
        
        let ray = DirectionalRay<Vector>(x: 0, y: 0, dx: 10, dy: 10)
        let point = Vector(x: 0, y: 10)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = ray.project(point + Double(i))
            }
        }
    }
    
    func xtestDirectionalRayProject3D() {
        typealias Vector = Vector3D
        
        let ray = DirectionalRay<Vector>(x: 0, y: 0, z: 0, dx: 10, dy: 10, dz: 10)
        let point = Vector(x: 10, y: 10, z: 0)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = ray.project(point + Double(i))
            }
        }
    }
    
    func xtestDirectionalRayProject2D_simd() {
        typealias Vector = SIMD2<Double>
        
        let ray = DirectionalRay<Vector>(x: 0, y: 0, dx: 10, dy: 10)
        let point = Vector(x: 0, y: 10)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = ray.project(point + Double(i))
            }
        }
    }
    
    func xtestDirectionalRayProject3D_simd() {
        typealias Vector = SIMD3<Double>
        
        let ray = DirectionalRay<Vector>(x: 0, y: 0, z: 0, dx: 10, dy: 10, dz: 10)
        let point = Vector(x: 10, y: 10, z: 0)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = ray.project(point + Double(i))
            }
        }
    }
}
