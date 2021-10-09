/// Describes the [orientation](https://en.wikipedia.org/wiki/Orientation_(vector_space))
/// of a vector space in 3 dimensions.
public enum Orientation3: Hashable {
    /// Specifies a [right-handed] orientation system.
    ///
    /// [right-handed]: https://en.wikipedia.org/wiki/Right-hand_rule
    case rightHanded

    /// Specifies a [left-handed] orientation system.
    ///
    /// [left-handed]: https://en.wikipedia.org/wiki/Right-hand_rule
    case leftHanded
}
