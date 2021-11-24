import 'dart:ffi';

import 'package:dartaframe/dartaframe.dart';
import 'package:sdartistics/sdartistics.dart';
import 'package:sdartistics/src/Mod.dart';
import 'package:sdartistics/src/Statistics/Calculator.dart';
import 'package:test/test.dart';

void main() {
  group('Random tests', () {
    final awesome = Awesome();

    setUp(() {});

    test('Awesome Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });

  group('Table tests', () {
    test('Test CSV data not found error', () async {
      await expectLater(Table.fromCsv('wrong/dir/to/file'),
          throwsA(isA<FileNotFoundException>()));
    });
    test('Test Table creation from CSV', () async {
      var df =
          await Table.fromCsv('test/datasets/incomplete.csv', verbose: false);
      expect(df.length, 3);
      expect(
          df.columnsNames, <String>['variable_1', 'variable_2', 'variable_3']);
      expect(df.rows.first,
          {'variable_1': 2, 'variable_2': 2, 'variable_3': 'null'});
    });
  });

  group('Manipulation (Mod) Stack tests', () {
    final ModStack testStack = ModStack('Test Stack');

    setUp(() {
      testStack.clear();
    });

    test('Test stack counting when empty', () {
      expect(testStack.count, 0);
    });

    test('Test stack clear', () {
      testStack.push(Mod(Operation.AddRow));
      testStack.clear();
      expect(testStack.count, 0);
    });

    test('Test stack push', () {
      testStack.push(Mod(Operation.AddRow));
      expect(testStack.count, 1);
    });

    test('Test stack push & pop', () {
      testStack.push(Mod(Operation.AddRow));
      testStack.pop();
      expect(testStack.count, 0);
    });

    test('Test if stack is empty', () {
      expect(testStack.isEmpty, true);
    });
  });

  group('Test Mod', () {
    test('Test if a new Add Row Mod is invalid', () {
      final Mod newMod = Mod(Operation.AddRow);
      expect(newMod.validity(), false);
    });

    test('Test enable and disable toggle.', () {
      final Mod disableMod = Mod(Operation.AddRow);
      expect(disableMod.isEnabled, false);
      disableMod.enable(true);
      expect(disableMod.isEnabled, true);
    });

    test('Test getting the type of Mod.', () {
      final Mod typeMod = Mod(Operation.AddRow);
      expect(typeMod.type, Operation.AddRow);
    });
  });

  group('Calculator tests', () {
    List<double> testList = [1.2, 1.3, 1.4];

    test('Test sum', () {
      expect(Calculator.sum(testList), 3.9);
    });
    test('Test mean', () {
      expect(Calculator.mean(testList), 1.3);
    });
    test('Test min', () {
      expect(Calculator.min(testList), 1.2);
    });
    test('Test max', () {
      expect(Calculator.max(testList), 1.4);
    });
  });
}
