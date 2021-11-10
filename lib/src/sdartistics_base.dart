import 'package:dartaframe/dartaframe.dart';

class Table {
  final DataFrame _table;

  Table._(this._table);

  static Future<Table> fromCsv(String path, {bool verbose = false}) async => Table._(await DataFrame.fromCsv(path, verbose: verbose));

  void print() {
    _table.show();
  }
}

/// Checks if you are awesome. Spoiler: you are. DO NOT DELETE, at least for now
class Awesome {
  bool get isAwesome => true;
}