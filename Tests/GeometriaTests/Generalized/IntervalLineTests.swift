import XCTest

@testable import Geometria

class IntervalLineTests: XCTestCase {
    typealias IntervalLine = IntervalLine2D
    typealias IntervalLine3 = IntervalLine3D
    
    func testCodable() throws {
        let sut = IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(IntervalLine.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)),
                       IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(IntervalLine(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)),
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)),
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)),
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)),
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue,
                       IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)).hashValue,
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)).hashValue,
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)).hashValue,
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)).hashValue,
                          IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
    }

    func testCategory() {
        let sut = IntervalLine(start: .zero, end: .one)

        XCTAssertEqual(sut.category, .lineSegment)
    }
    
    func testAsLine() {
        let sut = IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
}

// MARK: LineType Conformance

extension IntervalLineTests {
    func testA() {
        let sut = IntervalLine(start: .zero, end: .one)
        
        XCTAssertEqual(sut.a, .zero)
    }
    
    func testB() {
        let sut = IntervalLine(start: .zero, end: .one)
        
        XCTAssertEqual(sut.b, .one)
    }

    func testA_zeroMaximumMagnitude() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: -.infinity,
            maximumMagnitude: 0
        )
        
        XCTAssertEqual(sut.a, .init(x: -0.7071067811865475, y: -0.7071067811865475))
    }
    
    func testB_zeroMaximumMagnitude() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: -.infinity,
            maximumMagnitude: 0
        )
        
        XCTAssertEqual(sut.b, .zero)
    }

    func testAB_doNotMatchIfMaximumMagnitudeIsZero() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: -.infinity,
            maximumMagnitude: 0
        )
        
        XCTAssertNotEqual(sut.a, sut.b)
    }

    func testA_oneMinimumMagnitude() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: 1,
            maximumMagnitude: .infinity
        )
        
        XCTAssertEqual(sut.a, .init(x: 0.7071067811865475, y: 0.7071067811865475))
    }
    
    func testB_oneMinimumMagnitude() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: 1,
            maximumMagnitude: .infinity
        )
        
        XCTAssertEqual(sut.b, .init(x: 1.414213562373095, y: 1.414213562373095))
    }

    func testAB_doNotMatchIfMinimumMagnitudeIsZero() {
        let sut = IntervalLine(
            pointOnLine: .zero,
            direction: .one,
            minimumMagnitude: 1,
            maximumMagnitude: .infinity
        )
        
        XCTAssertNotEqual(sut.a, sut.b)
    }
}

// MARK: LineAdditive Conformance

extension IntervalLineTests {
    func testOffsetBy() {
        let sut = IntervalLine(x1: 1, y1: 2, x2: 3, y2: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(sut.lineSlope, result.lineSlope)
        XCTAssertEqual(result.a, .init(x: 8, y: 13))
        XCTAssertEqual(result.b, .init(x: 10, y: 16))
    }
}

// MARK: LineMultiplicative Conformance

extension IntervalLineTests {
    func testLengthSquared() {
        let sut = IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.lengthSquared, 13, accuracy: 1e-14)
    }
    
