import XCTest
import Geometria

#if ENABLE_SIMD
#if canImport(simd)

import simd

#endif // #if canImport(simd)
#endif // #if ENABLE_SIMD

// cspell:disable

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
    
    #if ENABLE_SIMD
    #if canImport(simd)

    func xtestLineProject2D_simd() {
        typealias Vector = SIMD2<Double>
        
        let line = Line<Vector>(x1: 0.0, y1: 0.0, x2: 10.0, y2: 10.0)
        let point = Vector(x: 0.0, y: 10.0)
        
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
        
        let line = Line<Vector>(x1: 0.0, y1: 0.0, z1: 0.0, x2: 10.0, y2: 10.0, z2: 10.0)
        let point = Vector(x: 10.0, y: 10.0, z: 0.0)
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _ = line.projectUnclamped(point + Double(i))
            }
        }
    }

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD

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
    
    #if ENABLE_SIMD
    #if canImport(simd)

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

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
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

    #if ENABLE_SIMD
    #if canImport(simd)
    
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

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
    
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
    
    #if ENABLE_SIMD
    #if canImport(simd)

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

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
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
    
    #if ENABLE_SIMD
    #if canImport(simd)

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

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD

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

    #if ENABLE_SIMD
    #if canImport(simd)
    
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

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD

    func xtestSphereLineIntersection3D() {
        typealias Vector = Vector3D
        
        var sphere = Sphere3<Vector>(center: .init(x: 1, y: 2, z: 3), radius: 3)
        let line = Line<Vector>(
            x1: -5, y1: 2, z1: 3,
            x2:  5, y2: 2, z2: 3
        )
        
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

    #if ENABLE_SIMD
    #if canImport(simd)
    
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
    
    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
}

// MARK: Triangle.area

extension PerformanceTests {
    func xtestTriangleArea() {
        typealias Vector = Vector2D
        
        let triangle = Triangle<Vector>(a: .zero, b: .init(x: 131, y: 230), c: .init(x: 97, y: 10))
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                _=triangle.area
            }
        }
    }
}

// MARK: Triangle / line intersection

extension PerformanceTests {
    func xtestTriangleIntersectionWith() {
        typealias Vector = Vector3D
        
        let triangle = Triangle<Vector>(
            a: .init(x: 0, y: 1, z: 2),
            b: .init(x: 2, y: 130, z: 5),
            c: .init(x: 121, y: 5, z: 11)
        )
        
        var line = Line<Vector>(
            x1: -10,
            y1: 0,
            z1: 70,
            x2: 10,
            y2: 50,
            z2: -20
        )
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                line.a.x += 1
                _=triangle.intersection(with: line)
            }
        }
    }
    
    func xtestTriangleMollerTrumboreIntersect() {
        typealias Vector = Vector3D
        
        let triangle = Triangle<Vector>(
            a: .init(x: 0, y: 1, z: 2),
            b: .init(x: 2, y: 130, z: 5),
            c: .init(x: 121, y: 5, z: 11)
        )
        
        var line = Line<Vector>(
            x1: -10,
            y1: 0,
            z1: 70,
            x2: 10,
            y2: 50,
            z2: -20
        )
        
        measure {
            var i = 0
            while i < 100_000 {
                defer { i += 1 }
                line.a.x += 1
                _=triangle.mollerTrumboreIntersect(with: line)
            }
        }
    }
}
