import MiniP5Printer
import Geometria

extension Vector2: VisualizableGeometricType2 where Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Vector3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension PointNormal: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension PointNormal: VisualizableGeometricType3 where Vector: Vector3Type & VisualizableGeometricType3, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LineIntersectionPointNormal: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LineIntersectionPointNormal: VisualizableGeometricType3 where Vector: Vector3Type & VisualizableGeometricType3, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension ClosedShape2Intersection: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Line2: VisualizableGeometricType2 where Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Line3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LineSegment2: VisualizableGeometricType2 where Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LineSegment3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Ray3: VisualizableGeometricType3 where Vector: VectorAdditive, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension DirectionalRay3: VisualizableGeometricType3 where Scalar: CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Circle2: VisualizableGeometricType2 where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension CircleArc2: VisualizableGeometricType2 where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Sphere3: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension AABB2: VisualizableGeometricType2 where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension AABB3: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension NRectangle: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension NSquare: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Torus3: VisualizableGeometricType3 where Vector: VectorReal, Scalar: CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LinePolygon: VisualizableGeometricType2 where Vector: Vector2Real, Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LinePolygon: VisualizableGeometricType3 where Vector: Vector3Real, Scalar: CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension LineIntersection: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        for intersection in self.intersections {
            intersection.addVisualization2D(to: printer, style: style, file: file, line: line)
        }
    }
}

extension LineIntersection.Intersection: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        pointNormal.addVisualization2D(to: printer, style: style, file: file, line: line)
    }
}

extension PointCloud2: VisualizableGeometricType2 where Vector: Vector2Type & VisualizableGeometricType2, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: BaseP5Printer.Style?, file: StaticString, line: UInt) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension PointCloud3: VisualizableGeometricType3 where Vector: Vector3Type & VisualizableGeometricType2, Vector.Scalar: Numeric & CustomStringConvertible {
    public func addVisualization3D(to printer: P5Printer, style: BaseP5Printer.Style?, file: StaticString, line: UInt) {
        printer.add(self, style: style, file: file, line: line)
    }
}
