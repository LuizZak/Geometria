import Geometria

class ProcessingPrinter {
    private var _lastStrokeColorCall: String? = ""
    private var _lastStrokeWeightCall: String? = ""
    private var _lastFillColorCall: String? = ""
    
    private let identDepth: Int = 2
    private var currentIndent: Int = 0
    private var draws: [String] = []
    private var cylinders: [Cylinder3<Vector3D>] = []
    private var shouldPrintDrawNormal: Bool = false
    private var shouldPrintDrawTangent: Bool = false
    private var is3D: Bool = false
    private var hasCylinders: Bool { !cylinders.isEmpty }
    
    private var buffer: String = ""
    
    var size: Vector2i
    var scale: Double
    
    var drawOrigin: Bool = true
    var drawGrid: Bool = false
    
    init(size: Vector2i = .init(x: 800, y: 600), scale: Double = 25.0) {
        self.size = size
        self.scale = scale
    }
    
    func add<V: Vector2Type>(ellipse: Ellipsoid<V>) where V.Scalar: CustomStringConvertible {
        addStrokeColorSet("0")
        addStrokeWeightSet("1 / scale")
        addNoFill()
        addDrawLine("ellipse(\(vec2String(ellipse.center)), \(vec2String(ellipse.radius)));")
        addDrawLine("")
    }
    
    func add<V: Vector3FloatingPoint>(ellipse3: Ellipsoid<V>) where V.Scalar: CustomStringConvertible {
        is3D = true
        addNoStroke()
        add3DSpaceBarBoilerplate(lineWeight: ellipse3.radius.maximalComponent)
        addDrawLine("pushMatrix();")
        addDrawLine("translate(\(vec3String(ellipse3.center)));")
        addDrawLine("scale(\(vec3String(ellipse3.radius)));")
        addDrawLine("sphere(1);")
        addDrawLine("popMatrix();")
        addDrawLine("")
    }
    
    func add<Line: Line2Type>(line: Line) where Line.Vector.Scalar: CustomStringConvertible {
        addStrokeColorSet("0")
        addStrokeWeightSet("1 / scale")
        addDrawLine("line(\(vec2String(line.a)), \(vec2String(line.b)));")
        addDrawLine("")
    }
    
    func add<Vector: Vector3Type>(ray: DirectionalRay3<Vector>) where Vector.Scalar: FloatingPoint & CustomStringConvertible {
        is3D = true
        
        addStrokeColorSet("255, 0, 0")
        addStrokeWeightSet("2 / scale")
        addDrawLine("line(\(vec3String(ray.start)), \(vec3String(ray.projectedMagnitude(500))));")
        addDrawLine("")
    }
    
