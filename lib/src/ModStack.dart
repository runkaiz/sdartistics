import 'dart:collection';
import 'package:dartaframe/dartaframe.dart';

import './Mod.dart';

class ModStack {
  /// A user identifiable name for this stack of [Mod].
  final String name;
  Queue<Mod> _stack = Queue<Mod>();

  ModStack(this.name);

  /// Push a [Mod] to the stack.
  void push(Mod mod) {
    _stack.addLast(mod);
  }

  /// Pop, or remove the last [Mod] in the [ModStack] then returns it.
  Mod pop() {
    final Mod lastMod = _stack.last;
    _stack.removeLast();
    return lastMod;
  }

  /// Empties all [Mod] from [ModStack].
  void clear() {
    _stack.clear();
  }

  /// TODO: Implement applying the [ModStack]
  /// WARNING: Don't use this right now please.
  Future<DataFrame> apply() async {
    return DataFrame();
  }

  /// Returns true when [ModStack] is empty.
  bool get isEmpty => _stack.isEmpty;

  /// Returns the number of [Mod] saved in [ModStack].
  int get count => _stack.length;
}
