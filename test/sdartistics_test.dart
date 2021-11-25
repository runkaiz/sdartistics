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

  group('Descriptive statistics tests', () {
    double _round(double value) {
      return (value * 100).round() / 100;
    }

    List<double> testList = [
      1.00,
      1.03,
      1.42,
      1.39,
      2.10,
      0.86,
      0.98,
      1.36,
      0.86,
      1.38,
      -0.65,
      -0.20,
      0.75,
      -1.53,
      1.62,
      0.49,
      0.75,
      0.51,
      0.60,
      3.25
    ];

    Map<String, dynamic> testDescriptives = {
      'count': 20,
      'sum': 17.97,
      'max': 3.25,
      'min': -1.53,
      'mean': 0.8985,
      'median': 0.92,
      'mode': [0.86, 0.75],
      'variance': 0.97,
      'standardDeviation': 0.99,
      'skewness': -0.24,
      'kurtosis': 5.77,
      'kurtosisExcess': 2.23,
      'coefficientOfVariation': 1.10,
      'standardError': 0.22,
    };

    test('Test sum', () {
      expect(SampleDescriptives.sum(testList), testDescriptives['sum']);
    });
    test('Test mean', () {
      expect(SampleDescriptives.mean(testList), testDescriptives['mean']);
    });
    test('Test min', () {
      expect(SampleDescriptives.min(testList), testDescriptives['min']);
    });
    test('Test max', () {
      expect(SampleDescriptives.max(testList), testDescriptives['max']);
    });

    test('Test median', () {
      expect(_round(SampleDescriptives.median(testList)),
          testDescriptives['median']);
    });

    test('Test mode', () {
      expect(SampleDescriptives.mode(testList), testDescriptives['mode']);
    });

    test('Test variance', () {
      expect(_round(SampleDescriptives.variance(testList)),
          testDescriptives['variance']);
    });

    test('Test standard deviation', () {
      expect(_round(SampleDescriptives.standardDeviation(testList)),
          testDescriptives['standardDeviation']);
    });

    test('Test skewness', () {
      expect(_round(SampleDescriptives.skewness(testList)),
          testDescriptives['skewness']);
    });

    test('Test kurtosis', () {
      expect(_round(SampleDescriptives.kurtosis(testList)),
          testDescriptives['kurtosis']);
    });

    test('Test kurtosis excess', () {
      expect(_round(SampleDescriptives.kurtosisExcess(testList)),
          testDescriptives['kurtosisExcess']);
    });

    test('Test coefficient of variation', () {
      expect(_round(SampleDescriptives.coefficientOfVariation(testList)),
          testDescriptives['coefficientOfVariation']);
    });

    test('Test standard error', () {
      expect(_round(SampleDescriptives.standardError(testList)),
          testDescriptives['standardError']);
    });
  });
}
