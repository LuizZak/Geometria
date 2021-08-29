/// Wraps a vector and ensures that assignments are always stored as a unit
/// vector.
///
/// If attempting to store a vector with `.length == 0`, a runtime error is
/// raised.
@propertyWrapper
public struct UnitVector<Vector: VectorFloatingPoint> {
    @usableFromInline
    internal var _value: Vector
    
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
