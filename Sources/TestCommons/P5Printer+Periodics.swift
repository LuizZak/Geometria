import MiniP5Printer
import Geometria
import GeometriaPeriodics

extension P5Printer {
    func printPeriodicsSlider() {
        printMultiline("""
        periodSlider = createSlider(0.0, 1.0, 0.5, 0.0)
        periodSlider.size(width)
        """)
        printLine("")
        printLine("periodics = [")
        indented {
            for periodic in periodicsToDraw {
                printMultiline(periodic)
            }
        }
        printLine("]")
    }

    func printPeriodicsDraw() {
        printMultiline(#"""
            fill(0)
            noStroke()
            text(`Period: ${periodSlider.value()}`, 10, height - 10)
            translate(width / 2, height / 2)
            stroke(0)
            noFill()
            for (let periodic of periodics) {
                periodic.render(periodSlider.value())
            }
            noStroke()
            fill(0)
            """#)
    }

    func printPeriodicTypes() {
        printMultiline(#"""
        class Periodic {
          constructor(startPeriod, endPeriod) {
            this.startPeriod = startPeriod
            this.endPeriod = endPeriod
          }
          
          render(ratio) {
            
          }
        }
        
        class LinePeriodic extends Periodic {
          constructor(start, end, startPeriod, endPeriod) {
            super(startPeriod, endPeriod)
            
            this.start = start
            this.end = end
            this.lineSlope = p5.Vector.sub(end, start)
          }
          
          render(ratio) {
            if (ratio < this.startPeriod) { return }
            
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
          }
        }
        
        class ArcPeriodic extends Periodic {
          constructor(center, radius, startAngle, sweep, startPeriod, endPeriod) {
            super(startPeriod, endPeriod)
            
            this.center = center
            this.radius = radius
            this.startAngle = startAngle
            this.sweep = sweep
          }
          
          render(ratio) {
            if (ratio < this.startPeriod) { return }
            
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
            
            arc(this.center.x, this.center.y, this.radius, this.radius, this.startAngle, arcEnd)
            
            if (shouldDrawAnchor) {
              let anchorX = cos(arcEnd) * this.radius
              let anchorY = sin(arcEnd) * this.radius
              
              drawAnchor(p5.Vector.add(this.center, createVector(anchorX, anchorY)))
            }
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

    func add<Periodic: Periodic2Geometry>(_ periodic: Periodic, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Periodic.Vector.Scalar: Numeric & CustomStringConvertible {
        for simplex in periodic.allSimplexes() {
            add(simplex, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: Periodic2GeometrySimplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: Numeric & CustomStringConvertible {
        switch simplex {
        case .lineSegment2(let lineSegment):
            add(lineSegment, style: style, file: file, line: line)

        case .circleArc2(let circleArc):
            add(circleArc, style: style, file: file, line: line)
        }
    }

    func add<Vector: Vector2Type>(_ simplex: CircleArc2Simplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: Numeric & CustomStringConvertible {
        requiresPeriodicTypes = true
        requiresPeriodSlider = true

        periodicsToDraw.append(#"""
        new ArcPeriodic(
          \#(vec2PVectorString(simplex.circleArc.center)),
          \#(simplex.circleArc.radius),
          \#(simplex.circleArc.startAngle.normalized(from: .zero)),
          \#(simplex.circleArc.stopAngle.normalized(from: .zero)),
          \#(simplex.startPeriod), \#(simplex.endPeriod)
        ),
        """#)
    }

    func add<Vector: Vector2Type>(_ simplex: LineSegment2Simplex<Vector>, style: Style? = nil, file: StaticString = #file, line: UInt = #line) where Vector.Scalar: Numeric & CustomStringConvertible {
        requiresPeriodicTypes = true
        requiresPeriodSlider = true

        periodicsToDraw.append(#"""
        new LinePeriodic(
          \#(vec2PVectorString(simplex.start)),
          \#(vec2PVectorString(simplex.end)),
          \#(simplex.startPeriod), \#(simplex.endPeriod)
        ),
        """#)
    }
}

//

extension LinePolygon2Periodic: VisualizableGeometricType2 where Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Periodic2GeometrySimplex: VisualizableGeometricType2 where Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}
