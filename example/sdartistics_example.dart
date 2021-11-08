import 'package:sdartistics/sdartistics.dart';

Future<void> main() async {
  final df = await DataFrame.fromCsv('datasets/incomplete.csv', verbose: true);
  df.show();
  print(df.columns);
  print(df.countNulls_("variable_3"));
}