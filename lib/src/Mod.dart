import 'package:sdartistics/src/Parameter.dart';

/// A pre-determined list of supported operations.
enum Operation {
  AddRow,
}

/// A list of supported parameters.
enum ParameterType {
  RowData,
}

/// A [Mod] represents a single [Operation] which will be stored in a [ModStack].
/// All [Mod] will perform a validity check to determine whether it can be safely
/// executed. Setting [_isEnabled] will allow users to manually toggle the [Mod]
/// on and off.
class Mod {
  /// The type of [Operation] should remain constant.
  late final Operation _type;

  /// User-controlled setting of whether this [Mod] should be applied or not,
  /// this can be overwritten by [validity].
  bool _isEnabled = false;

  /// Store parameters to pass.
  List<Parameter> _parameters = [];

  /// Initialize a [Mod] with a [Operation] type.
  Mod(Operation operation) {
    _type = operation;
  }

  /// Test whether this [Mod] is valid by making sure all the required fields are
  /// completed.
  ///
  /// This not an indication that the [Mod] will behave as expected or to work
  /// at all when applied. It is simply a safety check to make sure there are
  /// no null values or other small but preventable issues.
  ///
  /// TODO: Implement a way to report the reasoning if validity returns false.
  bool validity() {
    switch (_type) {
      case Operation.AddRow:
        {
          if (_parameters.isNotEmpty) {
            return true;
          } else {
            return checkParameters();
          }
        }
    }
  }

  /// Checks the parameters that the [Mod] currently has.
  /// Note: This is not a check to see if the values are valid, but whether
  /// the type of the [Parameter] is what this [Operation] requires.
  ///
  /// TODO: Setup a constant dictionary somewhere to define the [ParameterType] requirements of every [Operation].
  bool checkParameters() {
    switch (_type) {
      case Operation.AddRow:
        {
          if (_parameters.length == 1) {
            if (_parameters.elementAt(0).type == ParameterType.RowData) {
              return true;
            } else {
              return false;
            }
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
