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
    test('Test CSV data not found', () async {
      await expectLater(Table.fromCsv('datasets/incomplete.csv'), throwsA(isA<FileNotFoundException>()));
    });
  });
}
