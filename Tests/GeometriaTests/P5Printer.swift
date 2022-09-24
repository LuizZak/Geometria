import RealModule

@testable import Geometria

class P5Printer {
    private var _lastStrokeColorCall: String? = ""
    private var _lastStrokeWeightCall: String? = ""
    private var _lastFillColorCall: String? = ""
    
    private let identDepth: Int = 2
    private var currentIndent: Int = 0
    private var draws: [String] = []
    var cameraLookAt: Vector3D = .zero
    var shouldPrintDrawNormal: Bool = false
    var shouldPrintDrawTangent: Bool = false
    var is3D: Bool = false
    
    var buffer: String = ""
    
    var size: Vector2i
    var scale: Double
    var renderScale: Double
    
    var shouldStartDebugMode: Bool = false
    var drawOrigin: Bool = true
    var drawGrid: Bool = false

    /// Controls the style and color on the output of the sketch.
    var styling: Styles = Styles()
    
    init(size: Vector2i = .init(x: 800, y: 600), scale: Double = 2.0, renderScale: Double = 1.0) {
        self.size = size
        self.scale = scale
        self.renderScale = renderScale
    }
    
    // MARK: - Geometry

    private func _vertexRadius<Scalar: Numeric>() -> Scalar {
        return 2
    }
    
    func add<Vector: Vector2Type>(_ point: Vector, style: Style? = nil) where Vector.Scalar: Numeric & CustomStringConvertible {
        add(Circle2(center: point, radius: _vertexRadius()), style: style)
    }
    
    func add<Vector: Vector3Type>(_ point: Vector, style: Style? = nil) where Vector.Scalar: Numeric & CustomStringConvertible {
        add(Sphere3(center: point, radius: _vertexRadius()), style: style)
    }
    
    func add<V: Vector2Type>(_ ellipse: Ellipsoid<V>, style: Style? = nil) where V.Scalar: CustomStringConvertible {
        addStyleSet(style ?? styling.geometry)
        addDrawLine("ellipse(\(vec2String(ellipse.center)), \(vec2String(ellipse.radius)))")
        addDrawLine("")
    }
    
