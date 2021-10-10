import Geometria

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
    
    var drawOrigin: Bool = true
    var drawGrid: Bool = false
    
    init(size: Vector2i = .init(x: 800, y: 600), scale: Double = 2.0) {
        self.size = size
        self.scale = scale
    }
    
    // MARK: - Geometry
    
    func add<Vector: Vector3Type>(_ point: Vector) where Vector.Scalar: SignedNumeric & CustomStringConvertible {
        add(Sphere3(center: point, radius: 1))
    }
    
    func add<V: Vector2Type>(_ ellipse: Ellipsoid<V>) where V.Scalar: CustomStringConvertible {
        addStrokeColorSet("0")
        addStrokeWeightSet("1 / sceneScale")
        addNoFill()
        addDrawLine("ellipse(\(vec2String(ellipse.center)), \(vec2String(ellipse.radius)))")
        addDrawLine("")
    }
    
    func add<V: Vector3FloatingPoint>(_ ellipse3: Ellipsoid<V>) where V.Scalar: CustomStringConvertible {
        is3D = true
        addNoStroke()
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(ellipse3.center)))")
        addDrawLine("scale(\(vec3String(ellipse3.radius)))")
        addDrawLine("sphere(1)")
        addDrawLine("pop()")
        addDrawLine("")
    }
    
    func add<Line: Line2Type>(_ line: Line) where Line.Vector.Scalar: CustomStringConvertible {
        addStrokeColorSet("0")
        addStrokeWeightSet("1 / sceneScale")
        addDrawLine("line(\(vec2String(line.a)), \(vec2String(line.b)))")
        addDrawLine("")
    }
    
    func add<Vector: Vector3Type>(_ ray: DirectionalRay3<Vector>) where Vector.Scalar: FloatingPoint & CustomStringConvertible {
        is3D = true
        
        addStrokeColorSet("255, 0, 0")
        addStrokeWeightSet("2 / sceneScale")
        addDrawLine("line(\(vec3String(ray.start)), \(vec3String(ray.projectedMagnitude(500))))")
        addDrawLine("")
    }
    
    func add<Line: Line3Type>(_ line: Line, color: String = "0") where Line.Vector.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        addStrokeColorSet(color)
        addStrokeWeightSet("2 / sceneScale")
        addDrawLine("line(\(vec3String(line.a)), \(vec3String(line.b)))")
        addDrawLine("")
    }
    
    func add<V: Vector2Type>(_ result: ConvexLineIntersection<V>) where V.Scalar: CustomStringConvertible {
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
    
    func add<V: Vector3Type>(_ result: ConvexLineIntersection<V>) where V.Scalar == Double {
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
    
    func add<V: Vector2Type>(_ pointNormal: PointNormal<V>) where V.Scalar: CustomStringConvertible {
        shouldPrintDrawNormal = true
        shouldPrintDrawTangent = true
        
        addStrokeWeightSet("1 / sceneScale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("drawNormal(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")
        addStrokeColorSet("255, 0, 255, 100")
        addDrawLine("drawTangent(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)))")
        addDrawLine("")
    }
    
    func add<V: Vector3Type>(_ pointNormal: PointNormal<V>) where V.Scalar == Double {
        shouldPrintDrawNormal = true
        
        add(Sphere3<V>(center: pointNormal.point, radius: 0.5))
        
        addStrokeWeightSet("1 / sceneScale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("drawNormal(\(vec3String(pointNormal.point)), \(vec3String(pointNormal.normal)))")
    }
    
    func add<V: Vector2Type>(_ circle: Circle2<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        addStrokeWeightSet("1 / sceneScale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("circle(\(vec2String(circle.center)), \(circle.radius))")
    }
    
    func add<V: Vector2Additive & VectorDivisible>(_ aabb: AABB2<V>) where V.Scalar: CustomStringConvertible {
        addStrokeWeightSet("1 / sceneScale")
        addStrokeColorSet("255, 0, 0, 100")
        addNoFill()
        addDrawLine("rect(\(vec2String(aabb.minimum)), \(vec2String(aabb.maximum)))")
    }
    
    func add<V: Vector3Type>(_ sphere: Sphere3<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        addDrawLine("drawSphere(\(vec3String(sphere.center)), \(sphere.radius))")
    }
    
    func add<V: Vector3Additive & VectorDivisible>(_ aabb: AABB3<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(aabb.minimum + aabb.size / 2)))")
        addDrawLine("box(\(vec3String(aabb.size)))")
        addDrawLine("pop()")
    }
    
    func add(_ torus: Torus3D) {
        is3D = true

        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(torus.center)))")
        
        // Create matrix that will rotate the torus from laying on the Z-axis
        // to laying in the direction of its axis
        let origin = Vector3D.unitZ
        let target = torus.axis
        let crossY = target.cross(origin)
        if crossY != .zero {
            let matrix = RotationMatrix3.make3DRotationBetween(origin, target)

            applyMatrix3DString(matrix).forEach(addDrawLine)
        }
        
        addDrawLine("torus(\(torus.majorRadius), \(torus.minorRadius))")
        addDrawLine("pop()")
    }
    
    func add(_ cylinder: Cylinder3D) {
        is3D = true

        let line = cylinder.asLineSegment

        addDrawLine("push()")
        addDrawLine("translate(\(vec3String(line.center)))")
        
        // Create matrix that will rotate the cylinder from growing on the Y-axis
        // to growing in the direction of its line
        let origin = Vector3D.unitY
        let target = line.lineSlope
        let crossY = target.cross(origin)
        if crossY != .zero {
            let matrix = RotationMatrix3.make3DRotationBetween(origin, target)

            applyMatrix3DString(matrix).forEach(addDrawLine)
        }
        
        addDrawLine("cylinder(\(cylinder.radius), \(line.length))")
        addDrawLine("pop()")
    }
    
    func add(_ capsule: Capsule3D) {
        is3D = true

        add(Cylinder3D(start: capsule.start, end: capsule.end, radius: capsule.radius))
        add(capsule.startAsSphere)
        add(capsule.endAsSphere)
    }
    
    // MARK: - Printing
    
    func printAll() {
        defer { printBuffer() }
        
        prepareCustomPreFile()
        
        printLine("var sceneScale = \(scale)")
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
    
    func addStrokeColorSet(_ value: String) {
        if _lastStrokeColorCall == value { return }
        
        _lastStrokeColorCall = value
        addDrawLine("stroke(\(value))")
    }
    
    func addStrokeWeightSet(_ value: String) {
        if _lastStrokeWeightCall == value { return }
        
        _lastStrokeWeightCall = value
        addDrawLine("strokeWeight(\(value))")
    }
    
    func addFillColorSet(_ value: String) {
        if _lastFillColorCall == value { return }
        
        _lastFillColorCall = value
        addDrawLine("fill(\(value))")
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

            printLine("")
            
            for draw in draws {
                printLine(draw)
            }
            
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
    
    // MARK: String printing
    
    func vec3PVectorString<V: Vector3Type>(_ vec: V) -> String where V.Scalar: SignedNumeric & CustomStringConvertible {
        return "createVector(\(vec3String(vec)))"
    }
    
    func vec3String<V: Vector3Type>(_ vec: V) -> String where V.Scalar: SignedNumeric & CustomStringConvertible {
        return "\(vec.x), \(vec.y), \(vec.z)"
    }
    
    func vec3String_pCoordinates<V: Vector3Type>(_ vec: V) -> String where V.Scalar: SignedNumeric & CustomStringConvertible {
        // Flip Y-Z axis (in Processing positive Y axis is down and positive Z axis is towards the screen)
        return "\(vec.x), \(-vec.z), \(-vec.y)"
    }
    
    func vec2String<V: Vector2Type>(_ vec: V) -> String where V.Scalar: CustomStringConvertible {
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
    
    func printLine(_ line: String) {
        print("\(indentString())\(line)", to: &buffer)
    }
    
    private func printBuffer() {
        print(buffer)
        buffer = ""
    }
    
    func indentString() -> String {
        indentString(depth: identDepth * currentIndent)
    }
    
    func indentString(depth: Int) -> String {
        String(repeating: " ", count: depth)
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
}

extension P5Printer {
    static func withPrinter(_ block: (P5Printer) -> Void) {
        let printer = P5Printer(size: .init(x: 500, y: 500), scale: 2.0)
        
        block(printer)
        
        printer.printAll()
    }
}
