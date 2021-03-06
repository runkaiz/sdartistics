import 'package:dartaframe/dartaframe.dart';
import 'package:sdartistics/sdartistics.dart';
import 'package:sdartistics/src/Mod.dart';
import 'package:sdartistics/src/Statistics/CompareMeans.dart';
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

  group('Regression tests', () {
    test('Negative r', () {
      List<double> X = [15, 18, 21, 24, 27];
      List<double> Y = [25, 25, 27, 31, 32];

      // Find the size of array.
      int n = X.length;

      // Function call to correlationCoefficient.
      expect(PearsonCorrelation(X, Y, n).r, 0.9534625892455922);
      expect(Utils.roundDouble(PearsonCorrelation(X, Y, n).p, 3), 0.012);
    });

    test('Positive r', () {
      List<double> X = [15, 18, 21, 24, 27];
      List<double> Y = [-25, -25, -27, -31, -32];

      // Find the size of array.
      int n = X.length;

      // Function call to correlationCoefficient.
      expect(PearsonCorrelation(X, Y, n).r, -0.9534625892455922);
      expect(Utils.roundDouble(PearsonCorrelation(X, Y, n).p, 3), 0.012);
    });
  });

  group("Utilities tests", () {
    test('RoundDouble', () {
      expect(Utils.roundDouble(1.23456789, 1), equals(1.2));
      expect(Utils.roundDouble(1.23456789, 2), equals(1.23));
      expect(Utils.roundDouble(1.23456789, 3), equals(1.235));
      expect(Utils.roundDouble(1.23456789, 4), equals(1.2346));
      expect(Utils.roundDouble(1.23456789, 5), equals(1.23457));
      expect(Utils.roundDouble(1.23456789, 6), equals(1.234568));
      expect(Utils.roundDouble(1.23456789, 7), equals(1.2345679));
      expect(Utils.roundDouble(1.23456789, 8), equals(1.23456789));
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
      'range': 4.78,
      'mean': 0.8985,
      'median': 0.92,
      'median_odd': 2,
      'mode': [0.86, 0.75],
      'frequency': {
        1.00: 1,
        1.03: 1,
        1.42: 1,
        1.39: 1,
        2.10: 1,
        0.86: 2,
        0.98: 1,
        1.36: 1,
        1.38: 1,
        -0.65: 1,
        -0.20: 1,
        0.75: 2,
        -1.53: 1,
        1.62: 1,
        0.49: 1,
        0.51: 1,
        0.60: 1,
        3.25: 1
      },
      'variance': 0.97,
      'standardDeviation': 0.99,
      'skewness': -0.24,
      'kurtosis': 5.77,
      'excessKurtosis': 2.23,
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

    test('Test range', () {
      expect(SampleDescriptives.range(testList), testDescriptives['range']);
    });

    test('Test median', () {
      expect(_round(SampleDescriptives.median(testList)),
          testDescriptives['median']);
    });

    test('Test median_odd', () {
      expect(SampleDescriptives.median([1, 1, 2, 3, 5]),
          testDescriptives['median_odd']);
    });

    test('Test mode', () {
      expect(SampleDescriptives.mode(testList), testDescriptives['mode']);
    });

    test('Test frequency', () {
      expect(SampleDescriptives.frequency(testList),
          testDescriptives['frequency']);
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
      expect(_round(SampleDescriptives.excessKurtosis(testList)),
          testDescriptives['excessKurtosis']);
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

  group("Compare means tests", () {
    test('Test t_cdf', () {
      expect(Utils.roundDouble(t_cdf(4.14, 199), 3), equals(1.000));
    });

    test('One Sample T Test', () {
      var t = OneSampleTTest(23, 20, 4, 20);
      expect(Utils.roundDouble(t.meanDiff, 1), equals(-3.0));
      expect(Utils.roundDouble(t.p, 8), equals(0.00333284));
    });

    test('Two Sample T Test - equal variance', () {
      expect(
          Utils.roundDouble(
              TwoSampleTTest(29.5, 34, 13.17826, 24.83277, 4, 4).p, 7),
          equals(0.7597186));
    });

    test('Two Sample T Test - unequal variance', () {
      var t = TwoSampleTTest(29.5, 34, 13.17826, 24.83277, 4, 4, false);

      expect(Utils.roundDouble(t.meanDiff, 1), equals(-4.5));
      expect(Utils.roundDouble(t.df, 3), equals(4.566));
      expect(Utils.roundDouble(t.t, 3), equals(-0.320));
      expect(Utils.roundDouble(t.p, 3), equals(0.763));
    });

    test('Two Sample Paired T Test', () {
      var t = TwoSamplePairedTTest([31, 31, 12, 44], [56, 12, 55, 13]);

      expect(Utils.roundDouble(t.t, 3), equals(-0.256));
      expect(Utils.roundDouble(t.p, 3), equals(0.815));
      expect(Utils.roundDouble(t.stdErr, 3), equals(17.595));
    });

    test('WMW Test', () {
      var wmw = WMWTest([31, 31, 12, 44], [56, 12, 55, 13]);

      expect(wmw.n1, equals(4));
      expect(wmw.n2, equals(4));
      expect(Utils.roundDouble(wmw.u, 3), equals(6.50));
    });
  });
}