    func add<Line: Line3Type>(line: Line, color: String = "0") where Line.Vector.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        addStrokeColorSet(color)
        addStrokeWeightSet("2 / scale")
        addDrawLine("line(\(vec3String(line.a)), \(vec3String(line.b)));")
        addDrawLine("")
    }
    
    func add<V: Vector2Type>(intersection result: ConvexLineIntersection<V>) where V.Scalar: CustomStringConvertible {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pointNormal: pn)
        case let .enterExit(p1, p2):
            add(pointNormal: p1)
            add(pointNormal: p2)
        }
    }
    
    func add<V: Vector3Type>(intersection result: ConvexLineIntersection<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        switch result {
        case .contained, .noIntersection:
            break
        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            add(pointNormal: pn)
        case let .enterExit(p1, p2):
            add(pointNormal: p1)
            add(pointNormal: p2)
        }
    }
    
    func add<V: Vector2Type>(pointNormal: PointNormal<V>) where V.Scalar: CustomStringConvertible {
        shouldPrintDrawNormal = true
        shouldPrintDrawTangent = true
        
        addStrokeWeightSet("1 / scale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("drawNormal(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)));")
        addStrokeColorSet("255, 0, 255, 100")
        addDrawLine("drawTangent(\(vec2String(pointNormal.point)), \(vec2String(pointNormal.normal)));")
        addDrawLine("")
    }
    
    func add<V: Vector3Type>(pointNormal: PointNormal<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        shouldPrintDrawNormal = true
        
        addStrokeWeightSet("1 / scale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("drawNormal(\(vec3String(pointNormal.point)), \(vec3String(pointNormal.normal)));")
    }
    
    func add<V: Vector2Type>(circle: Circle2<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        addStrokeWeightSet("1 / scale")
        addStrokeColorSet("255, 0, 0, 100")
        addDrawLine("circle(\(vec2String(circle.center)), \(circle.radius));")
    }
    
    func add<V: Vector3Type>(sphere: Sphere3<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        add3DSpaceBarBoilerplate(lineWeight: 1.0)
        addDrawLine("pushMatrix();")
        addDrawLine("translate(\(vec3String(sphere.center)));")
        addDrawLine("sphere(\(sphere.radius));")
        addDrawLine("popMatrix();")
    }
    
    func add<V: Vector3Additive & VectorDivisible>(aabb: AABB3<V>) where V.Scalar: SignedNumeric & CustomStringConvertible {
        is3D = true
        
        add3DSpaceBarBoilerplate(lineWeight: 1.0)
        addDrawLine("pushMatrix();")
        addDrawLine("translate(\(vec3String(aabb.minimum + aabb.size / 2)));")
        addDrawLine("box(\(vec3String(aabb.size)));")
        addDrawLine("popMatrix();")
    }
    
    func add(cylinder: Cylinder3<Vector3D>) {
        is3D = true
        
        cylinders.append(cylinder)
    }
    
    func printAll() {
        defer { printBuffer() }
        
        if is3D {
            printLine("// 3rd party libraries:")
            printLine("// PeasyCam by Jonathan Feinberg")
            printLine("import peasy.*;")
            printLine("")
            printLine("// Shapes 3D by Peter Lager")
            printLine("import shapes3d.*;")
            printLine("import shapes3d.contour.*;")
            printLine("import shapes3d.org.apache.commons.math.*;")
            printLine("import shapes3d.org.apache.commons.math.geometry.*;")
            printLine("import shapes3d.path.*;")
            printLine("import shapes3d.utils.*;")
            printLine("")
        }
        
        printLine("float scale = \(scale);")
        if is3D {
            printLine("boolean isSpaceBarPressed = false;")
            printLine("PeasyCam cam;")
        }
        if hasCylinders {
            printLine("ArrayList<Tube> cylinders = new ArrayList<Tube>();")
        }
        
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
        
        if hasCylinders {
            printLine("")
            printAddCylinder()
            printLine("")
            printDrawCylinders()
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
    }
    
    // MARK: - Expression Printing
    
    private func addDrawLine(_ line: String) {
        draws.append(line)
    }
    
    private func addNoStroke() {
        if _lastStrokeColorCall == nil { return }
        _lastStrokeColorCall = nil
        addDrawLine("noStroke();")
    }
    
    private func addNoFill() {
        if _lastFillColorCall == nil { return }
        _lastFillColorCall = nil
        addDrawLine("noFill();")
    }
    
    private func add3DSpaceBarBoilerplate<T: FloatingPoint>(lineWeight: T) {
        addDrawLine("if (isSpaceBarPressed) {")
        addDrawLine(indentString(depth: 1) + "noFill();")
        addDrawLine(indentString(depth: 1) + "noLights();")
        addDrawLine(indentString(depth: 1) + "stroke(0, 0, 0, 20);")
        addDrawLine(indentString(depth: 1) + "strokeWeight(\(1 / lineWeight) / scale);")
        addDrawLine("} else {")
        addDrawLine(indentString(depth: 1) + "noStroke();")
        addDrawLine(indentString(depth: 1) + "fill(255, 255, 255, 255);")
        addDrawLine(indentString(depth: 1) + "lights();")
        addDrawLine("}")
    }
    
    private func addStrokeColorSet(_ value: String) {
        if _lastStrokeColorCall == value { return }
        
        _lastStrokeColorCall = value
        addDrawLine("stroke(\(value));")
    }
    
    private func addStrokeWeightSet(_ value: String) {
        if _lastStrokeWeightCall == value { return }
        
        _lastStrokeWeightCall = value
        addDrawLine("strokeWeight(\(value));")
    }
    
    private func addFillColorSet(_ value: String) {
        if _lastFillColorCall == value { return }
        
        _lastFillColorCall = value
        addDrawLine("fill(\(value));")
    }
    
    // MARK: - Function Printing
    
    private func printSetup() {
        func printCylinder(_ cylinder: Cylinder3<Vector3D>) {
            let start = vec3PVectorString(cylinder.start)
            let end = vec3PVectorString(cylinder.end)
            
            printLine("addCylinder(\(start), \(end), \(cylinder.radius));")
        }
        
        indentedBlock("void setup() {") {
            if is3D {
                printLine("size(\(vec2String(size)), P3D);")
                printLine("perspective(PI / 3, 1, 0.3, 8000); // Corrects default zNear plane being too far for unit measurements")
                printLine("cam = new PeasyCam(this, 0, 0, 0, 250);")
                printLine("cam.setWheelScale(0.3);")
            } else {
                printLine("size(\(vec2String(size)));")
            }
            
            if hasCylinders {
                for cylinder in cylinders {
                    printCylinder(cylinder)
                }
            }
            
            printLine("ellipseMode(RADIUS);")
        }
    }
    
    private func printDraw() {
        indentedBlock("void draw() {") {
            printLine("background(255);")
            printLine("")
            if !is3D {
                printLine("translate(width / 2, height / 2);")
                printLine("scale(scale);")
            }
            printLine("")
            printLine("strokeWeight(3 / scale);")
            
            if drawGrid {
                printLine("drawGrid();")
            }
            if drawOrigin && is3D {
                printLine("drawOrigin();")
            }
            
            printLine("")
            
            for draw in draws {
                printLine(draw)
            }
            
            if hasCylinders {
                printLine("drawCylinders();")
            }
        }
    }
    
    private func printKeyPressed() {
        indentedBlock("void keyPressed() {") {
            indentedBlock("if (key == ' ') {") {
                printLine("isSpaceBarPressed = !isSpaceBarPressed;")
            }
            
            if hasCylinders {
                indentedBlock("for (Tube t: cylinders) {") {
                    indentedBlock("if (isSpaceBarPressed) {") {
                        printLine("t.drawMode(S3D.WIRE);")
                    }
                    printLine("else")
                    indentedBlock("{") {
                        printLine("t.drawMode(S3D.SOLID);")
                    }
                }
            }
        }
    }
    
    private func printAddCylinder() {
        indentedBlock("void addCylinder(PVector start, PVector end, float radius) {") {
            printLine("Oval base = new Oval(radius, 20);")
            printLine("Path line = new Linear(start, end, 1);")
            printLine("")
            printLine("Tube tube = new Tube(line, base);")
            printLine("")
            printLine("tube.drawMode(S3D.SOLID);")
            printLine("tube.stroke(color(50, 50, 50, 50));")
            printLine("tube.strokeWeight(1);")
            printLine("tube.fill(color(200, 200, 200, 50));")
            printLine("")
            printLine("cylinders.add(tube);")
        }
    }
    
    private func printDrawCylinders() {
        indentedBlock("void drawCylinders() {") {
            indentedBlock("for (Tube t: cylinders) {") {
                printLine("t.draw(getGraphics());")
            }
        }
    }
    
    private func printDrawGrid2D() {
        indentedBlock("void drawGrid() {") {
            printLine("stroke(0, 0, 0, 30);")
            printLine("line(0, -20, 0, 20);")
            printLine("line(-20, 0, 20, 0);")
            indentedBlock("for (int x = -10; x < 10; x++) {") {
                printLine("stroke(0, 0, 0, 20);")
                printLine("line(x, -20, x, 20);")
            }
            indentedBlock("for (int y = -10; y < 10; y++) {") {
                printLine("stroke(0, 0, 0, 20);")
                printLine("line(-20, y, 20, y);")
            }
        }
    }
    
    private func printDrawOrigin3D() {
        indentedBlock("void drawOrigin() {") {
            let length: Double = 100.0
            
            let vx = Vector3D.unitX * length
            let vy = Vector3D.unitY * length
            let vz = Vector3D.unitZ * length
            
            printLine("// X axis")
            printLine("stroke(255, 0, 0, 50);")
            printLine("line(\(vec3String(-vx)), \(vec3String(vx)));")
            printLine("// Y axis")
            printLine("stroke(0, 255, 0, 50);")
            printLine("line(\(vec3String(-vy)), \(vec3String(vy)));")
            printLine("// Z axis")
            printLine("stroke(0, 0, 255, 50);")
            printLine("line(\(vec3String(-vz)), \(vec3String(vz)));")
        }
    }
    
    private func printDrawNormal2D() {
        indentedBlock("void drawNormal(float x, float y, float nx, float ny) {") {
            printLine("float x2 = x + nx;")
            printLine("float y2 = y + ny;")
            printLine("")
            printLine("line(x, y, x2, y2);")
        }
    }
    
    private func printDrawNormal3D() {
        indentedBlock("void drawNormal(float x, float y, float z, float nx, float ny, float nz) {") {
            printLine("float s = 5.0;")
            printLine("")
            printLine("float x2 = x + nx * s;")
            printLine("float y2 = y + ny * s;")
            printLine("float z2 = z + nz * s;")
            printLine("")
            printLine("line(x, y, z, x2, y2, z2);")
        }
    }
    
    private func printDrawTangent2D() {
        indentedBlock("void drawTangent(float x, float y, float nx, float ny) {") {
            printLine("float s = 5.0;")
            printLine("")
            printLine("float x1 = x - ny * s;")
            printLine("float y1 = y + nx * s;")
            printLine("")
            printLine("float x2 = x + ny * s;")
            printLine("float y2 = y - nx * s;")
            printLine("")
            printLine("line(x1, y1, x2, y2);")
        }
    }
    
    // MARK: - String printing
    
    private func printLine(_ line: String) {
        print("\(indentString())\(line)", to: &buffer)
    }
    
    private func printBuffer() {
        print(buffer)
        buffer = ""
    }
    
    private func vec3PVectorString<V: Vector3Type>(_ vec: V) -> String where V.Scalar: SignedNumeric & CustomStringConvertible {
        return "new PVector(\(vec3String(vec)))"
    }
    
    private func vec3String<V: Vector3Type>(_ vec: V) -> String where V.Scalar: SignedNumeric & CustomStringConvertible {
        // Flip Y-Z axis (in Processing positive Y axis is down)
        return "\(vec.x), \(-vec.z), \(vec.y)"
    }
    
    private func vec2String<V: Vector2Type>(_ vec: V) -> String where V.Scalar: CustomStringConvertible {
        "\(vec.x), \(vec.y)"
    }
    
    private func indentString() -> String {
        indentString(depth: identDepth * currentIndent)
    }
    
    private func indentString(depth: Int) -> String {
        String(repeating: " ", count: depth)
    }
    
    private func indentedBlock(_ start: String, _ block: () -> Void) {
        printLine(start)
        indented {
            block()
        }
        printLine("}")
    }
    
    private func indented(_ block: () -> Void) {
        indent()
        block()
        deindent()
    }
    
    private func indent() {
        currentIndent += 1
    }
    
    private func deindent() {
        currentIndent -= 1
    }
}

extension ProcessingPrinter {
    static func withPrinter(_ block: (ProcessingPrinter) -> Void) {
        let printer = ProcessingPrinter(size: .init(x: 500, y: 500), scale: 25.0)
        
        block(printer)
        
        printer.printAll()
    }
}
