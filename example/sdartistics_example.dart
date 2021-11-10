import 'package:sdartistics/sdartistics.dart';

Future<void> main() async {
  final df = await Table.fromCsv('datasets/incomplete.csv');
  df.print();
}