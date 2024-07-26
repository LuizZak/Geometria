import Foundation
import MiniP5Printer
import Geometria
import GeometriaClipping

extension P5Printer {
    func printPeriodSlider() {
        printMultiline("""
        periodSlider = createSlider(0.0, 1.0, 0.5, 0.0)
        periodSlider.size(width)
        """)
        printLine("")
        printLine("parametrics = [")
        indented {
            for parametric in parametricsToDraw {
                printMultiline(parametric)
            }
        }
        printLine("]")

        printMultiline("""
        for (let parametric of parametrics) {
          if (parametricCheckboxes[parametric.category] !== undefined) {
            parametricCheckboxes[parametric.category].parametrics.push(parametric)
          } else {
            parametricCheckboxes[parametric.category] = {
              checkbox: null,
              parametrics: [parametric],
            }
          }
        }
        for (let entry in parametricCheckboxes) {
          entryCount = parametricCheckboxes[entry].parametrics.length
          parametricCheckboxes[entry].checkbox = createCheckbox(`${entry} (${entryCount})`, true)
        }
        """)
    }

    func printParametricsDraw() {
        printMultiline(#"""
            fill(0)
            noStroke()
            text(`Period: ${periodSlider.value()}`, 10, height - 10)
            translate(width / 2, height / 2)
            scale(renderScale)
            stroke(0)
            noFill()
            for (let parametric of parametrics) {
              if (parametricCheckboxes[parametric.category].checkbox.checked()) {
                parametric.render(periodSlider.value()) 
              }
            }
            noStroke()
            fill(0)
            """#)
    }

    func printParametricTypes() {
        printMultiline(#"""
        class Parametric {
          constructor(startPeriod, endPeriod, fillColor, strokeColor, category) {
            this.startPeriod = startPeriod
            this.endPeriod = endPeriod
            this.fillColor = fillColor
            this.strokeColor = strokeColor
            this.category = category
          }
          
          render(ratio) {
            
          }

          setupColors() {
            if (this.fillColor !== null) {
              fill(this.fillColor)
            } else {
              fill(255)
            }
            if (this.strokeColor !== null) {
              stroke(this.strokeColor)
            } else {
              stroke(0)
            }
          }
          resetColors() {
            stroke(0)
            fill(255)
          }
        }
        
        class IntersectionParametric extends Parametric {
          constructor(position, startPeriod, endPeriod, fillColor, strokeColor, category) {
            super(startPeriod, endPeriod, fillColor, strokeColor, category)
            
            this.position = position
          }
          
          render(ratio) {
            if (ratio < this.startPeriod) { return }

            this.setupColors()
            
            drawAnchor(this.position)

            this.resetColors()
          }
        }

        class LineParametric extends Parametric {
          constructor(start, end, startPeriod, endPeriod, fillColor, strokeColor, category) {
            super(startPeriod, endPeriod, fillColor, strokeColor, category)
            
            this.start = start
            this.end = end
            this.lineSlope = p5.Vector.sub(end, start)
          }
          
          render(ratio) {
            if (ratio < this.startPeriod) { return }

            this.setupColors()
            
            let periodLength = this.endPeriod - this.startPeriod
            let periodPoint = ratio - this.startPeriod
            let periodRatio = periodPoint / periodLength
            let shouldDrawAnchor = false
            if (periodRatio > 1.0) {
              periodRatio = 1.0
            } else {
              shouldDrawAnchor = true
            }
            
            let lineEnd = p5.Vector.add(this.start, p5.Vector.mult(this.lineSlope, periodRatio))
        
            line(this.start.x, this.start.y, lineEnd.x, lineEnd.y)
            
            drawAnchor(this.start, 3)
            if (ratio > this.endPeriod) {
              drawAnchor(this.end, 3)
            }
            if (shouldDrawAnchor) {
              drawAnchor(lineEnd)
            }

            this.resetColors()
          }
        }
        
        class ArcParametric extends Parametric {
          constructor(center, radius, startAngle, sweep, startPeriod, endPeriod, fillColor, strokeColor, category) {
            super(startPeriod, endPeriod, fillColor, strokeColor, category)
            
            this.center = center
            this.radius = radius
            this.startAngle = startAngle
            this.sweep = sweep
          }
          
          render(ratio) {
            if (ratio < this.startPeriod) { return }

            this.setupColors()

            let periodLength = this.endPeriod - this.startPeriod
            let periodPoint = ratio - this.startPeriod
            let periodRatio = periodPoint / periodLength
            let shouldDrawAnchor = false
            if (periodRatio > 1.0) {
              periodRatio = 1.0
            } else {
              shouldDrawAnchor = true
            }

            let arcEndSweep = this.sweep * periodRatio
            let arcEnd = this.startAngle + arcEndSweep

            noFill()
            const segments = 50;
            for (let i = 0; i < segments; i++) {
              let angle = this.startAngle + arcEndSweep * (i / segments)
              let angleNext = this.startAngle + (arcEndSweep * ((i + 1) / segments))

              let ca = cos(angle) * this.radius
              let sa = sin(angle) * this.radius
              let cn = cos(angleNext) * this.radius
              let sn = sin(angleNext) * this.radius

              line(this.center.x + ca, this.center.y + sa, this.center.x + cn, this.center.y + sn)
              if (i == 0) {
                drawAnchor(createVector(this.center.x + ca, this.center.y + sa), 3)
              }
              if (ratio > this.endPeriod && i == segments - 1) {
                drawAnchor(createVector(this.center.x + ca, this.center.y + sa), 3)
              }
            }

            if (shouldDrawAnchor) {
              let anchorX = cos(arcEnd) * this.radius
              let anchorY = sin(arcEnd) * this.radius
              
              drawAnchor(p5.Vector.add(this.center, createVector(anchorX, anchorY)))
            }

            this.resetColors()
          }
        }
        """#)
    }

    func printDrawAnchor() {
        printMultiline(#"""
        function drawAnchor(position, radius) {
            radius = radius || 5
            fill(255)
            circle(position.x, position.y, radius)

            noFill()
        }
        """#)
    }

    func add<Vector: Vector2Real>(_ simplexGraph: Simplex2Graph<Vector>, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        for edge in simplexGraph.edges {
            add(edge.materialize(), category: category, style: style, file: file, line: line)
        }
    }

    func add<Parametric: ParametricClip2Geometry>(_ parametric: Parametric, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Parametric.Vector.Scalar: CustomStringConvertible {
        add(parametric.allContours(), category: category, style: style, file: file, line: line)
    }

    func add<Vector: Vector2Real>(_ contours: [Parametric2Contour<Vector>], category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        for contour in contours {
            add(contour, category: category, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Real>(_ contour: Parametric2Contour<Vector>, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        add(contour.allSimplexes(), category: category, style: style, file: file, line: line)
    }

    func add<Vector: Vector2Type>(_ simplexes: [Parametric2GeometrySimplex<Vector>], category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        for simplex in simplexes {
            add(simplex, category: category, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: Parametric2GeometrySimplex<Vector>, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        switch simplex {
        case .lineSegment2(let lineSegment):
            add(lineSegment, category: category, style: style, file: file, line: line)

        case .circleArc2(let circleArc):
            add(circleArc, category: category, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: CircleArc2Simplex<Vector>, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        parametricsToDraw.append(#"""
        new ArcParametric(
          \#(vec2PVectorString(simplex.circleArc.center)),
          \#(simplex.circleArc.radius),
          \#(simplex.circleArc.startAngle.normalized(from: .zero)),
          \#(simplex.circleArc.sweepAngle.radians),
          \#(simplex.startPeriod), \#(simplex.endPeriod),
          \#(periodicStyle2String(style)), \#(periodicCategory2String(category))
        ),
        """#)
    }

    func add<Vector: Vector2Type>(_ simplex: LineSegment2Simplex<Vector>, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        parametricsToDraw.append(#"""
        new LineParametric(
          \#(vec2PVectorString(simplex.start)),
          \#(vec2PVectorString(simplex.end)),
          \#(simplex.startPeriod), \#(simplex.endPeriod),
          \#(periodicStyle2String(style)), \#(periodicCategory2String(category))
        ),
        """#)
    }

    func add<Vector: Vector2Real>(_ contour: Parametric2Contour<Vector>, intersectionAt period: Vector.Scalar, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        let point = contour.compute(at: period)

        add(intersection: point, at: period, category: category, style: style, file: file, line: line)
    }

    func add<Vector: Vector2Real>(intersection point: Vector, at period: Vector.Scalar, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        parametricsToDraw.append(#"""
        new IntersectionParametric(
          \#(vec2PVectorString(point)),
          \#(period), \#(period),
          \#(periodicStyle2String(style)), \#(periodicCategory2String(category))
        ),
        """#)
    }


    func add<Parametric: ParametricClip2Geometry>(_ parametric: Parametric, intersectionAt period: Parametric.Period, category: String, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Parametric.Vector.Scalar: CustomStringConvertible {
        for contour in parametric.allContours() {
            add(contour, intersectionAt: period, category: category, style: style, file: file, line: line)
        }
    }

    func periodicStyle2String(_ style: Style?) -> String {
        return "\(periodicColor2String(style?.fillColor)), \(periodicColor2String(style?.strokeColor))"
    }

    func periodicCategory2String(_ category: String) -> String {
        return category.debugDescription
    }

    func periodicColor2String(_ color: Color?) -> String {
        if let color {
            return color.hex.debugDescription
        }
        return "null"
    }
}

extension BaseP5Printer.Color {
    var hex: String {
        func format(_ value: Int) -> String {
            let hex = String(value, radix: 16)
            if hex.count < 2 {
                return "0\(hex)"
            }
            return hex
        }

        return "#\(format(red))\(format(green))\(format(blue))"
    }
}

extension P5Printer {
    static func printGraph<Vector>(_ simplexGraph: Simplex2Graph<Vector>) where Vector.Scalar: CustomStringConvertible {
        let printer = P5Printer()
        printer.add(simplexGraph, category: "input")

        for node in simplexGraph.nodes {
            switch node.kind {
            case .intersection(_, let lhsPeriod, _, let rhsPeriod):
                printer.add(intersection: node.location, at: lhsPeriod, category: "lhs intersections")
                printer.add(intersection: node.location, at: rhsPeriod, category: "rhs intersections")

            case .geometry, .sharedGeometry:
                break
            }
        }

        printer.printAll()
    }
}