    func testWithPointsScaledBy_boundedLine() {
        let sut = IntervalLine(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(
            result.normalizedLineSlope,
            (sut.lineSlope * factor).normalized(),
            accuracy: 1e-16
        )
        XCTAssertEqual(result.a, .init(x: 7, y: 22))
        XCTAssertEqual(result.b, .init(x: 21, y: 55))
    }
    
    func testWithPointsScaledBy_boundedLine_negativeMinimumMagnitude() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 5)
        sut.minimumMagnitude = -5
        let factor = Vector2D(x: 1, y: 2)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(
            result.pointOnLine,
            .init(x: -0.9805806756909202, y: -9.805806756909202),
            accuracy: 1e-15
        )
        assertEqual(
            result.direction,
            (sut.direction * factor).normalized(),
            accuracy: 1e-15
        )
        assertEqual(
            result.a,
            .init(x: -0.9805806756909202, y: -9.805806756909202),
            accuracy: 1e-15
        )
        assertEqual(
            result.b,
            .init(x: 1, y: 10),
            accuracy: 1e-15
        )
    }
    
    func testWithPointsScaledBy_openStart() {
        var sut = IntervalLine(x1: 1, y1: 2, x2: 3, y2: 5)
        sut.minimumMagnitude = -.infinity
        let factor = Vector2D(x: 7, y: 11)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(
            result.pointOnLine,
            .init(x: 7, y: 22),
            accuracy: 1e-15
        )
        assertEqual(
            result.direction,
            (sut.direction * factor).normalized(),
            accuracy: 1e-15
        )
        assertEqual(
            result.a,
            .init(x: 7, y: 22),
            accuracy: 1e-15
        )
        assertEqual(
            result.b,
            .init(x: 21, y: 55),
            accuracy: 1e-15
        )
    }
    
    func testWithPointsScaledBy_openStart_verticalLine() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 0, y2: 5)
        sut.minimumMagnitude = -.infinity
        let factor = Vector2D(x: 1, y: 2)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(
            result.pointOnLine,
            .init(x: 0, y: 0),
            accuracy: 1e-15
        )
        assertEqual(
            result.direction,
            (sut.direction * factor).normalized(),
            accuracy: 1e-15
        )
        assertEqual(
            result.a,
            .init(x: 0, y: 0),
            accuracy: 1e-15
        )
        assertEqual(
            result.b,
            .init(x: 0, y: 10),
            accuracy: 1e-15
        )
    }
    
    func testWithPointsScaledBy_openStart_slantedVerticalLine() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 5)
        sut.minimumMagnitude = -.infinity
        let factor = Vector2D(x: 1, y: 2)
        
        let result = sut.withPointsScaledBy(factor)
        
        assertEqual(
            result.pointOnLine,
            .init(x: 0, y: 0),
            accuracy: 1e-15
        )
        assertEqual(
            result.direction,
            (sut.direction * factor).normalized(),
            accuracy: 1e-15
        )
        assertEqual(
            result.a,
            .init(x: 0, y: 0),
            accuracy: 1e-15
        )
        assertEqual(
            result.b,
            .init(x: 1, y: 10),
            accuracy: 1e-15
        )
    }
    
    func testWithPointsScaledByAroundCenter_boundedLine() {
        let sut = IntervalLine(x1: 1, y1: 2, x2: 3, y2: 5)
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(
            result.normalizedLineSlope,
            (sut.lineSlope * factor).normalized(),
            accuracy: 1e-16
        )
        assertEqual(
            result.a,
            .init(x: -23, y: 2.0),
            accuracy: 1e-14
        )
        assertEqual(
            result.b,
            .init(x: -9.0, y: 35.0),
            accuracy: 1e-14
        )
    }
    
    func testWithPointsScaledByAroundCenter_infiniteLine() {
        var sut = IntervalLine(x1: 1, y1: 2, x2: 3, y2: 5)
        sut.minimumMagnitude = -.infinity
        sut.maximumMagnitude = .infinity
        let factor = Vector2D(x: 7, y: 11)
        let center = Vector2D(x: 5, y: 2)
        
        let result = sut.withPointsScaledBy(factor, around: center)
        
        assertEqual(
            result.direction,
            (sut.direction * factor).normalized(),
            accuracy: 1e-16
        )
        assertEqual(
            result.a,
            .init(x: -23, y: 2.0),
            accuracy: 1e-14
        )
        assertEqual(
            result.b,
            .init(x: -22.60945015314383, y: 2.9205817818752564),
            accuracy: 1e-14
        )
    }
}

// MARK: LineFloatingPoint Conformance

extension IntervalLineTests {
    func testLength() {
        let sut = IntervalLine(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))

