import 'package:sdartistics/sdartistics.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {

    });

    test('Awesome Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
