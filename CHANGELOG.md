# Changelog

## [main]

- Added `VectorTakeable` protocol, and making all vector protocols conform to it. With it, it's possible to index into a vector type to produce different vector types based on combinations of dimensions of a vector:

```swift
let vector = Vector3D(x: 3.5, y: 2.1, z: 1.0)

print(vector[.x, .z]) // Prints "(x: 3.5, y: 1.0)"
print(vector[.x, .z, .y]) // Prints "(x: 3.5, y: 1.0, z: 2.1)"
print(vector[.z, .y, .x]) // Prints "(x: 1.0, y: 2.1, x: 3.5)"
print(vector[.z, .y, .x, .z]) // Prints "(x: 1.0, y: 2.1, x: 3.5, w: 1.0)"
```

- Added `AdditiveRectangle.vertices` getter, which is automatically synthesized for any conforming type.

## v0.0.1

Initial release
