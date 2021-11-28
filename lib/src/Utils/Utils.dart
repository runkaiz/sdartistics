import 'dart:math';

/// A utilities class with some useful methods.
class Utils {
  /// Returns a number rounded to the Xth decimal place.
  static double roundDouble(double value, [int places = 1]) {
    num scale = pow(10, places);
    return (value * scale).round() / scale;
  }
}
