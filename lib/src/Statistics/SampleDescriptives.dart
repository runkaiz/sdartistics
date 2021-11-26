import 'dart:math';

/// A class encapsulating static statistical functions for sample datasets.
///
/// Example:
/// ```dart
///  var data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
///  var mean = SampleDescriptives.mean(data); // 5.5
/// ```
class SampleDescriptives {
  /// Returns the mean of a sample dataset.
  static double mean(List<double> input) {
    int count = input.length;
    double result = sum(input);

    result = result / count;

    return result;
  }

  /// Returns the sum of a sample dataset.
  static double sum(List<double> input) {
    double result = input.fold(0, (p, c) => p + c);

    return result;
  }

  /// Returns the minimum value of a sample dataset.
  static double min(List<double> input) {
    var smallestValue = input[0];

    for (var i = 0; i < input.length; i++) {
      // Checking for smallest value in the list
      if (input[i] < smallestValue) {
        smallestValue = input[i];
      }
    }

    return smallestValue;
  }

  /// Returns the maximum value of a sample dataset.
  static double max(List<double> input) {
    var largestValue = input[0];

    for (var i = 0; i < input.length; i++) {
      // Checking for largest value in the list
      if (input[i] > largestValue) {
        largestValue = input[i];
      }
    }

    return largestValue;
  }

  static double median(List<double> input) {
    var sortedList = input.toList();
    sortedList.sort();

    int count = sortedList.length;

    if (count % 2 == 0) {
      // Even number of elements
      double result =
          (sortedList[count ~/ 2] + sortedList[(count ~/ 2) - 1]) / 2;

      return result;
    } else {
      // Odd number of elements
      double result = sortedList[(count - 1) ~/ 2];

      return result;
    }
  }

  /// Returns the mode of a sample dataset.
  ///
  /// If there are no modes, return an empty list.
  static List<double> mode(List<double> input) {
    var counts = <double, int>{};
    var modes = <double>[];

    for (var i = 0; i < input.length; i++) {
      var value = input[i];
      if (counts.containsKey(value)) {
        counts[value] = counts[value]! + 1;
      } else {
        counts[value] = 1;
      }
    }

    var maxCount = 0;
    for (var value in counts.keys) {
      if (counts[value]! > maxCount) {
        maxCount = counts[value]!;
      }
    }

    for (var value in counts.keys) {
      if (counts[value] == maxCount) {
        modes.add(value);
      }
    }

    return modes;
  }

  /// Return a map of of original values (key) and their frequencies (value).
  static Map<dynamic, int> frequency(List<dynamic> input) {
    Map<dynamic, int> result = {};

    for (var i = 0; i < input.length; i++) {
      var value = input[i];
      if (result.containsKey(value)) {
        result[value] = result[value]! + 1;
      } else {
        result[value] = 1;
      }
    }

    return result;
  }

  /// Returns the variance of a sample dataset.
  static double variance(List<double> input) {
    double meanValue = mean(input);
    double result = 0;

    for (var i = 0; i < input.length; i++) {
      result += pow((input[i] - meanValue), 2);
    }

    result = result / (input.length - 1);

    return result;
  }

  /// Returns the standard deviation of a sample dataset.
  static double standardDeviation(List<double> input) {
    double meanValue = mean(input);
    double sumOfSquaredDifferences = 0.0;

    for (var i = 0; i < input.length; i++) {
      sumOfSquaredDifferences += pow((input[i] - meanValue), 2);
    }

    double result = sqrt(sumOfSquaredDifferences / (input.length - 1));

    return result;
  }

  /// Returns the coefficient of variation of a sample dataset.
  static double coefficientOfVariation(List<double> input) {
    double standardDeviationValue = standardDeviation(input);
    double meanValue = mean(input);
    double result = standardDeviationValue / meanValue;

    return result;
  }

  /// Returns the skewness of a sample dataset.
  static double skewness(List<double> input) {
    double meanValue = mean(input);
    double sd = standardDeviation(input);
    double result = 0;

    for (var i = 0; i < input.length; i++) {
      result += pow((input[i] - meanValue) / sd, 3);
    }

    double step_1 = input.length / (input.length - 1) * 1 / (input.length - 2);
    result = step_1 * result;

    return result;
  }

  /// Returns the kurtosis of a sample dataset.
  static double kurtosis(List<double> input) {
    double meanValue = mean(input);
    double sd = standardDeviation(input);
    double result = 0;

    for (var i = 0; i < input.length; i++) {
      result += pow((input[i] - meanValue) / sd, 4);
    }

    double step_1 = input.length /
        (input.length - 1) *
        (input.length + 1) /
        (input.length - 2) /
        (input.length - 3);
    result = step_1 * result;

    return result;
  }

  /// Returns the excess kurtosis  of a sample dataset.
  static double excessKurtosis(List<double> input) {
    double kurtosisValue = kurtosis(input);
    double result = 0;

    double step_1 = 3 *
        pow((input.length - 1), 2) /
        (input.length - 2) /
        (input.length - 3);

    result = kurtosisValue - step_1;

    return result;
  }

  /// Returns the standard error of the mean of a sample dataset.
  static double standardError(List<double> input) {
    double standardDeviationValue = standardDeviation(input);
    double result = standardDeviationValue / sqrt(input.length);

    return result;
  }
}
