import Geometria

extension Vector2: Visualizable2DGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Vector3: Visualizable3DGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Line3: Visualizable3DGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension LineSegment3: Visualizable3DGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Ray3: Visualizable3DGeometricType where Vector: VectorAdditive, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension DirectionalRay3: Visualizable3DGeometricType where Scalar: CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension AABB2: Visualizable2DGeometricType where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension AABB3: Visualizable3DGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NRectangle: Visualizable2DGeometricType where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NRectangle: Visualizable3DGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NSquare: Visualizable3DGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Torus3: Visualizable3DGeometricType where Vector: VectorReal, Scalar: CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}
