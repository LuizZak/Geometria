/// Wraps a vector and ensures that assignments are always stored as a unit
/// vector.
///
/// If a vector with `.length == 0` is attempted to be stored, a zero-valued
/// vector is assigned instead and  ``isValid`` returns `false` until a new
/// valid vector is supplied.
@propertyWrapper
public struct UnitVector<Vector: VectorFloatingPoint> {
    @usableFromInline
    internal var _value: Vector
    
    /// Gets or sets the underlying vector value.
    ///
    /// When assigning a new value, the vector is first normalized before being
    /// assigned.
    ///
    /// If a vector with `.length == 0` is attempted to be stored, a zero-valued
    /// vector is assigned instead and  ``isValid`` returns `false` until a new
    /// valid vector is supplied.
    public var wrappedValue: Vector {
        @_transparent
        get {
            _value
        }
        @_transparent
        set {
            _value = newValue.normalized()
        }
    }
    
    /// Returns `true` if the underlying vector is a non-zero value.
    ///
    /// When assigning vectors of zero-length, this property returns `true`
    /// until another valid vector is assigned on ``wrappedValue``.
    @inlinable
    public var isValid: Bool {
        _value != .zero
    }
    
    /// Creates a new `UnitVector` with a given starting value.
    ///
    /// If a vector with `.length == 0` is attempted to be stored, a zero-valued
    /// vector is assigned instead and  ``isValid`` returns `false` until a new
    /// valid vector is supplied.
    ///
    /// - Parameter wrappedValue: A vector to initialize this `UnitVector` with,
    /// which is normalized before being assigned.
    /// Value must have `length > 0`.
    @_transparent
    public init(wrappedValue: Vector) {
        _value = wrappedValue.normalized()
    }
}

extension UnitVector: Equatable where Vector: Equatable, Vector.Scalar: Equatable { }
extension UnitVector: Hashable where Vector: Hashable, Vector.Scalar: Hashable { }
extension UnitVector: Encodable where Vector: Encodable, Vector.Scalar: Encodable { }
extension UnitVector: Decodable where Vector: Decodable, Vector.Scalar: Decodable { }
