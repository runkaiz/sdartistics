import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jiffy/jiffy.dart';

import 'column.dart';
import 'exceptions.dart';
import 'info.dart';
import 'matrix.dart';
import 'type.dart';
import 'util/csv_parser.dart';

/// The main dataframe class
class DataFrame {
  /// Default constructor
  DataFrame();

  List<DataFrameColumn> _columns = <DataFrameColumn>[];
  final DataMatrix _matrix = DataMatrix();
  final _info = DataFrameInfo();

  //Map<int, String> _columnsIndices;

  // ***********************
  // Getters
  // ***********************

  // ********* data **********

  /// An iterable of rows data
  Iterable<Map<String, Object>> get rows => _iterRows();

  Iterable<List<Object?>> get _valueRows => _matrix.data;

  /// An iterable of rows of data where each row is a list containing null
  /// values for any unspecified columns.
  List<List<Object?>> get dataset => _valueRows.toList();

  set dataset(List<List<Object?>> dataPoints) => _matrix.data = dataPoints;

  // ********* info **********

  /// Number of rows og the data
  int get length => _matrix.data.length;

  /// The dataframe columns
  List<DataFrameColumn> get columns => _columns;

  /// The dataframe columns names
  List<String> get columnsNames =>
      List<String>.from(_columns.map<String>((c) => c.name));

  /// The dataframe columns indices
  List<String> get columnsIndices => _columnIndices();

  // ***********************
  // Constructors
  // ***********************

  /// Build a dataframe from a list of rows
  DataFrame.fromRows(List<Map<String, Object?>> rows)
      : assert(rows.isNotEmpty) {
    // create _columns from the first datapoint
    // TODO(caseycrogers): this will fail if the first row contains any null or unspecified values.
    //   Consider crawling the input for non-null values and/or having users explicitly specify types.
    rows[0].forEach((k, Object? v) {
      final t = v.runtimeType;
      _columns.add(DataFrameColumn(name: k, type: t));
    });
    // fill the data
    for (var row in rows) {
      _matrix.addRow(row, _columnIndices());
    }
  }

