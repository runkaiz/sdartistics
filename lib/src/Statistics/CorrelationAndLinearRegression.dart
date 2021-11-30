import 'dart:math';

class CorrelationAndLinearRegression {
  // function that returns correlation coefficient.
  static double correlationCoefficient(List<double> X, List<double> Y, int n) {
    double sumX = 0, sumY = 0, sumXY = 0;
    double squareSumX = 0, squareSumY = 0;

    for (int i = 0; i < n; i++) {
      // sum of elements of array X.
      sumX = sumX + X[i];

      // sum of elements of array Y.
      sumY = sumY + Y[i];

      // sum of X[i] * Y[i].
      sumXY = sumXY + X[i] * Y[i];

      // sum of square of array elements.
      squareSumX = squareSumX + X[i] * X[i];
      squareSumY = squareSumY + Y[i] * Y[i];
    }

    // use Pearson's formula for calculating correlation
    // coefficient.
    double corr = (n * sumXY - sumX * sumY) /
        (sqrt((n * squareSumX - sumX * sumX) * (n * squareSumY - sumY * sumY)));

    return corr;
  }
}
