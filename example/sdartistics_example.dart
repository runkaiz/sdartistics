import 'package:sdartistics/sdartistics.dart';

Future<void> main() async {
  final df = await Table.fromCsv('example/datasets/incomplete.csv');
  print(df.rows);

  final ModStack testStack = ModStack("Test Stack");

  print(testStack.count);
}
