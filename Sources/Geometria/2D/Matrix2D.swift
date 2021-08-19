import Foundation

// This source code is partially based on SharpDX's Matrix3x2.cs & MathUtils.cs
// implementations, the license of which is stated bellow:

// Copyright (c) 2010-2014 SharpDX - Alexandre Mutel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// -----------------------------------------------------------------------------
// Original code from SlimMath project. http://code.google.com/p/slimmath/
// Greetings to SlimDX Group. Original code published with the following license:
// -----------------------------------------------------------------------------
/*
* Copyright (c) 2007-2011 SlimDX Group
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

/// Plain Matrix3x2.
public struct Matrix2D: Hashable, Codable, CustomStringConvertible {
    /// Gets the identity matrix.
    public static let identity = Matrix2D(m11: 1, m12: 0, m21: 0, m22: 1, m31: 0, m32: 0)

    /// Element (1,1)
    public let m11: Double

    /// Element (1,2)
    public let m12: Double

    /// Element (2,1)
    public let m21: Double

    /// Element (2,2)
    public let m22: Double

    /// Element (3,1)
    public let m31: Double

    /// Element (3,2)
    public let m32: Double

    /// Gets the first row in the matrix; that is M11 and M12.
    public var row1: Vector2D { Vector2D(x: m11, y: m12) }

    /// Gets the second row in the matrix; that is M21 and M22.
    public var row2: Vector2D { Vector2D(x: m21, y: m22) }

    /// Gets the third row in the matrix; that is M31 and M32.
    public var row3: Vector2D { Vector2D(x: m31, y: m32) }

    /// Gets the first column in the matrix; that is M11, M21, and M31.
    public var column1: [Double] { [m11, m21, m31] }

    /// Gets the second column in the matrix; that is M12, M22, and M32.
    public var column2: [Double] { [m12, m22, m32] }

    /// Gets the translation of the matrix; that is M31 and M32.
    public var translationVector: Vector2D { Vector2D(x: m31, y: m32) }

    /// Gets the scale of the matrix; that is M11 and M22.
    public var scaleVector: Vector2D { Vector2D(x: m11, y: m22) }

    /// Gets a value indicating whether this instance is an identity matrix.
    ///
    /// `true` if this instance is an identity matrix; otherwise, `false`.
    public var isIdentity: Bool { Matrix2D.identity == self }

    /// Gets or sets the component at the specified index.
    ///
    /// - Parameter index: The zero-based index of the component to access.
    /// - Returns: The value of the component at the specified index.
    public subscript(index index: Int) -> Double {
        switch index {
            case 0: return m11
            case 1: return m12
            case 2: return m21
            case 3: return m22
            case 4: return m31
            case 5: return m32
            default: fatalError("Indices for Matrix3x2 run from 0 to 5, inclusive.")
        }
    }

    /// Gets or sets the component at the specified index.
    ///
    /// - Parameter row: The row of the matrix to access.
    /// - Parameter column: The column of the matrix to access.
    /// - Returns: The value of the component at the specified index.
    public subscript(row row: Int, column: Int) -> Double {
        if row < 0 || row > 2 {
            fatalError("Rows and columns for matrices run from 0 to 2, inclusive.")
        }
        if column < 0 || column > 1 {
            fatalError("Rows and columns for matrices run from 0 to 1, inclusive.")
        }

        return self[index: row * 2 + column]
    }

    /// Returns a `String` that represents this instance.
    public var description: String {
        return "[M11:\(m11) M12:\(m12)] [M21:\(m21) M22:\(m22)] [M31:\(m31) M32:\(m32)]"
    }

    /// Initializes a new instance of the `Matrix2D` struct.
    ///
    /// - Parameter value: The value that will be assigned to all components.
    public init(value: Double) {
        m11 = value
        m12 = value
        m21 = value
        m22 = value
        m31 = value
        m32 = value
    }

    /// Initializes a new instance of the `Matrix2D` struct.
    ///
    /// - Parameter m11: The value to assign at row 1 column 1 of the matrix.
    /// - Parameter m12: The value to assign at row 1 column 2 of the matrix.
    /// - Parameter m21: The value to assign at row 2 column 1 of the matrix.
    /// - Parameter m22: The value to assign at row 2 column 2 of the matrix.
    /// - Parameter m31: The value to assign at row 3 column 1 of the matrix.
    /// - Parameter m32: The value to assign at row 3 column 2 of the matrix.
    public init(m11: Double, m12: Double, m21: Double, m22: Double, m31: Double, m32: Double) {
        self.m11 = m11
        self.m12 = m12
        self.m21 = m21
        self.m22 = m22
        self.m31 = m31
        self.m32 = m32
    }

    /// Initializes a new instance of the `Matrix2D` struct.
    ///
    /// - Parameter values: The values to assign to the components of the matrix.
    /// This must be an array with six elements, otherwise a runtime error is thrown
    public init(values: [Double]) {
        if values.count != 6 {
            fatalError("There must be six input values for Matrix3x2.")
        }

        m11 = values[0]
        m12 = values[1]

        m21 = values[2]
        m22 = values[3]

        m31 = values[4]
        m32 = values[5]
    }

    /// Creates an array containing the elements of the matrix.
    ///
    /// - Returns: A sixteen-element array containing the components of the matrix.
    public func toArray() -> [Double] {
        return [m11, m12, m21, m22, m31, m32]
    }

    /// Determines the sum of two matrices.
    ///
    /// - Parameter left: The first matrix to add.
    /// - Parameter right: The second matrix to add.
    public static func add(_ left: Matrix2D, _ right: Matrix2D) -> Matrix2D {
        let m11 = left.m11 + right.m11
        let m12 = left.m12 + right.m12
        let m21 = left.m21 + right.m21
        let m22 = left.m22 + right.m22
        let m31 = left.m31 + right.m31
        let m32 = left.m32 + right.m32

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Determines the difference between two matrices.
    ///
    /// - Parameter left: The first matrix to subtract.
    /// - Parameter right: The second matrix to subtract.
    public static func subtract(_ left: Matrix2D, _ right: Matrix2D) -> Matrix2D {
        let m11 = left.m11 - right.m11
        let m12 = left.m12 - right.m12
        let m21 = left.m21 - right.m21
        let m22 = left.m22 - right.m22
        let m31 = left.m31 - right.m31
        let m32 = left.m32 - right.m32

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Scales a matrix by the given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    public static func multiply(_ left: Matrix2D, _ right: Double) -> Matrix2D {
        let m11 = left.m11 * right
        let m12 = left.m12 * right
        let m21 = left.m21 * right
        let m22 = left.m22 * right
        let m31 = left.m31 * right
        let m32 = left.m32 * right

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Determines the product of two matrices.
    ///
    /// - Parameter left: The first matrix to multiply.
    /// - Parameter right: The second matrix to multiply.
    public static func multiply(_ left: Matrix2D, _ right: Matrix2D) -> Matrix2D {
        let m11 = left.m11 * right.m11 + left.m12 * right.m21
        let m12 = left.m11 * right.m12 + left.m12 * right.m22
        let m21 = left.m21 * right.m11 + left.m22 * right.m21
        let m22 = left.m21 * right.m12 + left.m22 * right.m22
        let m31 = left.m31 * right.m11 + left.m32 * right.m21 + right.m31
        let m32 = left.m31 * right.m12 + left.m32 * right.m22 + right.m32

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Scales a matrix by the given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale. Must be greater than zero
    public static func divide(_ left: Matrix2D, _ right: Double) -> Matrix2D {
        let inv = 1.0 / right

        let m11 = left.m11 * inv
        let m12 = left.m12 * inv
        let m21 = left.m21 * inv
        let m22 = left.m22 * inv
        let m31 = left.m31 * inv
        let m32 = left.m32 * inv

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Determines the quotient of two matrices.
    ///
    /// - Parameter left: The first matrix to divide.
    /// - Parameter right: The second matrix to divide.
    public static func divide(_ left: Matrix2D, _ right: Matrix2D) -> Matrix2D {
        let m11 = left.m11 / right.m11
        let m12 = left.m12 / right.m12
        let m21 = left.m21 / right.m21
        let m22 = left.m22 / right.m22
        let m31 = left.m31 / right.m31
        let m32 = left.m32 / right.m32

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Negates a matrix.
    ///
    /// - Parameter value: The matrix to be negated.
    public static func negate(_ value: Matrix2D) -> Matrix2D {
        let m11 = -value.m11
        let m12 = -value.m12
        let m21 = -value.m21
        let m22 = -value.m22
        let m31 = -value.m31
        let m32 = -value.m32

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Performs a linear interpolation between two matrices.
    ///
    /// Passing `amount` a value of 0 will cause `start` to be returned; a value
    /// of 1 will cause `end` to be returned.
    ///
    /// - Parameter start: Start matrix.
    /// - Parameter end: End matrix.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    public static func lerp(start: Matrix2D, end: Matrix2D, amount: Double) -> Matrix2D {
        let m11 = Matrix2D.lerp(from: start.m11, to: end.m11, amount: amount)
        let m12 = Matrix2D.lerp(from: start.m12, to: end.m12, amount: amount)
        let m21 = Matrix2D.lerp(from: start.m21, to: end.m21, amount: amount)
        let m22 = Matrix2D.lerp(from: start.m22, to: end.m22, amount: amount)
        let m31 = Matrix2D.lerp(from: start.m31, to: end.m31, amount: amount)
        let m32 = Matrix2D.lerp(from: start.m32, to: end.m32, amount: amount)

        return Matrix2D(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }

    /// Performs a cubic interpolation between two matrices.
    ///
    /// - Parameter start: Start matrix.
    /// - Parameter end: End matrix.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    public static func smoothStep(start: Matrix2D, end: Matrix2D, amount: Double) -> Matrix2D {
        let amount = smoothStep(amount)

        return lerp(start: start, end: end, amount: amount)
    }

    /// Creates a matrix that scales along the x-axis and y-axis.
    ///
    /// - Parameter scale: Scaling factor for both axes.
    public static func scaling(scale: Vector2D) -> Matrix2D {
        return scaling(x: Double(scale.x), y: Double(scale.y))
    }

    /// Creates a matrix that scales along the x-axis and y-axis.
    ///
    /// - Parameter x: Scaling factor that is applied along the x-axis.
    /// - Parameter y: Scaling factor that is applied along the y-axis.
    public static func scaling(x: Double, y: Double) -> Matrix2D {
        return Matrix2D(m11: x, m12: 0,
                        m21: 0, m22: y,
                        m31: 0, m32: 0)
    }

    /// Creates a matrix that uniformly scales along both axes.
    ///
    /// - Parameter scale: The uniform scale that is applied along both axes.
    public static func scaling(scale: Double) -> Matrix2D {
        return Matrix2D(m11: scale, m12: 0,
                        m21: 0, m22: scale,
                        m31: 0, m32: 0)
    }

    /// Creates a matrix that is scaling from a specified center.
    ///
    /// - Parameter x: Scaling factor that is applied along the x-axis.
    /// - Parameter y: Scaling factor that is applied along the y-axis.
    /// - Parameter center: The center of the scaling.
    public static func scaling(x: Double, y: Double, center: Vector2D) -> Matrix2D {
        return Matrix2D(m11: x, m12: 0,
                        m21: 0, m22: y,
                        m31: center.x - x * center.x, m32: center.y - y * center.y)
    }

    /// Calculates the determinant of this matrix.
    ///
    /// - Returns: Result of the determinant.
    public func determinant() -> Double {
        return m11 * m22 - m12 * m21
    }

    /// Creates a matrix that rotates.
    ///
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter result: When the method completes, contains the created
    /// rotation matrix.
    public static func rotation(angle: Double) -> Matrix2D {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)

        return Matrix2D(m11: cosAngle, m12: sinAngle,
                        m21: -sinAngle, m22: cosAngle,
                        m31: 0, m32: 0)
    }

    /// Creates a matrix that rotates about a specified center.
    ///
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter center: The center of the rotation.
    public static func rotation(angle: Double, center: Vector2D) -> Matrix2D {
        return translation(-center) * rotation(angle: angle) * translation(center)
    }

    /// Creates a transformation matrix.
    ///
    /// - Parameter xScale: Scaling factor that is applied along the x-axis.
    /// - Parameter yScale: Scaling factor that is applied along the y-axis.
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter xOffset: X-coordinate offset.
    /// - Parameter yOffset: Y-coordinate offset.
    public static func transformation(xScale: Double,
                                      yScale: Double,
                                      angle: Double,
                                      xOffset: Double,
                                      yOffset: Double) -> Matrix2D {

        return scaling(x: xScale, y: yScale)
            * rotation(angle: angle)
            * translation(x: xOffset, y: yOffset)
    }

    /// Creates a translation matrix using the specified offsets.
    ///
    /// - Parameter value: The offset for both coordinate planes.
    /// - Parameter result: When the method completes, contains the created
    /// translation matrix.
    public static func translation(_ value: Vector2D) -> Matrix2D {
        return translation(x: Double(value.x), y: Double(value.y))
    }

    /// Creates a translation matrix using the specified offsets.
    ///
    /// - Parameter x: X-coordinate offset.
    /// - Parameter y: Y-coordinate offset.
    public static func translation(x: Double, y: Double) -> Matrix2D {
        return Matrix2D(m11: 1, m12: 0,
                        m21: 0, m22: 1,
                        m31: x, m32: y)
    }

    /// Transforms a vector by this matrix.
    ///
    /// - Parameter matrix: The matrix to use as a transformation matrix.
    /// - Parameter point: The original vector to apply the transformation.
    /// - Returns: The result of the transformation for the input vector.
    @inlinable
    public static func transformPoint(matrix: Matrix2D, point: Vector2D) -> Vector2D {
        let x = point.x * matrix.m11 + point.y * matrix.m21 + matrix.m31
        let y = point.x * matrix.m12 + point.y * matrix.m22 + matrix.m32

        return Vector2D(x: x, y: y)
    }
    
    /// Transforms a vector by this matrix.
    ///
    /// - Parameter matrix: The matrix to use as a transformation matrix.
    /// - Parameter point: The original vector to apply the transformation.
    /// - Returns: The result of the transformation for the input vector.
    @inlinable
    public static func transformPoint(matrix: Matrix2D, point: Vector2F) -> Vector2F {
        return Vector2F(transformPoint(matrix: matrix, point: Vector2D(point)))
    }

    /// Calculates the inverse of this matrix instance.
    public func inverted() -> Matrix2D {
        return Matrix2D.invert(self)
    }

    /// Creates a skew matrix.
    ///
    /// - Parameter angleX: Angle of skew along the X-axis in radians.
    /// - Parameter angleY: Angle of skew along the Y-axis in radians.
    public static func skew(angleX: Double, angleY: Double) -> Matrix2D {
        return Matrix2D(m11: 1, m12: tan(angleX),
                        m21: tan(angleY), m22: 1,
                        m31: 0, m32: 0)
    }

    /// Calculates the inverse of the specified matrix.
    ///
    /// - Parameter value: The matrix whose inverse is to be calculated.
    /// - Parameter result: When the method completes, contains the inverse of the specified matrix.
    public static func invert(_ value: Matrix2D) -> Matrix2D {
        let determinant = value.determinant()

        if Matrix2D.isZero(determinant) {
            return identity
        }

        let invdet = 1.0 / determinant
        let offsetX = value.m31
        let offsetY = value.m32

        return Matrix2D(
            m11: value.m22 * invdet,
            m12: -value.m12 * invdet,
            m21: -value.m21 * invdet,
            m22: value.m11 * invdet,
            m31: (value.m21 * offsetY - offsetX * value.m22) * invdet,
            m32: (offsetX * value.m12 - value.m11 * offsetY) * invdet)
    }

    /// Adds two matrices.
    ///
    /// - Parameter left: The first matrix to add.
    /// - Parameter right: The second matrix to add.
    /// - Returns: The sum of the two matrices.
    public static func + (left: Matrix2D, right: Matrix2D) -> Matrix2D {
        return add(left, right)
    }

    /// Assert a matrix (return it unchanged).
    ///
    /// - Parameter value: The matrix to assert (unchanged).
    /// - Returns: The asserted (unchanged) matrix.
    public static prefix func + (value: Matrix2D) -> Matrix2D {
        return value
    }

    /// Subtracts two matrices.
    ///
    /// - Parameter left: The first matrix to subtract.
    /// - Parameter right: The second matrix to subtract.
    /// - Returns: The difference between the two matrices.
    public static func - (left: Matrix2D, right: Matrix2D) -> Matrix2D {
        return subtract(left, right)
    }

    /// Negates a matrix.
    ///
    /// - Parameter value: The matrix to negate.
    /// - Returns: The negated matrix.
    public static prefix func - (value: Matrix2D) -> Matrix2D {
        return negate(value)
    }

    /// Scales a matrix by a given value.
    ///
    /// - Parameter right: The matrix to scale.
    /// - Parameter left: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func * (left: Double, right: Matrix2D) -> Matrix2D {
        return multiply(right, left)
    }

    /// Scales a matrix by a given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func * (left: Matrix2D, right: Double) -> Matrix2D {
        return multiply(left, right)
    }

    /// Multiplies two matrices.
    ///
    /// - Parameter left: The first matrix to multiply.
    /// - Parameter right: The second matrix to multiply.
    /// - Returns: The product of the two matrices.
    public static func * (left: Matrix2D, right: Matrix2D) -> Matrix2D {
        return multiply(left, right)
    }

    /// Scales a matrix by a given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func / (left: Matrix2D, right: Double) -> Matrix2D {
        return divide(left, right)
    }

    /// Divides two matrices.
    /// - Parameter left: The first matrix to divide.
    /// - Parameter right: The second matrix to divide.
    /// - Returns: The quotient of the two matrices.
    public static func / (left: Matrix2D, right: Matrix2D) -> Matrix2D {
        return divide(left, right)
    }

    /// Interpolates between two values using a linear function by a given amount.
    ///
    /// - Remarks:
    /// See http://www.encyclopediaofmath.org/index.php/Linear_interpolation and
    /// http://fgiesen.wordpress.com/2012/08/15/linear-interpolation-past-present-and-future/
    ///
    /// - Parameter from: Value to interpolate from.
    /// - Parameter to: Value to interpolate to.
    /// - Parameter amount: Interpolation amount.
    /// - Returns: The result of linear interpolation of values based on the amount.
    private static func lerp(from: Double, to: Double, amount: Double) -> Double {
        return (1 - amount) * from + amount * to
    }

    /// Performs smooth (cubic Hermite) interpolation between 0 and 1.
    /// - Remarks:
    /// See https://en.wikipedia.org/wiki/Smoothstep
    /// - Parameter amount: Value between 0 and 1 indicating interpolation amount.
    private static func smoothStep(_ amount: Double) -> Double {
        return amount <= 0 ? 0
            : amount >= 1 ? 1
            : amount * amount * (3 - 2 * amount)
    }

    /// Determines whether the specified value is close to zero (0.0f).
    /// - Parameter a: The floating value.
    /// - Returns: `true` if the specified value is close to zero (0.0f);
    /// otherwise, `false`.
    private static func isZero(_ a: Double) -> Bool {
        let zeroTolerance = 1e-6

        return abs(a) < zeroTolerance
    }
}

public extension Matrix2D {
    @inlinable
    func transform(_ rect: Rectangle2D) -> Rectangle2D {
        var minimum = min(transform(rect.topLeft), transform(rect.topRight))
        minimum = min(minimum, transform(rect.bottomLeft))
        minimum = min(minimum, transform(rect.bottomRight))

        var maximum = max(transform(rect.topLeft), transform(rect.topRight))
        maximum = max(maximum, transform(rect.bottomLeft))
        maximum = max(maximum, transform(rect.bottomRight))

        return Rectangle2D(left: minimum.x, top: minimum.y, right: maximum.x, bottom: maximum.y)
    }

    @inlinable
    func transform(_ point: Vector2D) -> Vector2D {
        return point * self
    }

    @inlinable
    func transform(points: [Vector2D]) -> [Vector2D] {
        return points.map { $0 * self }
    }
}
