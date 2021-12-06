import 'dart:math';

import 'package:sdartistics/sdartistics.dart';

class PearsonCorrelation {
  late double r;
  late double t;
  late double p;

  PearsonCorrelation(List<double> X, List<double> Y, int n) {
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
    this.r = (n * sumXY - sumX * sumY) /
        (sqrt((n * squareSumX - sumX * sumX) * (n * squareSumY - sumY * sumY)));

    // calculate the t value
    this.t = (this.r * sqrt(n - 2)) / sqrt(1 - this.r * this.r);

    // calculate the p value
    this.p = 2 * t_cdf(-(this.t.abs()), n - 2);
  }
}