    func add<V: Vector3FloatingPoint>(_ ellipse3: Ellipsoid<V>, style: Style? = nil) where V.Scalar: CustomStringConvertible {
        is3D = true
        addNoStroke()
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(ellipse3.center)))")
        addDrawLine("scale(\(vec3String(ellipse3.radius)))")
        addDrawLine("sphere(1)")
        addDrawLine("pop()")
        addDrawLine("")
    }
    
    func add<Line: Line2Type>(_ line: Line, style: Style? = nil) where Line.Vector.Scalar: CustomStringConvertible {
        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec2String(line.a)), \(vec2String(line.b)))")
        addDrawLine("")
    }
    
    func add<Vector: Vector3Type>(_ ray: DirectionalRay3<Vector>, style: Style? = nil) where Vector.Scalar: FloatingPoint & CustomStringConvertible {
        is3D = true

        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec3String(ray.start)), \(vec3String(ray.projectedMagnitude(500))))")
        addDrawLine("")
    }
    
    func add<Line: Line3Type>(_ line: Line, style: Style? = nil) where Line.Vector.Scalar: Numeric & CustomStringConvertible {
        is3D = true
        
        addStyleSet(style ?? styling.line)
        addDrawLine("line(\(vec3String(line.a)), \(vec3String(line.b)))")
        addDrawLine("")
    }
    
    func add<V: Vector2Type>(_ result: ConvexLineIntersection<V>, style: Style? = nil) where V.Scalar: CustomStringConvertible {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pn)
        case let .enterExit(p1, p2):
            add(p1)
            add(p2)
        }
    }
    
    func add<V: Vector3Type>(_ result: ConvexLineIntersection<V>, style: Style? = nil) where V.Scalar == Double {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pn)
        case let .enterExit(p1, p2):
            add(p1)
            add(p2)
        }
    }
    
    func add<V: Vector2Type>(_ pointNormal: PointNormal<V>, style: Style? = nil) where V.Scalar: CustomStringConvertible {
        shouldPrintDrawNormal = true
        shouldPrintDrawTangent = true
        
        addStrokeWeightSet("1 / sceneScale")

        addStyleSet(style ?? styling.normalLine)
        addDrawLine("drawNormal(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")

        addStyleSet(style ?? styling.tangentLine)
        addDrawLine("drawTangent(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")

        addDrawLine("")
    }
    
    func add<V: Vector3Type>(_ pointNormal: PointNormal<V>, style: Style? = nil) where V.Scalar == Double {
        shouldPrintDrawNormal = true
        
        add(Sphere3<V>(center: pointNormal.point, radius: 0.5))
        
        addStyleSet(style ?? styling.normalLine)
        addDrawLine("drawNormal(\(vec3String(pointNormal.point)), \(vec3String(pointNormal.normal)))")
    }
    
    func add<V: Vector2Type>(_ circle: Circle2<V>, style: Style? = nil) where V.Scalar: Numeric & CustomStringConvertible {
        addStyleSet(style ?? styling.geometry)
        addDrawLine("circle(\(vec2String(circle.center)), \(circle.radius))")
    }
    
    func add<V: Vector2Additive & VectorDivisible>(_ aabb: AABB2<V>, style: Style? = nil) where V.Scalar: CustomStringConvertible {
        addStyleSet(style ?? styling.geometry)
        addDrawLine("rect(\(vec2String(aabb.minimum)), \(vec2String(aabb.maximum)))")
    }
    
    func add<V: Vector3Type>(_ sphere: Sphere3<V>, style: Style? = nil) where V.Scalar: Numeric & CustomStringConvertible {
        is3D = true
        
        addDrawLine("drawSphere(\(vec3String(sphere.center)), \(sphere.radius))")
    }
    
    func add<V: Vector3Additive & VectorDivisible>(_ aabb: AABB3<V>, style: Style? = nil) where V.Scalar: Numeric & CustomStringConvertible {
        is3D = true
        
        addStyleSet(style ?? styling.geometry)
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(aabb.minimum + aabb.size / 2)))")
        addDrawLine("box(\(vec3String(aabb.size)))")
        addDrawLine("pop()")
    }
    
    func add<R: RectangleType>(_ rectangle: R, style: Style? = nil) where R.Vector: Vector2Additive & VectorDivisible, R.Vector.Scalar: Numeric & CustomStringConvertible {
        is3D = true
        
        addStyleSet(style ?? styling.geometry)
        addDrawLine("push()")
        addDrawLine("translate(\(vec2String(rectangle.location + rectangle.size / 2)))")
        addDrawLine("box(\(vec2String(rectangle.size)))")
        addDrawLine("pop()")
    }
    
    func add<R: RectangleType>(_ rectangle: R, style: Style? = nil) where R.Vector: Vector3Additive & VectorDivisible, R.Vector.Scalar: Numeric & CustomStringConvertible {
        is3D = true
        
        addStyleSet(style ?? styling.geometry)
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(rectangle.location + rectangle.size / 2)))")
        addDrawLine("box(\(vec3String(rectangle.size)))")
        addDrawLine("pop()")
    }
    
    func add<V: Vector3Type>(_ torus: Torus3<V>, style: Style? = nil) where V.Scalar: Real & CustomStringConvertible {
        is3D = true
        
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
    
    func add<V: Vector3FloatingPoint>(_ cylinder: Cylinder3<V>, style: Style? = nil) where V.Scalar: Real & CustomStringConvertible {
        is3D = true

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
    
    func add<V: Vector3FloatingPoint>(_ capsule: Capsule3<V>, style: Style? = nil) where V.Scalar: Real & CustomStringConvertible {
        is3D = true

        add(Cylinder3(start: capsule.start, end: capsule.end, radius: capsule.radius), style: style)
        add(capsule.startAsSphere, style: style)
        add(capsule.endAsSphere, style: style)
    }
    
    // MARK: - Printing
    
    func printAll() {
        defer { printBuffer() }
        
        prepareCustomPreFile()
        
        printLine("var sceneScale = \(scale)")
        printLine("var renderScale = \(renderScale)")
        if is3D {
            printLine("var isSpaceBarPressed = false")
        }
        
        printCustomHeader()
        
        printLine("")
        printSetup()
        printLine("")
        printDraw()
        
        if is3D {
            printLine("")
            printKeyPressed()
        }
        
        if drawGrid {
            printLine("")
            printDrawGrid2D()
        }
        
        if drawOrigin && is3D {
            printLine("")
            printDrawOrigin3D()
        }
        
        if shouldPrintDrawNormal {
            printLine("")
            printDrawNormal2D()
        }
        
        if shouldPrintDrawNormal && is3D {
            printLine("")
            printDrawNormal3D()
        }
        
        if shouldPrintDrawTangent {
            printLine("")
            printDrawTangent2D()
        }
        
        if is3D {
            printLine("")
            printDrawSphere()
        }
    }
    
    // MARK: Expression Printing
    
    func boilerplate3DSpaceBar<T: FloatingPoint>(lineWeight: T) -> [String] {
        return [
            "if (isSpaceBarPressed) {",
            indentString(depth: 1) + "noFill()",
            indentString(depth: 1) + "noLights()",
            indentString(depth: 1) + "stroke(0, 0, 0, 20)",
            indentString(depth: 1) + "strokeWeight(\(1 / lineWeight) / sceneScale)",
            "} else {",
            indentString(depth: 1) + "noStroke()",
            indentString(depth: 1) + "fill(255, 255, 255, 255)",
            indentString(depth: 1) + "lights()",
            "}"
        ]
    }
    
    func addDrawLine(_ line: String) {
        draws.append(line)
    }
    
    func addNoStroke() {
        if _lastStrokeColorCall == nil { return }
        _lastStrokeColorCall = nil
        addDrawLine("noStroke()")
    }
    
    func addNoFill() {
        if _lastFillColorCall == nil { return }
        _lastFillColorCall = nil
        addDrawLine("noFill()")
    }
    
    func addStrokeColorSet(_ color: Color?) {
        let line = _strokeColor(color)

        if _lastStrokeColorCall == line { return }
        
        _lastStrokeColorCall = line
        addDrawLine(line)
    }
    
    func addStrokeWeightSet(_ value: String) {
        let line = "strokeWeight(\(value))"

        if _lastStrokeWeightCall == line { return }
        
        _lastStrokeWeightCall = line
        addDrawLine(line)
    }
    
    func addFillColorSet(_ color: Color?) {
        let line = _fillColor(color)

        if _lastFillColorCall == line { return }
        
        _lastFillColorCall = line
        addDrawLine(line)
    }

    func addStyleSet(_ style: Style?) {
        guard let style = style else { return }

        addStrokeColorSet(style.strokeColor)
        addFillColorSet(style.fillColor)
        addStrokeWeightSet(style.strokeWeight.description)
    }
    
    // MARK: Methods for subclasses
    
    func prepareCustomPreFile() {
        
    }
    
    func printCustomHeader() {
        
    }
    
    func printCustomPostSetup() {
        
    }
    
    func printCustomPreDraw() {
        
    }
    
    func printCustomPostDraw() {
        
    }
    
    // MARK: Function Printing
    
    func printSetup() {
        indentedBlock("function setup() {") {
            if is3D {
                printLine("createCanvas(\(vec2String(size)), WEBGL)")
                printLine("perspective(PI / 3, 1, 0.3, 8000) // Corrects default zNear plane being too far for unit measurements")
                
                if cameraLookAt != .zero {
                    printLine("camera(\(vec3String_pCoordinates(cameraLookAt)))")
                }
            } else {
                printLine("createCanvas(\(vec2String(size)))")
            }
            
            printLine("ellipseMode(RADIUS)")
            printLine("rectMode(CORNERS)")

            if shouldStartDebugMode && is3D {
                printLine("debugMode(GRID)")
            }
            
            printCustomPostSetup()
        }
    }
    
    func printDraw() {
        indentedBlock("function draw() {") {
            printCustomPreDraw()
            
            printLine("background(240)")
            printLine("")
            if !is3D {
                printLine("translate(width / 2, height / 2)")
            } else {
                printLine("orbitControl(3, 3, 0.3)")
                printLine("scale(sceneScale)")
                printLine("// Correct Y to grow away from the origin, and Z to grow up")
                printLine("rotateX(PI / 2)")
                printLine("scale(1, -1, 1)")
            }
            printLine("")
            printLine("strokeWeight(3 / sceneScale)")

            if drawGrid {
                printLine("drawGrid()")
            }
            if drawOrigin && is3D {
                printLine("drawOrigin()")
            }

            if is3D {
                boilerplate3DSpaceBar(lineWeight: 1.0).forEach(printLine)
            }

            printLine("scale(renderScale)")
            
            printLine("")
            
            for draw in draws {
                printLine(draw)
            }

            // Reset draw state
            printLine(_strokeColor(.black))
            printLine(_fillColor(nil))
            printLine(_strokeWeight(1))
            
            printCustomPostDraw()
        }
    }
    
    func printKeyPressed() {
        indentedBlock("function keyPressed() {") {
            indentedBlock("if (keyCode === 32) {") {
                printLine("isSpaceBarPressed = !isSpaceBarPressed")
            }
        }
    }
    
    func printDrawGrid2D() {
        indentedBlock("function drawGrid() {") {
            printLine("stroke(0, 0, 0, 30)")
            printLine("line(0, -20, 0, 20)")
            printLine("line(-20, 0, 20, 0)")
            indentedBlock("for (var x = -10; x < 10; x++) {") {
                printLine("stroke(0, 0, 0, 20)")
                printLine("line(x, -20, x, 20)")
            }
            indentedBlock("for (var y = -10; y < 10; y++) {") {
                printLine("stroke(0, 0, 0, 20)")
                printLine("line(-20, y, 20, y)")
            }
        }
    }
    
    func printDrawOrigin3D() {
        indentedBlock("function drawOrigin() {") {
            let length: Double = 100.0
            
            let vx = Vector3D.unitX * length
            let vy = Vector3D.unitY * length
            let vz = Vector3D.unitZ * length
            
            printLine("// X axis")
            printLine("stroke(255, 0, 0, 50)")
            printLine("line(\(vec3String(Vector3D.zero)), \(vec3String(vx)))")
            printLine("// Y axis")
            printLine("stroke(0, 255, 0, 50)")
            printLine("line(\(vec3String(Vector3D.zero)), \(vec3String(vy)))")
            printLine("// Z axis")
            printLine("stroke(0, 0, 255, 50)")
            printLine("line(\(vec3String(Vector3D.zero)), \(vec3String(vz)))")
        }
    }
    
    func printDrawNormal2D() {
        indentedBlock("function drawNormal(x, y, nx, ny) {") {
            printLine("const x2 = x + nx")
            printLine("const y2 = y + ny")
            printLine("")
            printLine("line(x, y, x2, y2)")
        }
    }
    
    func printDrawNormal3D() {
        indentedBlock("function drawNormal(x, y, z, nx, ny, nz) {") {
            printLine("const s = 10.0")
            printLine("")
            printLine("const x2 = x + nx * s")
            printLine("const y2 = y + ny * s")
            printLine("const z2 = z + nz * s")
            printLine("")
            printLine("strokeWeight(5 / sceneScale)")
            printLine("stroke(255, 0, 0, 200)")
            printLine("line(x, y, z, x2, y2, z2)")
        }
    }
    
    func printDrawTangent2D() {
        indentedBlock("function drawTangent(x, y, nx, ny) {") {
            printLine("const s = 5.0")
            printLine("")
            printLine("const x1 = x - ny * s")
            printLine("const y1 = y + nx * s")
            printLine("")
            printLine("const x2 = x + ny * s")
            printLine("const y2 = y - nx * s")
            printLine("")
            printLine("line(x1, y1, x2, y2)")
        }
    }
    
    func printDrawSphere() {
        indentedBlock("function drawSphere(x, y, z, radius) {") {
            printLine("push()")
            printLine("translate(x, y, z)")
            printLine("sphere(radius)")
            printLine("pop()")
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

    func applyMatrix3DString<Scalar>(_ matrix: RotationMatrix3<Scalar>) -> [String] where Scalar: CustomStringConvertible {
        return [
            "applyMatrix(\(matrix[0, 0]), \(matrix[1, 0]), \(matrix[2, 0]), 0,",
            "            \(matrix[0, 1]), \(matrix[1, 1]), \(matrix[2, 1]), 0,",
            "            \(matrix[0, 2]), \(matrix[1, 2]), \(matrix[2, 2]), 0,",
            "            0.0, 0.0, 0.0, 1.0)"
        ]
    }

    func _styleLines(_ style: Style?) -> [String] {
        guard let style = style else {
            return []
        }

        var lines: [String] = []
        lines.append(_strokeWeight(style.strokeWeight))
        lines.append(_strokeColor(style.strokeColor))
        lines.append(_fillColor(style.fillColor))

        return lines
    }

    func _strokeColor(_ color: Color?) -> String {
        if let color = color {
            return "stroke(\(_colorParams(color)))"
        } else {
            return "noStroke()"
        }
    }

    func _fillColor(_ color: Color?) -> String {
        if let color = color {
            return "fill(\(_colorParams(color)))"
        } else {
            return "noFill()"
        }
    }

    func _strokeWeight(_ weight: Double) -> String {
        return "strokeWeight(\(weight) / sceneScale)"
    }

    func _colorParams(_ color: Color) -> String {
        var c = ""
        if color.red == color.green && color.green == color.blue {
            c = "\(color.red)"
        } else {
            c = _commaSeparated(color.red, color.green, color.blue)
        }

        if color.alpha == 255 {
            return c
        } else {
            return _commaSeparated(c, color.alpha)
        }
    }

    func _commaSeparated(_ values: Any...) -> String {
        values.map { "\($0)" }.joined(separator: ", ")
    }
    
    func indentString(depth: Int) -> String {
        String(repeating: " ", count: depth)
    }

    // MARK: - Printing methods
    
    func printLine(_ line: String) {
        print("\(indentString())\(line)", to: &buffer)
    }
    
    func printLines(_ lines: [String]) {
        lines.forEach(printLine)
    }
    
    private func printBuffer() {
        print(buffer)
        buffer = ""
    }

    func indentString() -> String {
        indentString(depth: identDepth * currentIndent)
    }
    
    func indentedBlock(_ start: String, _ block: () -> Void) {
        printLine(start)
        indented {
            block()
        }
        printLine("}")
    }
    
    func indented(_ block: () -> Void) {
        indent()
        block()
        deindent()
    }
    
    func indent() {
        currentIndent += 1
    }
    
    func deindent() {
        currentIndent -= 1
    }

    /// Style for a draw operation
    struct Style {
        static let `default` = Self(
            strokeColor: .black,
            fillColor: nil,
            strokeWeight: 1.0
        )

        var strokeColor: Color? = .black
        var fillColor: Color?
        var strokeWeight: Double = 1.0
    }

    /// RGBA color with components between 0-255.
    struct Color {
        var alpha: Int
        var red: Int
        var green: Int
        var blue: Int

        var translucent: Self {
            var copy = self
            copy.alpha = 100
            return copy
        }

        var opaque: Self {
            var copy = self
            copy.alpha = 255
            return copy
        }

        internal init(alpha: Int = 255, red: Int, green: Int, blue: Int) {
            self.alpha = alpha
            self.red = red
            self.green = green
            self.blue = blue
        }
    }
}

extension P5Printer {
    struct Styles {
        var line: Style = Style(strokeColor: .black, strokeWeight: 2.0)
        var normalLine: Style = Style(strokeColor: .red.translucent, strokeWeight: 2.0)
        var tangentLine: Style = Style(strokeColor: .purple.translucent, strokeWeight: 2.0)
        var geometry: Style = Style(strokeColor: .black)
    }
}

extension P5Printer {
    static func withPrinter(_ block: (P5Printer) -> Void) {
        let printer = P5Printer(size: .init(x: 500, y: 500), scale: 2.0)
        
        block(printer)
        
        printer.printAll()
    }
}

extension P5Printer.Color {
    static let black = Self(red: 0, green: 0, blue: 0)
    static let grey = Self(red: 127, green: 127, blue: 127)
    static let white = Self(red: 255, green: 255, blue: 255)
    
    // Primary colors
    static let red = Self(red: 255, green: 0, blue: 0)
    static let green = Self(red: 0, green: 255, blue: 0)
    static let blue = Self(red: 0, green: 0, blue: 255)

    // Secondary colors
    static let yellow = Self(red: 255, green: 255, blue: 0)
    static let cyan = Self(red: 0, green: 255, blue: 255)
    static let purple = Self(red: 255, green: 0, blue: 255)
}
