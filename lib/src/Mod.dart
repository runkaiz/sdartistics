/// A pre-determined list of supported operations.
enum Operation {
  None,
  AddRow,
}

class Mod {
  /// The type of [Operation] should remain constant.
  Operation _type = Operation.None;

  /// User-controlled setting of whether this [Mod] should be applied or not, this can be overwritten by [validity].
  bool _isEnabled = false;

  /// Store parameters to pass.
  /// TODO: There HAS to be a better way for this but I am sticking on the simple and yet stupid side for now.
  Map<String, Object> _row = {};

  /// Initialize a [Mod] with a [Operation] type.
  Mod(Operation type) {
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
      case Operation.None:
        {
          return false;
        }
      default:
        {
          /// TODO: Set up a better way for debugging
          print(
              'This should NEVER appear unless the code is faulty in levels one cannot comprehend.');
          return false;
        }
    }
  }

  /// Returns the type of this Mod.
  Operation get type => _type;
  bool get isEnabled => _isEnabled;
}