  static List<Object?> _parseVals(
      List<Object> vals, List<DataFrameColumn> columnsNames,
      {String? dateFormat,
      String? timestampCol,
      TimestampFormat? timestampFormat}) {
    var vi = 0;
    final colValues = <Object?>[];
    for (var v in vals) {
      // cast records to the right type
      switch (columnsNames[vi].type) {
        case int:
          colValues.add(int.tryParse(v.toString()));
          break;
        case double:
          colValues.add(double.tryParse(v.toString()));
          break;
        case DateTime:
          if (dateFormat != null) {
            colValues.add(Jiffy(v.toString(), dateFormat).dateTime);
          } else {
            if (timestampCol == columnsNames[vi].name) {
              DateTime? d;
              if (timestampFormat == TimestampFormat.seconds) {
                d = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(v.toString()) * 1000);
              } else if (timestampFormat == TimestampFormat.milliseconds) {
                d = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(v.toString()));
              } else if (timestampFormat == TimestampFormat.microseconds) {
                d = DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(v.toString()));
              }
              colValues.add(d);
            } else {
              colValues.add(DateTime.tryParse(v.toString()));
            }
          }
          break;
        default:
          if (v.toString() != "") {
              colValues.add(v);
          } else {
            colValues.add("null");
          }
      }
      ++vi;
    }
    return colValues;
  }

  /// Build a dataframe from a utf8 encoded stream of comma separated characters.
  ///
  /// Note that each element in Stream is a single string element, *NOT* a full
  /// line in the source csv.
  static Future<DataFrame> fromCharStream(Stream<String> charStream,
      {String? dateFormat,
      String? timestampCol,
      TimestampFormat timestampFormat = TimestampFormat.milliseconds,
      bool verbose = false}) async {
    final df = DataFrame();
    var i = 1;
    late List<String> _colNames;
    final parser = CsvParser(CharIter(charStream));
    // ignore: literal_only_boolean_expressions
    for (var vals = await parser.parseLine();
        vals != null;
        vals = await parser.parseLine()) {
      //print('line $i: $line');
      if (i == 1) {
        // set columns names
        _colNames = vals;
      } else {
        var vi = 0;
        if (i == 2) {
          for (var v in vals) {
            DataFrameColumn col;
            if (_colNames[vi] == timestampCol) {
              col = DataFrameColumn(name: _colNames[vi], type: DateTime);
            } else {
              col = DataFrameColumn.inferFromRecord(v, _colNames[vi],
                  dateFormat: dateFormat);
            }
            df._columns.add(col);
            ++vi;
          }
        }
        final colValues = _parseVals(vals, df._columns,
            dateFormat: dateFormat,
            timestampCol: timestampCol,
            timestampFormat: timestampFormat);
        df._matrix.data.add(colValues);
      }
      i++;
    }
    if (verbose) {
      print('Parsed ${df._matrix.data.length} rows');
    }
    return df;
  }

  /// Build a dataframe from a csv file
  static Future<DataFrame> fromCsv(String path,
      {String? dateFormat,
      String? timestampCol,
      TimestampFormat timestampFormat = TimestampFormat.milliseconds,
      bool verbose = false}) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileNotFoundException('File not found: $path');
    }

    return fromCharStream(
      file
          .openRead()
          .transform<String>(utf8.decoder)
          // Split by newline and then add the newlines back in as a hacky way
          // to remove platform specific line breaks and to add a newline to the
          // final line if it didn't already have one (this is optional according
          // to the csv standard but required by the csv parser).
          .transform<String>(const LineSplitter())
          .map((line) => (line + '\n').split(''))
          .expand((lst) => lst),
      dateFormat: dateFormat,
      timestampCol: timestampCol,
      timestampFormat: timestampFormat,
      verbose: verbose,
    );
  }

  DataFrame._copyWithMatrix(DataFrame df, List<List<Object?>> matrix) {
    _columns = df._columns;
    _matrix.data = matrix;
  }

  // ***********************
  // Methods
  // ***********************

  // ********* select operations **********

  /// Limit the dataframe to a subset of data
  List<Map<String, Object>> subset(int startIndex, int endIndex) {
    final data =
        _matrix.rowsForIndexRange(startIndex, endIndex, _columnIndices());
    _matrix.data = _matrix.data.sublist(startIndex, endIndex);
    return data;
  }

  /// Get a new dataframe with a subset of data
  DataFrame subset_(int startIndex, int endIndex) {
    final _newMatrix = _matrix.data.sublist(startIndex, endIndex);
    return DataFrame._copyWithMatrix(this, _newMatrix);
  }

  /// Get typed records for a column
  List<T?> colRecords<T>(String colName, {int? offset, int? limit}) =>
      _matrix.typedRecordsForColumnIndex<T>(_indexForColumn(colName),
          offset: offset, limit: limit);

  // ********* filter operations **********

  /// Limit the data
  void limit(int max, {int startIndex = 0}) {
    var n = startIndex + max;
    final dflen = _matrix.data.length;
    if (n > dflen) {
      if (startIndex == 0) {
        return;
      }
      n = dflen;
    }
    _matrix.data = _matrix.data.sublist(startIndex, n);
  }

  /// Get a new dataframe with limited data
  DataFrame limit_(int max, {int startIndex = 0}) {
    var n = startIndex + max;
    final dflen = _matrix.data.length;
    if (n > _matrix.data.length) {
      if (startIndex == 0) {
        return this;
      }
      n = dflen;
    }
    final _newMatrix = _matrix.data.sublist(startIndex, n);
    return DataFrame._copyWithMatrix(this, _newMatrix);
  }

  // ********* count operations **********

  /// Count null values
  ///
  /// It is possible to provide a custom list of values
  /// considered as null with [nullValues]
  int countNulls_(String colName,
      {List<Object?> nullValues = const [null, 'null', 'nan', 'NULL', 'N/A']}) {
    final n = _matrix.countForValues(_indexForColumn(colName), nullValues);
    return n;
  }

  /// Count zero values
  ///
  /// It is possible to provide a custom list of values
  /// considered as zero with [zeroValues]
  int countZeros_(String colName,
      {List<Object> zeroValues = const <Object>[0]}) {
    final n = _matrix.countForValues(_indexForColumn(colName), zeroValues);
    return n;
  }

  /// Count missing data in a table
  DataFrame countMissingData_({List<Object?> nullValues = const [null, 'null', 'nan', 'NULL', 'N/A']}) {
    final DataFrame result = copy_();
    result.limit(0, startIndex: 0);
    final Map<String, Object> countRow = {};

    for (String name in columnsNames) {
      int c = countNulls_(name);
      countRow[name] = c;
    }

    result.addRow(countRow);

    return result;
  }

  // ********* insert operations **********

  /// Add a row to the data
  void addRow(Map<String, Object> row) => _matrix.addRow(row, _columnIndices());

  /// Add a line of records to the data
  void addRecords(List<Object> records) => _matrix.data.add(records);

  // ********* delete operations **********

  /// Remove a row at a given index position
  void removeRowAt(int index) => _matrix.data.removeAt(index);

  /// Remove the first row
  void removeFirstRow() => _matrix.data.removeAt(0);

  /// Remove the last row
  void removeLastRow() => _matrix.data.removeLast();

  // ********* dataframe operations **********

  /// Get a copy of a dataframe
  DataFrame copy_() => DataFrame._copyWithMatrix(this, _matrix.data);

  /// Set the dataframe columns
  ///
  /// Use this in constructors if you extend the [Df] class
  /// to set initial columns
  void setColumns(List<DataFrameColumn> cols) => _columns.addAll(cols);

  // ********* calculations **********

  /// Sum of a column
  double sum_(String colName) => _matrix.sumCol(_indexForColumn(colName));

  /// Mean of a column
  double mean_(String colName, {required NullMeanBehavior nullAggregation}) =>
      _matrix.meanCol(_indexForColumn(colName), nullBehavior: nullAggregation);

  /// Get the max value of a column
  double max_(String colName) => _matrix.maxCol(_indexForColumn(colName));

  /// Get the min value of a column
  double min_(String colName) => _matrix.minCol(_indexForColumn(colName));

  // ********* info **********

  /// Print sample data
  void head([int lines = 5]) {
    var l = lines;
    if (length < lines) {
      l = length;
    }
    final rows = _matrix.data.sublist(0, l);
    _info.printRows(rows);
    print('$length rows');
  }

  /// Print info and sample data
  void show([int lines = 5]) {
    print(
        '${_columns.length} columns and $length rows: ${columnsNames.join(', ')}');
    var l = lines;
    if (length < lines) {
      l = length;
    }
    final rows = _matrix.data.sublist(0, l);
    _info.printRows(rows);
  }

  /// Print columns info
  void cols() => _info.colsInfo(columns: _columns);

  /// Get the index of a column
  int columnIndex(String colName) => _indexForColumn(colName);

  // ***********************
  // Internal methods
  // ***********************

  Iterable<Map<String, Object>> _iterRows() sync* {
    var i = 0;
    while (i < _matrix.data.length) {
      yield _matrix.rowForIndex(i, _columnIndices());
      i++;
    }
  }

  /// Get a new dataframe sorted by a column.
  ///
  /// By default, rows are ordered by calling [Comparable.compare] on column
  /// values and nulls are handled according to the specified [NullSortBehavior].
  /// To customize sorting, you can either use your own [Comparable] as column
  /// values or specify a custom compare function.
  /// Sort_ does not guarantee a stable sort order.
  ///
  /// Note that `nullBehavior` and `compare` are mutually exclusive arguments.
  /// Custom compare functions must handle nulls appropriately.
  DataFrame sort_(String colName,
          {NullSortBehavior? nullBehavior, CompareFunction? compare}) =>
      DataFrame._copyWithMatrix(
        this,
        _sort(colName,
            inPlace: false, nullBehavior: nullBehavior, compare: compare),
      );

  /// In-place sort this dataframe by a column.
  ///
  /// By default, rows are ordered by calling [Comparable.compare] on column
  /// values and nulls are handled according to the specified [NullSortBehavior].
  /// To customize sorting, you can either use your own [Comparable] as column
  /// values or specify a custom compare function.
  /// Sort does not guarantee a stable sort order.
  ///
  /// Note that `nullBehavior` and `compare` are mutually exclusive arguments.
  /// Custom compare functions must handle nulls appropriately.
  void sort(String colName,
          {NullSortBehavior? nullBehavior, CompareFunction? compare}) =>
      _sort(colName,
          inPlace: true, nullBehavior: nullBehavior, compare: compare);

  List<List<Object?>> _sort(String colName,
      {required bool inPlace,
      NullSortBehavior? nullBehavior,
      CompareFunction? compare}) {
    if ((nullBehavior == null && compare == null) ||
        (nullBehavior != null && compare != null)) {
      throw ArgumentError(
          'You must specify either a null sort behavior, or a compare function.');
    }
    final newMatrixData = inPlace
        ? _matrix.data
        // Deep copy the rows.
        : _matrix.data.map((row) => List<Object?>.from(row)).toList();
    return newMatrixData
      ..sort((a, b) =>
          _compareRows(a, b, columnIndex(colName), nullBehavior, compare));
  }

  int _compareRows(List<Object?> rowA, List<Object?> rowB, int index,
      NullSortBehavior? nullBehavior, CompareFunction? compare) {
    final recordA = _matrix.typedRecordForColumnIndexInRow<Comparable<Object>?>(
        index, rowA);
    final recordB = _matrix.typedRecordForColumnIndexInRow<Comparable<Object>?>(
        index, rowB);
    if (compare != null) {
      return compare(recordA, recordB);
    }
    // Need to resolve null cases before calling compareTo.
    if (recordA == null && recordB == null) return 0;
    if (recordA == null) return nullBehavior == NullSortBehavior.first ? -1 : 1;
    if (recordB == null) return nullBehavior == NullSortBehavior.first ? 1 : -1;
    return Comparable.compare(recordA, recordB);
  }

  int _indexForColumn(String colName) {
    var i = 0;
    for (final col in _columns) {
      if (colName == col.name) {
        return i;
      }
      i++;
    }
    throw ColumnNotFoundException('Can not find column $colName');
  }

  List<String> _columnIndices() => columns.map((c) => c.name).toList();
}

/// A function that compares two objects for sorting. It will return -1 if a
/// should be ordered before b, 0 if a and b are equal wrt to ordering, and 1
/// if a should be ordered after b.
typedef CompareFunction = int Function(Object? a, Object? b);

/// How to treat nulls when taking the average over a column.
enum NullMeanBehavior {
  /// Skip null values.
  ///   eg mean(1, 2, null) => (1 + 2) / 2.0 => 1.5
  skip,

  /// Convert null values to zero.
  ///   eg mean(1, 2, null) => (1 + 1 + 0) / 3.0 => 1
  zero,
}

/// How to treat nulls when sorting a data frame by a particular column.
enum NullSortBehavior {
  /// Order null values before all other values.
  ///   eg sort(-1, 1, null) => null, -1, 1
  first,

  /// Order null values after all other values.
  ///   eg sort(-1, 1, null) => -1, 1, null,
  last,
}
