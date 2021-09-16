/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with double-precision floating-point
/// numbers.
public typealias Stadium2D = Stadium2<Vector2D>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with stadium-precision floating-point
/// numbers.
public typealias Stadium2F = Stadium2<Vector2F>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with integers.
public typealias Stadium2i = Stadium2<Vector2i>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius.
///
/// Typealias for `NCapsule<V>`, where `V` is constrained to ``Vector2Type``.
public typealias Stadium2<V: Vector2Type> = NCapsule<V>