        XCTAssertEqual(sut.length, 3.605551275463989, accuracy: 1e-13)
    }

    func testContainsProjectedNormalizedMagnitude() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.infinity))
    }

    func testContainsProjectedNormalizedMagnitude_nonZeroMinimumMagnitude() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.minimumMagnitude = -10
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.infinity))
    }

    func testContainsProjectedNormalizedMagnitude_openStart() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.minimumMagnitude = -.infinity
        
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.infinity))
    }

    func testContainsProjectedNormalizedMagnitude_openEnd() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.maximumMagnitude = .infinity
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(.infinity))
    }

    func testContainsProjectedNormalizedMagnitude_openStartAndEnd() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.minimumMagnitude = -.infinity
        sut.maximumMagnitude = .infinity
        
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-.infinity))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(-0.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(0.5))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(1.1))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(2))
        XCTAssertTrue(sut.containsProjectedNormalizedMagnitude(.infinity))
    }
    
    func testContainsProjectedNormalizedMagnitude_returnsFalseForNaN() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertFalse(sut.containsProjectedNormalizedMagnitude(.nan))
    }
    
    func testClampProjectedNormalizedMagnitude() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), 1)
    }
    
    func testClampProjectedNormalizedMagnitude_openStart() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.minimumMagnitude = -.infinity
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), -.infinity)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), -1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), -0.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), 1)
    }
    
    func testClampProjectedNormalizedMagnitude_openEnd() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.maximumMagnitude = .infinity
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 2)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), .infinity)
    }
    
    func testClampProjectedNormalizedMagnitude_openStartAndEnd() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 0)
        sut.minimumMagnitude = .infinity
        sut.maximumMagnitude = .infinity
        
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-.infinity), -.infinity)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-1), -1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(-0.1), -0.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0), 0)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(0.5), 0.5)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1), 1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(1.1), 1.1)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(2), 2)
        XCTAssertEqual(sut.clampProjectedNormalizedMagnitude(.infinity), .infinity)
    }

    func testClampedAsIntervalLine_lineMode_2D() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 2)
        sut.minimumMagnitude = -.infinity
        sut.maximumMagnitude = .infinity

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -10,
            maximumNormalizedMagnitude: 20
        )

        assertEqual(
            result.a,
            Vector2D(x: -4.47213595499958, y: -8.94427190999916),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 8.94427190999916, y: 17.88854381999832),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 10.0, accuracy: 1e-13)
        XCTAssertEqual(sut.a.distance(to: result.b), 20.0, accuracy: 1e-13)
        XCTAssertEqual(result.length, 30.0, accuracy: 1e-13)
    }

    func testClampedAsIntervalLine_directionalRayMode_2D() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 2)
        sut.minimumMagnitude = 0
        sut.maximumMagnitude = .infinity

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -10,
            maximumNormalizedMagnitude: 20
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 8.94427190999916, y: 17.88854381999832),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), 20.0, accuracy: 1e-14)
        XCTAssertEqual(result.length, 20.0, accuracy: 1e-14)
    }

    func testClampedAsIntervalLine_directionalRayMode_2D_invalidClamp() {
        var sut = IntervalLine(x1: 0, y1: 0, x2: 1, y2: 2)
        sut.minimumMagnitude = 0
        sut.maximumMagnitude = .infinity

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -10,
            maximumNormalizedMagnitude: -5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), 0.0, accuracy: 1e-16)
        XCTAssertEqual(result.length, 0.0, accuracy: 1e-15)
    }

    func testClampedAsIntervalLine_lineSegmentMode_2D() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1,
            maximumNormalizedMagnitude: 0.5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 5.0, y: 10.0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), sut.length / 2.0, accuracy: 1e-14)
        XCTAssertEqual(result.length, sut.length / 2.0, accuracy: 1e-16)
    }

    func testClampedAsIntervalLine_lineSegmentMode_2D_wholeSegment() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1.0,
            maximumNormalizedMagnitude: 2.0
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-12
        )
        assertEqual(
            result.b,
            Vector2D(x: 10.0, y: 20.0),
            accuracy: 1e-12
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-16)
        XCTAssertEqual(sut.a.distance(to: result.b), sut.length, accuracy: 1e-14)
        XCTAssertEqual(result.length, sut.length, accuracy: 1e-16)
    }

    func testClampedAsIntervalLine_lineSegmentMode_2D_invalidClamp() {
        let sut = IntervalLine(x1: 0, y1: 0, x2: 10, y2: 20)

        let result = sut.clampedAsIntervalLine(
            minimumNormalizedMagnitude: -1.0,
            maximumNormalizedMagnitude: -0.5
        )

        assertEqual(
            result.a,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-50
        )
        assertEqual(
            result.b,
            Vector2D(x: 0, y: 0),
            accuracy: 1e-50
        )
        XCTAssertEqual(sut.a.distance(to: result.a), 0.0, accuracy: 1e-50)
        XCTAssertEqual(sut.a.distance(to: result.b), 0.0, accuracy: 1e-50)
        XCTAssertEqual(result.length, 0.0, accuracy: 1e-50)
    }
}
