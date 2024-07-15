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
                parametric.render(periodSlider.value())
            }
            noStroke()
            fill(0)
            """#)
    }

    func printParametricTypes() {
        printMultiline(#"""
        class Parametric {
          constructor(startPeriod, endPeriod, fillColor, strokeColor) {
            this.startPeriod = startPeriod
            this.endPeriod = endPeriod
            this.fillColor = fillColor
            this.strokeColor = strokeColor
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
          constructor(position, startPeriod, endPeriod, fillColor, strokeColor) {
            super(startPeriod, endPeriod, fillColor, strokeColor)
            
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
          constructor(start, end, startPeriod, endPeriod, fillColor, strokeColor) {
            super(startPeriod, endPeriod, fillColor, strokeColor)
            
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
            
            if (shouldDrawAnchor) {
              drawAnchor(lineEnd)
            }

            this.resetColors()
          }
        }
        
        class ArcParametric extends Parametric {
          constructor(center, radius, startAngle, sweep, startPeriod, endPeriod, fillColor, strokeColor) {
            super(startPeriod, endPeriod, fillColor, strokeColor)
            
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
        function drawAnchor(position) {
            fill(255)
            circle(position.x, position.y, 5)

            noFill()
        }
        """#)
    }

    func add<Vector: Vector2Real>(_ contour: Parametric2Contour<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        parametricsToDraw.append("// \(URL(fileURLWithPath: "\(file)").lastPathComponent):\(line)")
        for simplex in contour.allSimplexes() {
            add(simplex, style: style, file: file, line: line)
        }
    }

    func add<Parametric: ParametricClip2Geometry>(_ parametric: Parametric, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Parametric.Vector.Scalar: CustomStringConvertible {
        parametricsToDraw.append("// \(URL(fileURLWithPath: "\(file)").lastPathComponent):\(line)")
        for simplex in parametric.allContours() {
            add(simplex, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: Parametric2GeometrySimplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        switch simplex {
        case .lineSegment2(let lineSegment):
            add(lineSegment, style: style, file: file, line: line)

        case .circleArc2(let circleArc):
            add(circleArc, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: CircleArc2Simplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        parametricsToDraw.append(#"""
        new ArcParametric(
          \#(vec2PVectorString(simplex.circleArc.center)),
          \#(simplex.circleArc.radius),
          \#(simplex.circleArc.startAngle.normalized(from: .zero)),
          \#(simplex.circleArc.sweepAngle.radians),
          \#(simplex.startPeriod), \#(simplex.endPeriod),
          \#(periodicStyle2String(style))
        ),
        """#)
    }

    func add<Vector: Vector2Type>(_ simplex: LineSegment2Simplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        parametricsToDraw.append(#"""
        new LineParametric(
          \#(vec2PVectorString(simplex.start)),
          \#(vec2PVectorString(simplex.end)),
          \#(simplex.startPeriod), \#(simplex.endPeriod),
          \#(periodicStyle2String(style))
        ),
        """#)
    }

    func add<Vector: Vector2Real>(_ contour: Parametric2Contour<Vector>, intersectionAt period: Vector.Scalar, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: CustomStringConvertible {
        requiresParametricTypes = true
        requiresPeriodSlider = true

        let point = contour.compute(at: period)

        parametricsToDraw.append(#"""
        new IntersectionParametric(
          \#(vec2PVectorString(point)),
          \#(period), \#(period),
          \#(periodicStyle2String(style))
        ),
        """#)
    }

    func add<Parametric: ParametricClip2Geometry>(_ parametric: Parametric, intersectionAt period: Parametric.Period, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Parametric.Vector.Scalar: CustomStringConvertible {
        for contour in parametric.allContours() {
            add(contour, intersectionAt: period, style: style, file: file, line: line)
        }
    }

    func periodicStyle2String(_ style: Style?) -> String {
        return "\(periodicColor2String(style?.fillColor)), \(periodicColor2String(style?.strokeColor))"
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
