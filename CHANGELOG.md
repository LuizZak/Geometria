# Changelog

## [main]

- Forcing `Vector3-` specializing protocols to require the same specialization on its `SubVector4`, e.g. `Vector3FloatingPoint` now requires `SubVector4: Vector4FloatingPoint`.

- Added `Vector3Multiplicative.tripleProduct` method.

- Forcing `Vector2-` specializing protocols to require the same specialization on its `SubVector3`, e.g. `Vector2FloatingPoint` now requires `SubVector3: Vector3FloatingPoint`.

- Added `Vector2Multiplicative.tripleProduct` method.

- Added `NSquare.vertices` when `NSquare.Vector` conforms to `VectorAdditive`.

- Added `LineCategory` bit-flag for `LineType` conformers that specifies the category of the line type (line, ray, or line segment).

- Added `PlaneIntersectablePlane2Type` to generalize line intersection of 1D planes (lines) in 2D spaces.

- Added `PlaneIntersectablePlane3Type` to generalize line intersection of 2D planes in 3D spaces.

## v0.0.2

- Added `Hyperplane` protocol to represent [hyperplanes](https://en.wikipedia.org/wiki/Hyperplane), along with proper type aliases for 2-, 3-, and 4-dimensional hyperplanes.

- Added `VectorTakeable` protocol, and making all vector protocols conform to it. With it, it's possible to index into a vector type to produce different vector types based on combinations of dimensions of a vector:

```swift
let vector = Vector3D(x: 3.5, y: 2.1, z: 1.0)

print(vector[.x, .z]) // Prints "(x: 3.5, y: 1.0)"
print(vector[.x, .z, .y]) // Prints "(x: 3.5, y: 1.0, z: 2.1)"
print(vector[.z, .y, .x]) // Prints "(x: 1.0, y: 2.1, x: 3.5)"
print(vector[.z, .y, .x, .z]) // Prints "(x: 1.0, y: 2.1, x: 3.5, w: 1.0)"
```

- Added `Vector<2/3/4>TakeDimensions` to accompany the `VectorTakeable` protocol and serve as a default conformance to `Vector<2/3/4>Type` protocols.

- Added `AdditiveRectangle.vertices` getter, which is automatically synthesized for any conforming type.

## v0.0.1

Initial release
