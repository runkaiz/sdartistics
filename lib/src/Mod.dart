/// A pre-determined list of supported operations.
enum Operation {
  AddRow,
}

/// A [Mod] represents a single [Operation] which will be stored in a [ModStack].
/// All [Mod] will perform a validity check to determine whether it can be safely
/// executed. Setting [_isEnabled] will allow users to manually toggle the [Mod]
/// on and off.
class Mod {
  /// The type of [Operation] should remain constant.
  Operation _type;

  /// User-controlled setting of whether this [Mod] should be applied or not,
  /// this can be overwritten by [validity].
  bool _isEnabled = false;

  /// Store parameters to pass.
  /// TODO: There HAS to be a better way for this but I am sticking on the
  /// simple and yet stupid side for now.
  Map<String, Object> _row = {};

  /// Initialize a [Mod] with a [Operation] type.
  Mod(this._type) {
    _type = type;
  }

  /// Test whether this [Mod] is valid by making sure all the required fields are
  /// completed.
  ///
  /// This not an indication that the [Mod] will behave as expected or to work
  /// at all when applied. It is simply a safety check to make sure there are
  /// no null values or other small but preventable issues.
  ///
  /// TODO: Implement ways to report the reasoning if validity returns false.
  bool validity() {
    switch (_type) {
      case Operation.AddRow:
        {
          if (_row.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        }
    }
  }

  /// Set the enabled state of this [Mod]
  bool enable(bool enable) {
    _isEnabled = enable;

    return enable;
  }

  /// Returns the type of this Mod.
  Operation get type => _type;

  /// Get whether the user has enabled or disabled this [Mod].
  bool get isEnabled => _isEnabled;
}
