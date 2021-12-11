/*
  This file is still underdevelopment & subject to change.
  DO NOT USE THIS FILE IN PRODUCTION. BREAKING CHANGES ARE VERY LIKELY.
  TODO: Better documentation and references to clarify the assumptions and appropriate use cases for each of the tests.
*/

import 'dart:math';
import 'package:sdartistics/sdartistics.dart';

/// A class to perform one-sample t-test.
///
/// The t-test is a statistical test used to compare the mean of two groups of data.
/// The null hypothesis is [mu] - [mean] = 0.
class OneSampleTTest {
  /// The mean of the population from which the sample was drawn.
  late double mu;

  /// The mean of the sample.
  late double mean;

  /// The standard deviation of the sample.
  late double sd;

  /// Sample Size.
  late double n;

  /// The t-statistic.
  double get t => (mean - mu) / sd * sqrt(n);

  /// The p-value (two-tailed).
  double get p => 2 * (t_cdf(-(t.abs()), n - 1));
  double get meanDiff => mean - mu;

  /// Defines a new one-sample t-test.
  ///
  /// [expectedMean] is the mean of the population from which the sample was drawn.
  /// [sampleSd] is the standard deviation of the sample.
  ///
  /// Example:
  /// ```dart
  /// // Create a new t-test.
  /// OneSampleTTest tTest = OneSampleTTest(23, 20, 4, 20);
  /// // Optional: update properties of the test after creation.
  /// tTest.mu = 25;
  /// // Get the results.
  /// double t = tTest.t;
  /// double p = tTest.p;
  /// ```
  OneSampleTTest(double expectedMean, double sampleMean, double sampleSd,
      double sampleSize) {
    this.mu = expectedMean;
    this.mean = sampleMean;
    this.sd = sampleSd;
    this.n = sampleSize;
  }
}

/// A class to perform two-sample t-test.
///
/// The t-test is a statistical test used to compare the means of two groups of data.
/// The null hypothesis is [mean1] - [mean2] = 0.
class TwoSampleTTest {
  /// The mean of the first sample.
  late double mean1;

  /// The mean of the second sample.
  late double mean2;

  /// The standard deviation of the first sample.
  late double sd1;

  /// The standard deviation of the second sample.
  late double sd2;

  /// Sample size of the first sample.
  late double n1;

  /// Sample size of the second sample.
  late double n2;

  /// When the two samples has different **population** variances, the t-test will perform a Welch's t-test.
  late bool equalPopulationVariances;

  /// The t-statistic.
  ///
  /// When [equalPopulationVariances] is `true`, this is the t-statistic of Student's t-test.
  /// When it is `false`, this is the t-statistic of Welch's t-test.
  double get t => _t();

  /// The degrees of freedom.
  ///
  /// When [equalPopulationVariances] is `true`, this is will be `n1 + n2 - 2`.
  /// When it is `false`, this is will be calculated using the Welch-Satterthwaite equation for Welch's t-test.
  double get df => _df();

  /// The p-value (two-tailed).
  double get p => 2 * t_cdf(-(t.abs()), df);

  /// The difference between the means of the two samples.
  double get meanDiff => mean1 - mean2;

  /// The pooled standard deviation for Student's t-test.
  double get _pooled_sd =>
      sqrt(((n1 - 1) * sd1 * sd1 + (n2 - 1) * sd2 * sd2) / (n1 + n2 - 2));

  /// Creates a new two-sample t-test.
  ///
  /// [equalPopulationVariances] is `true` when the two samples has the same **population** variances. Set it to `false` if you are not sure.
  /// [sd1] is the standard deviation of the first sample.
  /// [n2] is the sample size of the second sample.
  /// Same for other parameters.
  ///
  /// Example:
  /// ```dart
  /// // Create a new t-test without assuming the two samples has the same population variances.
  /// TwoSampleTTest tTest = TwoSampleTTest(29.5, 34, 13.17826, 24.83277, 4, 4, false);
  /// // Optional: update properties of the test after creation.
  /// tTest.mean1 = 30;
  /// // Get the results.
  /// double df = tTest.df;
  /// double t = tTest.t;
  /// double p = tTest.p;
  /// ```
  TwoSampleTTest(
      double mean1, double mean2, double sd1, double sd2, double n1, double n2,
      [bool equalPopulationVariances = true]) {
    this.mean1 = mean1;
    this.mean2 = mean2;
    this.sd1 = sd1;
    this.sd2 = sd2;
    this.n1 = n1;
    this.n2 = n2;
    this.equalPopulationVariances = equalPopulationVariances;
  }

  /// Returns either Student's t-test or Welch's t-test.
  double _t() {
    if (equalPopulationVariances) {
      return (mean1 - mean2) / (_pooled_sd * sqrt(1 / n1 + 1 / n2));
    } else {
      return (mean1 - mean2) / (sqrt(sd1 * sd1 / n1 + sd2 * sd2 / n2));
    }
  }

