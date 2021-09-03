import XCTest
import Geometria

class PerformanceTests: XCTestCase {
    // MARK: Line - Vector projection
    
    func xtestLineProject2D() {
        typealias Vector = Vector2D
        
        let line = Line<Vector>(x1: 0, y1: 0, x2: 10, y2: 10)
        let point = Vector(x: 0, y: 10)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.projectUnclamped(point + Double(i))
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
                _ = line.projectUnclamped(point + Double(i))
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
                _ = line.projectUnclamped(point + Double(i))
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
                _ = line.projectUnclamped(point + Double(i))
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
                _ = ray.projectUnclamped(point + Double(i))
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
                _ = ray.projectUnclamped(point + Double(i))
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
                _ = ray.projectUnclamped(point + Double(i))
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
                _ = ray.projectUnclamped(point + Double(i))
            }
        }
    }
}

// MARK: AABB - Line intersection

extension PerformanceTests {
    func xtestAABBLineIntersects2D() {
        typealias Vector = Vector2D
        
        var aabb = AABB<Vector>(left: 3, top: 5, right: 12, bottom: 15)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                aabb = aabb.offsetBy(x: 1, y: 1)
                _ = aabb.intersects(line: line)
            }
        }
    }
    
    func xtestAABBLineIntersects2D_simd() {
        typealias Vector = SIMD2<Double>
        
        var aabb = AABB<Vector>(left: 3, top: 5, right: 12, bottom: 15)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                aabb = aabb.offsetBy(x: 1, y: 1)
                _ = aabb.intersects(line: line)
            }
        }
    }
    
    func xtestAABBLineIntersection2D() {
        typealias Vector = Vector2D
        
        var aabb = AABB<Vector>(left: 3, top: 5, right: 12, bottom: 15)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                aabb = aabb.offsetBy(x: 1, y: 1)
                _ = aabb.intersection(with: line)
            }
        }
    }
    
    func xtestAABBLineIntersection2D_simd() {
        typealias Vector = SIMD2<Double>
        
        var aabb = AABB<Vector>(left: 3, top: 5, right: 12, bottom: 15)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                aabb = aabb.offsetBy(x: 1, y: 1)
                _ = aabb.intersection(with: line)
            }
        }
    }
}

// MARK: Sphere - Line intersection

extension PerformanceTests {
    func xtestSphereLineIntersects2D() {
        typealias Vector = Vector2D

        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)

        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersects(line: line)
            }
        }
    }
    
    func xtestSphereLineIntersects2D_simd() {
        typealias Vector = SIMD2<Double>
        
        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersects(line: line)
            }
        }
    }
    
    func xtestSphereLineIntersection2D() {
        typealias Vector = Vector2D
        
        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersection(with: line)
            }
        }
    }
    
    func xtestSphereLineIntersection2D_simd() {
        typealias Vector = SIMD2<Double>
        
        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = Line<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersection(with: line)
            }
        }
    }
    
    func xtestSphereDirectionalRayIntersection2D() {
        typealias Vector = Vector2D
        
        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = DirectionalRay<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersection(with: line)
            }
        }
    }
    
    func xtestSphereDirectionalRayIntersection2D_simd() {
        typealias Vector = SIMD2<Double>
        
        var sphere = Circle2<Vector>(center: .init(x: 3, y: 5), radius: 3)
        let line = DirectionalRay<Vector>(x1: 2, y1: 3, x2: 3, y2: 4)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                sphere.center += 1
                _ = sphere.intersection(with: line)
            }
        }
    }
}
