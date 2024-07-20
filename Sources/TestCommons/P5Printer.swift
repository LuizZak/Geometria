import RealModule
import MiniP5Printer
import Geometria

public class P5Printer: BaseP5Printer {
    func add<Vector: Vector2Type>(_ point: Vector, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: Numeric & CustomStringConvertible {
        let circle = Circle2(center: point, radius: vertexRadius())

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("circle(\(vec2String(circle.center)), \(circle.radius) / renderScale)")
    }

    func add<Vector: Vector3Type>(_ point: Vector, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: Numeric & CustomStringConvertible {
        let sphere = Sphere3(center: point, radius: vertexRadius())

        is3D = true

        addFileAndLineComment(file: file, line: line)
        addDrawLine(sphere3String_customRadius(sphere, radius: "\(sphere.radius) / renderScale"))
    }

    func add<V: Vector2Type>(_ ellipse: Ellipsoid<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("ellipse(\(vec2String(ellipse.center)), \(vec2String(ellipse.radius)))")
        addDrawLine("")
    }

    func add<V: Vector3FloatingPoint>(_ ellipse3: Ellipsoid<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addNoStroke()
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(ellipse3.center)))")
        addDrawLine("scale(\(vec3String(ellipse3.radius)))")
        addDrawLine("sphere(1)")
        addDrawLine("pop()")
        addDrawLine("")
    }

