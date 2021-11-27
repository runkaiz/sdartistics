import 'package:sdartistics/src/Mod.dart';

/// The [Parameter] class make sures all the user inputs are valid when
/// setting up a [Mod].
///
/// Note: Currently this is the structure that I think is the best for
/// scalability. However, I have not tested this nor have anything idea how to
/// test this at the time of writing. Other parts of this library such as the
/// [ModStack] still needs work for this to be used correctly I believe.
class Parameter {
  late ParameterType _type;

  ParameterType get type => _type;
}

class RowDataParameter extends Parameter {
  @override
  ParameterType _type = ParameterType.RowData;
  late Map<String, Object> _rowValue;

  RowDataParameter.withRow(Map<String, Object> row) {
    _rowValue = row;
  }

  Map<String, Object> get rowValue => _rowValue;
}
