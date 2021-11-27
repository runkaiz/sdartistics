import 'dart:collection';
import 'package:dartaframe/dartaframe.dart';

import './Mod.dart';

/// A [ModStack] stores a stack of [Mod] in order, making management, save,
/// duplication of the [Mod] stack to be easier and efficient. It would allow
/// complex operations to be applied to a [Table] without directly modifying the
/// original data. Another feature that [ModStack] has is to allow the result
/// to be accessible at any stage in time: it is possible get the resulting
/// [Table] as soon as the first [Mod] is sucessfully performed. This way one
/// can save troubleshooting time by verifying whether operations were correctly
/// configured without having to wait for the entire [ModStack] to complete.
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