    func add<Line: Line2Type>(_ lineGeom: Line, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Line.Vector.Scalar: CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec2String(lineGeom.a)), \(vec2String(lineGeom.b)))")
        addDrawLine("")
    }

    func add<V: Vector2Type>(_ polygon: LinePolygon<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        for lineGeom in polygon.lineSegments() {
            addDrawLine("line(\(vec2String(lineGeom.a)), \(vec2String(lineGeom.b)))")
        }
        addDrawLine("")
    }

    func add<Vector: Vector3Type>(_ ray: DirectionalRay3<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: FloatingPoint & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec3String(ray.start)), \(vec3String(ray.projectedMagnitude(500))))")
        addDrawLine("")
    }

    func add<Line: Line3Type>(_ lineGeom: Line, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Line.Vector.Scalar: Numeric & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec3String(lineGeom.a)), \(vec3String(lineGeom.b)))")
        addDrawLine("")
    }

    func add<V: Vector3Type>(_ polygon: LinePolygon<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        for lineGeom in polygon.lineSegments() {
            addDrawLine("line(\(vec3String(lineGeom.a)), \(vec3String(lineGeom.b)))")
        }
        addDrawLine("")
    }

    func add<V: Vector2Type>(_ result: ConvexLineIntersection<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pn, style: style, file: file, line: line)
        case let .enterExit(p1, p2):
            add(p1, style: style, file: file, line: line)
            add(p2, style: style, file: file, line: line)
        }
    }

    func add<V: Vector2Type>(_ result: ClosedShape2Intersection<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        switch result {
        case .contained, .contains, .noIntersection:
            break

        case .singlePoint(let pn):
            add(pn, style: style, file: file, line: line)

        case .pairs(let pairs):
            for pair in pairs {
                add(pair.enter, style: style, file: file, line: line)
                add(pair.exit, style: style, file: file, line: line)
            }
        }
    }

    func add<V: Vector3Type>(_ result: ConvexLineIntersection<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar == Double {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pn, style: style, file: file, line: line)
        case let .enterExit(p1, p2):
            add(p1, style: style, file: file, line: line)
            add(p2, style: style, file: file, line: line)
        }
    }

    func add<V: Vector2Type>(_ pointNormal: PointNormal<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        shouldPrintDrawNormal = true
        shouldPrintDrawTangent = true

        addFileAndLineComment(file: file, line: line)
        addStrokeWeightSet("1")

        addStyleSet(style ?? styling.normalLine)
        addDrawLine("drawNormal(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")

        addStyleSet(style ?? styling.tangentLine)
        addDrawLine("drawTangent(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")

        addDrawLine("")
    }

    func add<V: Vector3Type>(_ pointNormal: PointNormal<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        shouldPrintDrawNormal = true

        add(Sphere3<V>(center: pointNormal.point, radius: 1 / 2), file: file, line: line)

        addStyleSet(style ?? styling.normalLine)
        addDrawLine("drawNormal(\(vec3String(pointNormal.point)), \(vec3String(pointNormal.normal)))")
    }

    func add<V: Vector2Type>(_ circle: Circle2<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("circle(\(vec2String(circle.center)), \(circle.radius))")
    }

    func add<V: Vector2Type>(_ circleArc: CircleArc2<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("arc(\(vec2String(circleArc.center)), \(circleArc.radius), \(circleArc.radius), \(angle2String(circleArc.startAngle)), \(angle2String(circleArc.startAngle + circleArc.sweepAngle)))")
    }

    func add<V: Vector3Type>(_ sphere: Sphere3<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addDrawLine(sphere3String(sphere))
    }

    func add<V: Vector2Additive & VectorDivisible>(_ aabb: AABB2<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: CustomStringConvertible {
        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("rect(\(vec2String(aabb.minimum)), \(vec2String(aabb.maximum)))")
    }

    func add<V: Vector3Additive & VectorDivisible>(_ aabb: AABB3<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(aabb.minimum + aabb.size / 2)))")
        addDrawLine("box(\(vec3String(aabb.size)))")
        addDrawLine("pop()")
    }

    func add<R: RectangleType>(_ rectangle: R, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where R.Vector: Vector3Additive & VectorDivisible, R.Vector.Scalar: Numeric & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(rectangle.location + rectangle.size / 2)))")
        addDrawLine("box(\(vec3String(rectangle.size)))")
        addDrawLine("pop()")
    }

    func add<V: Vector3Type>(_ torus: Torus3<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Real & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        addStyleSet(style ?? styling.geometry)

        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(torus.center)))")

        // Create matrix that will rotate the torus from laying on the Y-axis
        // to laying in the direction of its axis
        let origin = V.unitY
        let target = torus.axis
        if origin != target && origin != -target {
            let axis = origin.cross(target)
            let angle = V.Scalar.acos(origin.dot(target))
            addDrawLine("rotate(\(-angle), \(vec3PVectorString(vec3ToP5Vec(axis))))")
        }

        addDrawLine("torus(\(torus.majorRadius), \(torus.minorRadius))")
        addDrawLine("pop()")
    }

    func add<V: Vector3FloatingPoint>(_ cylinder: Cylinder3<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Real & CustomStringConvertible {
        is3D = true

        addFileAndLineComment(file: file, line: line)
        let line = cylinder.asLineSegment

        addStyleSet(style ?? styling.geometry)

        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(line.center)))")

        // Create matrix that will rotate the cylinder from growing on the Y-axis
        // to growing in the direction of its line
        let origin = V.unitY
        let target = line.lineSlope
        if origin != target && origin != -target {
            let axis = origin.cross(target)
            let angle = V.Scalar.acos(origin.dot(target))
            addDrawLine("rotate(\(-angle), \(vec3PVectorString(vec3ToP5Vec(axis))))")
        }

        addDrawLine("cylinder(\(cylinder.radius), \(line.length))")
        addDrawLine("pop()")
    }

    func add<V: Vector3FloatingPoint>(_ capsule: Capsule3<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Real & CustomStringConvertible {
        is3D = true

        add(Cylinder3(start: capsule.start, end: capsule.end, radius: capsule.radius), style: style, file: file, line: line)
        add(capsule.startAsSphere, style: style, file: file, line: line)
        add(capsule.endAsSphere, style: style, file: file, line: line)
    }

    func add<V: Vector2Type>(_ pointCloud: PointCloud<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        for point in pointCloud.points {
            add(point, style: style, file: file, line: line)
        }
    }

    func add<V: Vector3Type>(_ pointCloud: PointCloud<V>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where V.Scalar: Numeric & CustomStringConvertible {
        for point in pointCloud.points {
            add(point, style: style, file: file, line: line)
        }
    }

    // MARK: Transformations

    func vec3ToP5Vec<Vector: Vector3Type>(_ vec: Vector) -> Vector where Vector.Scalar: SignedNumeric {
        return .init(x: vec.x, y: vec.z, z: -vec.y)
    }

    // MARK: String printing

    func vec3PVectorString<Vector: Vector3Type>(_ vec: Vector) -> String where Vector.Scalar: SignedNumeric & CustomStringConvertible {
        return "createVector(\(vec3String(vec)))"
    }

    func vec3String<Vector: Vector3Type>(_ vec: Vector) -> String where Vector.Scalar: CustomStringConvertible {
        return "\(vec.x), \(vec.y), \(vec.z)"
    }

    func vec3String_pCoordinates<Vector: Vector3Type>(_ vec: Vector) -> String where Vector.Scalar: SignedNumeric & CustomStringConvertible {
        // Flip Y-Z axis (in Processing positive Y axis is down and positive Z axis is towards the screen)
        return "\(vec.x), \(-vec.z), \(-vec.y)"
    }

    func vec2String<Vector: Vector2Type>(_ vec: Vector) -> String where Vector.Scalar: CustomStringConvertible {
        "\(vec.x), \(vec.y)"
    }

    func angle2String<Scalar>(_ angle: Angle<Scalar>) -> String where Scalar: CustomStringConvertible {
        angle.radians.description
    }

    func sphere3String<Vector: Vector3Type>(_ sphere: Sphere3<Vector>) -> String where Vector.Scalar: CustomStringConvertible {
        "drawSphere(\(vec3String(sphere.center)), \(sphere.radius))"
    }

    func sphere3String_customRadius<Vector: Vector3Type>(_ sphere: Sphere3<Vector>, radius: String) -> String where Vector.Scalar: CustomStringConvertible {
        "drawSphere(\(vec3String(sphere.center)), \(radius))"
    }
}
