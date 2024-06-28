import XCTest
import Geometria

@testable import GeometriaAlgorithms

class Ellipse2Tests: XCTestCase {
    func testApproximateClosestPoint_centerPoint() {
        let sut = makeSut(center: .zero, radius: .init(x: 10, y: 10))
        let point = Vector2D(x: 0, y: 0)

        let result = sut.approximateClosestPoint(to: point, tolerance: 0.0001, samples: 20, maxDepth: 4)

        assertEqual(result, .init(x: 9.510565162951535, y: 3.090169943749474), accuracy: 0.001)
    }

    func testApproximateClosestPoint_circleEquivalent() {
        let sut = makeSut(center: .zero, radius: .init(x: 10, y: 10))
        let circle = Circle2D(center: .zero, radius: 10)
        let point = Vector2D(x: 3, y: 4)
        let onCircle = circle.project(point)

        let result = sut.approximateClosestPoint(to: point, tolerance: 0.0001, samples: 20, maxDepth: 4)

        assertEqual(result, onCircle, accuracy: 0.001)
    }

    func testApproximateClosestPoint_nonCircleEquivalent() {
        let sut = makeSut(center: .init(x: 2, y: 3), radius: .init(x: 12, y: 7))
        let point = Vector2D(x: 5, y: 7)

        let result = sut.approximateClosestPoint(to: point, tolerance: 0.0001, samples: 20, maxDepth: 5)

        assertEqual(result, .init(x: 5.476651310470384, y: 9.699778130449972), accuracy: 0.001)
    }
}

// MARK: - Test internals

private func makeSut(center: Vector2D, radius: Vector2D) -> Ellipse2D {
    .init(center: center, radius: radius)
}
