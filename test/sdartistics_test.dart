import 'package:dartaframe/dartaframe.dart';
import 'package:sdartistics/sdartistics.dart';
import 'package:test/test.dart';

void main() {
  group('Random tests', () {
    final awesome = Awesome();

    setUp(() {

    });

    test('Awesome Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });

  group('Table tests', () {
    test('Test CSV data not found error', () async {
      await expectLater(Table.fromCsv('wrong/dir/to/file'), throwsA(isA<FileNotFoundException>()));
    });
    test('Test Table creation from CSV', () async {
      var df = await Table.fromCsv('test/datasets/incomplete.csv', verbose: true)
          ..print();
      expect(df.length, 3);
      expect(df.columnsNames, <String>['variable_1', 'variable_2', 'variable_3']);
      expect(df.rows.first, {'variable_1': 2, 'variable_2': 2, 'variable_3': 'null'});
    });
  });
}
