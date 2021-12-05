/// A class encapsulating read-only statistical graph functions.
class GraphData {
  /// Turn a list of data into a map to be graphed as histogram.
  /// If the the list is double, sort map by value.
  /// If the list is heterogenous, do not sort.
  static Map<String, int> histogram(List<dynamic> data) {
    Map<String, int> histogram = {};

    // Check if the list is numeric.
    if (data.every((d) => d is double)) {
      data.sort();
    }

    // Build the histogram map.
    for (var d in data) {
      if (d is double) {
        if (histogram.containsKey(d.toString())) {
          histogram[d.toString()] = histogram[d.toString()]! + 1;
        } else {
          histogram[d.toString()] = 1;
        }
      } else if (d is String) {
        if (histogram.containsKey(d)) {
          histogram[d] = histogram[d]! + 1;
        } else {
          histogram[d] = 1;
        }
      }
    }

    return histogram;
  }
}
