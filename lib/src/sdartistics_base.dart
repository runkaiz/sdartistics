import 'package:dartaframe/dartaframe.dart';

/// A table to store all the user generated data, this should be able to be saved as a local document.
class Table {
  /// The data that existed when it was read the first time is saved, any modifications should not be applied immediately.
  final DataFrame _table;

  /// Hidden initializer, one cannot create Tables without a CSV files for now.
  Table._(this._table);

  /// Initialize a Table with a CSV file.
  static Future<Table> fromCsv(String path, {bool verbose = false}) async => Table._(await DataFrame.fromCsv(path, verbose: verbose));

  /// Output the content of the table in console.
  void print([int lines = 5]) {
    _table.show(lines);
  }
}

/// Checks if you are awesome. Spoiler: you are. DO NOT DELETE, at least for now
class Awesome {
  bool get isAwesome => true;
}