  /// Returns the degrees of freedom for Student's t-test or Welch's t-test.
  double _df() {
    if (equalPopulationVariances) {
      return n1 + n2 - 2;
    } else {
      var term1 = pow((sd1 * sd1 / n1 + sd2 * sd2 / n2), 2);
      var denom = (pow(sd1 * sd1 / n1, 2) / (n1 - 1)) +
          (pow(sd2 * sd2 / n2, 2) / (n2 - 1));
      return term1 / denom;
    }
  }
}

/// A class to perform paired t-test.
///
/// This test is used one one sample has been tested twice or two samples have been paired together.
/// Paired t-test is algebricly equivalent to a one-sample t-test, just that the meaning of parameters is different.
///
/// The t-test is a statistical test used to compare the means of two groups of data.
/// The null hypothesis is that the mean differences between the two groups are equal, or [meanOfDiff] = 0.
class TwoSamplePairedTTest {
  /// The mean of the difference between the two paired samples / groups of data.
  late double meanOfDiff;

  /// The standard deviation of the difference between the two paired samples / groups of data.
  late double sdOfDiff;

  /// The the number of pairs / groups.
  late int n;

  /// The t-statistic.
  double get t => meanOfDiff / sdOfDiff * sqrt(n);

  /// The p-value (two-tailed).
  double get p => 2 * t_cdf(-(t.abs()), n - 1);

  /// The standard error of the mean difference between the two paired samples / groups of data.
  double get stdErr => sdOfDiff / sqrt(n);

  /// Creates a new paired t-test.
  ///
  /// [meanOfDiff] is the mean of the difference between the two paired samples / groups of data.
  /// [sdOfDiff] is the standard deviation of the difference between the two.
  /// [n] is the number of pairs / groups.
  TwoSamplePairedTTest(List<double> sample1, List<double> sample2) {
    List<double> diffs = [];
    for (int i = 0; i < sample1.length; i++) {
      diffs.add(sample1[i] - sample2[i]);
    }

    this.meanOfDiff = SampleDescriptives.mean(diffs);
    this.sdOfDiff = SampleDescriptives.standardDeviation(diffs);
    this.n = diffs.length;
  }
}

/// A class to perform Wilcoxon-Mann-Whitney U-test.
///
/// The Wilcoxon-Mann-Whitney U-test is a non-parametric statistical test used to compare two i.i.d. samples.
/// The null hypothesis is that the two samples have the same distribution.
///
/// The test is sometimes called the Mann-Whitney U-test, Wilcoxon rank-sum test, or Mann-Whitney-Wilcoxon test.
/// We are referring to it as the WMW because it is what is used in a popular social science statistical software.
class WMWTest {
  late int n1;
  late int n2;
  late double meanRank1;
  late double meanRank2;
  late double r1;
  late double r2;
  late double u1;
  late double u2;
  get u => u1 < u2 ? u1 : u2;

  WMWTest(List<double> sample1, List<double> sample2) {
    n1 = sample1.length;
    n2 = sample2.length;

    // [[sampleGroup, value, rank]]
    List<List<double>> samples = [];

    for (int i = 0; i < sample1.length; i++) {
      samples.add(
        [1, sample1[i], 1],
      );
    }
    for (int i = 0; i < sample2.length; i++) {
      samples.add([2, sample2[i], 1]);
    }

    // Sort the samples by value.
    samples.sort((a, b) => a[1].compareTo(b[1]));

    // Fractional ranking.
    // TODO: Clean up this indexing nightmare.
    for (int i = 1; i < samples.length; i++) {
      var currentValue = samples[i][1];
      var lowerIndex = i;
      while (lowerIndex > 0 && currentValue == samples[lowerIndex - 1][1]) {
        lowerIndex--;
      }
      var unadjustedRanks = List.generate(
          (i - lowerIndex + 1), (int index) => lowerIndex + index + 1.0);
      var adjustedRankValue = SampleDescriptives.mean(unadjustedRanks);
      for (int j = i; j >= (unadjustedRanks[0] - 1); j--) {
        samples[j][2] = adjustedRankValue;
      }
    }

    // Calculate the mean ranks.
    meanRank1 = SampleDescriptives.mean(
        samples.where((s) => s[0] == 1).map((s) => s[2]).toList());
    meanRank2 = SampleDescriptives.mean(
        samples.where((s) => s[0] == 2).map((s) => s[2]).toList());

    // Calculate the sum of ranks.
    r1 = SampleDescriptives.sum(
        samples.where((s) => s[0] == 1).map((s) => s[2]).toList());
    r2 = SampleDescriptives.sum(
        samples.where((s) => s[0] == 2).map((s) => s[2]).toList());

    // Calculate the U statistic.
    u1 = r1 - (n1 * (n1 + 1)) / 2;
    u2 = r2 - (n2 * (n2 + 1)) / 2;
  }
}

class WilcoxonSignedRanksTest {}
