import 'dart:math';
import 'package:dart_numerics/dart_numerics.dart'
    show betaRegularized, gammaLowerRegularized;
// This package was migrated to Null safety for beta & gamma functions only.
// Other functions are not yet tested and may crash the application.

/// A utilities class with some useful methods.
class Utils {
  /// Returns a number rounded to the Xth decimal place.
  static double roundDouble(double value, [int places = 1]) {
    num scale = pow(10, places);
    return (value * scale).round() / scale;
  }
}

/// Performs a omnibus test for the given data.
///
/// Returns the p-value of the test.
double omnibusTest(skewness, kurtosisExcess, n) {
  if (n < 20) {
    throw ArgumentError('Omnibus test requires at least 20 samples.');
  }

  var transformedSkewness;
  var y = skewness * sqrt(((n + 1) * (n + 3)) / (6 * (n - 2)));
  var beta2 = (3.0 *
      (pow(n, 2) + 27 * n - 70) *
      (n + 1) *
      (n + 3) /
      ((n - 2.0) * (n + 5) * (n + 7) * (n + 9)));
  var w2 = -1 + sqrt(2 * (beta2 - 1));
  var delta = 1 / sqrt(0.5 * log(w2));
  var alpha = sqrt(2.0 / (w2 - 1));
  var zS = delta * log(y / alpha + sqrt(pow(y / alpha, 2) + 1));

  var transformedKurtosisExcess;
  var e = 3.0 * (n - 1) / (n + 1);
  var varb2 =
      24.0 * n * (n - 2) * (n - 3) / ((n + 1) * (n + 1) * (n + 3) * (n + 5));
  var x = (varb2 - e) / sqrt(varb2);
  var sqrtbeta1 = 6.0 *
      (n * n - 5 * n + 2) /
      ((n + 7) * (n + 9)) *
      sqrt((6.0 * (n + 3) * (n + 5)) / (n * (n - 2) * (n - 3)));
  var a = 6.0 +
      8.0 /
          sqrtbeta1 *
          (2.0 / sqrtbeta1 + sqrt(1 + 4.0 / (sqrtbeta1 * sqrtbeta1)));
  var term1 = 1 - 2 / (9.0 * a);
  var denom = 1 + x * sqrt(2 / (a - 4.0));
  // Throw an error if the denominator is zero.
  if (denom == 0) {
    throw UnsupportedError(
        'Test statistic not defined in some cases due to division by zero.');
  }
  var term2 = pow((1 - 2.0 / a) / denom, 1 / 3.0);
  var zK = (term1 - term2) / sqrt(2 / (9.0 * a));

  var k2 = zS * zS + zK * zK;

  return chi_squared_cdf(k2, 2);
}

/// Calculate the cumulative distribution function for student's t distribution
double t_cdf(double t, double df) {
  if (df <= 0) {
    throw new ArgumentError("Degrees of freedom must be positive.");
  }

  if (t == 0) {
    return 0.5;
  }

  var t_sqrd = t * t;
  var x;
  var p;

  if (t < 0) {
    x = t_sqrd / (df + t_sqrd);
    p = 0.5 * (1 + betaRegularized(0.5, df / 2, x));
  } else {
    x = df / (df + t_sqrd);
    p = 0.5 * betaRegularized(df / 2.0, 0.5, x);
  }

  return (x > 0) ? 1 - p : p;
}

/// Calculate the cumulative distribution function for chi-squared distribution
double chi_squared_cdf(double t, double df) {
  if (df <= 0) {
    throw new ArgumentError("Degrees of freedom must be positive.");
  }

  return 1 - gammaLowerRegularized(df / 2, t / 2);
}
