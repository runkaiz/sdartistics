/*
  This file is still underdevelopment & subject to change.
  DO NOT USE THIS FILE IN PRODUCTION. BREAKING CHANGES ARE VERY LIKELY.
  // TODO: Add a method to check / describe the assumption of tests.
*/

import 'dart:math';
import 'package:dartaframe/dartaframe.dart';
import 'package:sdartistics/sdartistics.dart';

/// A class to perform one-sample t-test.
///
/// The t-test is a statistical test used to compare the mean of two groups of data.
/// The null hypothesis is that the means of the two groups are equal.
class OneSampleTTest {
  late double mu; // Population mean
  late double mean; // Sample mean
  late double sd; // Sample standard deviation
  late double n; // Sample size

  /// Defines a new one-sample t-test.
  ///
  /// [expectedMean] is the expected mean of the population.
  OneSampleTTest(double expectedMean, double sampleMean, double sampleSd,
      double sampleSize) {
    this.mu = mu;
    this.mean = mean;
    this.sd = sd;
    this.n = n;
  }

  double get t => (mean - mu) / sd * sqrt(n);

  /// Two-tailed test
  double get p => 2 - 2 * t_cdf(t, (n - 1).abs());
  double get mean_diff => mean - mu;
}

/// A class to perform two-sample t-test.
///
/// The t-test is a statistical test used to compare the means of two groups of data.
/// The null hypothesis is that the means of the two groups are equal.
/// TODO: Swtich to Welch's t-test when variances are unequal.
class TwoSampleTTest {
  late double mean1; // Sample 1 mean
  late double mean2; // Sample 2 mean
  late double sd1; // Sample 1 standard deviation
  late double sd2; // Sample 2 standard deviation
  late double n1; // Sample 1 size
  late double n2; // Sample 2 size

  TwoSampleTTest(double mean1, double mean2, double sd1, double sd2, double n1,
      double n2) {
    this.mean1 = mean1;
    this.mean2 = mean2;
    this.sd1 = sd1;
    this.sd2 = sd2;
    this.n1 = n1;
    this.n2 = n2;
  }

  double get pooled_sd =>
      sqrt(((n1 - 1) * sd1 * sd1 + (n2 - 1) * sd2 * sd2) / (n1 + n2));

  double get t => (mean1 - mean2) / pooled_sd * sqrt(1 / n1 + 1 / n2);

  /// Two-tailed test
  double get p => 2 - 2 * t_cdf(t, (n1 + n2 - 2).abs());
  double get mean_diff => mean1 - mean2;
}

/// A class to pairend t-test.
///
/// The t-test is a statistical test used to compare the means of two groups of data.
/// The null hypothesis is that the means of the two groups are equal.
class TwoSamplePairedTTest {
  late double mean; // Mean of the sample of differences.
  late double sd; // Standard deviation of the sample of differences.
  late double n; // Number of pairs.

  TwoSampleTTest(double mean, double sd, double n) {
    this.mean = mean;
    this.sd = sd;
    this.n = n;
  }

  double get t => mean / sd * sqrt(n);
  double get p => 1 - t_cdf(t, (n - 1).abs());
  double get mean_diff => mean;
  double get std_err => sd / sqrt(n);
}

/// A class for Wilcoxon rank-sum tests.
///
/// WMW does not require the samples to be normally distributed or contain a large sample size.
class WMWTest {}
