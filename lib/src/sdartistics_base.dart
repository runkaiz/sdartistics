import 'package:dartaframe/dartaframe.dart';
import 'ModStack.dart';

/// A table to store all the user generated data, this should be able to be saved as a local document.
class Table {
  /// The data that existed when it was read the first time is saved, any modifications should not be applied immediately.
  final DataFrame _table;
  ModStack _stack = ModStack('Internal');

  /// Hidden initializer, one cannot create Tables without a CSV files for now.
  Table._(this._table);

  /// Initialize a Table with a CSV file.
  static Future<Table> fromCsv(String path, {bool verbose = false}) async =>
      Table._(await DataFrame.fromCsv(path, verbose: verbose));

  /// Output the content of [_table] in console.
  void print([int lines = 5]) {
    _table.show(lines);
  }

  // TODO: Revisit this when data manipulation stack is implemented.

  /// Get the length of the original values without the [_stack] being applied.
  int get length => _table.length;

  /// Get the names of columns of the original table without the [_stack] being applied.
  List<String> get columnsNames => _table.columnsNames;

  /// Get row data of [_table] without the [_stack] being applied.
  Iterable<Map<String, Object>> get rows => _table.rows;

  // TODO: Implement the data manipulation stack.
  void applyStack() {}
}

/// Checks if you are awesome. Spoiler: you are. DO NOT DELETE, at least for now.
class Awesome {
  bool get isAwesome => true;
}
