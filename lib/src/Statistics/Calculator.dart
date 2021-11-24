/// A class encapsulating read-only statistical calculations.
class Calculator {
  static double mean(List<double> input) {
    int count = input.length;
    double result = sum(input);

    result = result / count;

    return result;
  }

  static double sum(List<double> input) {
    double result = input.fold(0, (p, c) => p + c);

    return result;
  }

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
}
