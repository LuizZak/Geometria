/// Wraps a vector and ensures that assignments are always stored as a unit
/// vector.
///
/// If attempting to store a vector with `.length == 0`, a runtime error is
/// raised.
@propertyWrapper
public struct UnitVector<Vector: VectorFloatingPoint> {
    @usableFromInline
    internal var _value: Vector
    
    /// Gets or sets the underlying vector value.
    ///
    /// When assigning a new value, the vector is first normalized before being
    /// assigned.
    ///
    /// - precondition: When asigning: `newValue.length > 0`
    public var wrappedValue: Vector {
        @_transparent
        get {
            _value
        }
        @_transparent
        set {
            precondition(_value.lengthSquared > 0, "Unit vectors must have length > 0")
            
            _value = newValue.normalized()
        }
    }
    
    /// Creates a new `UnitVector` with a given starting value.
    ///
    /// - Parameter wrappedValue: A vector to initialize this `UnitVector` with,
    /// which is normalized before being assigned.
    /// Value must have `length > 0`.
    ///
    /// - precondition: `wrappedValue.length > 0`
    @_transparent
    public init(wrappedValue: Vector) {
        precondition(wrappedValue.lengthSquared > 0, "Unit vectors must have length > 0")
        
        _value = wrappedValue.normalized()
    }
}

extension UnitVector: Equatable where Vector: Equatable, Vector.Scalar: Equatable { }
extension UnitVector: Hashable where Vector: Hashable, Vector.Scalar: Hashable { }
extension UnitVector: Encodable where Vector: Encodable, Vector.Scalar: Encodable { }
extension UnitVector: Decodable where Vector: Decodable, Vector.Scalar: Decodable { }
