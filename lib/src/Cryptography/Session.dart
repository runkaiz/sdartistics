import 'package:cryptography/cryptography.dart';

/// Only one instance of the [Session] is needed for each user for consistency
/// and avoid errors in generating extraneous keys.
class Session {
  /// By default the [Session] uses x25519, this can be furthered in the future.
  final _algorithm = Cryptography.instance.x25519();

  /// The default [SimpleKeyPair] to be used unless specified otherwise.
  late SimpleKeyPair defaultPair;

  Session() {}

  /// Generate a new keyPair, the user can decide whether they want to save it
  /// in the session and/or make it the default key. It would not be the default
  /// key if save is not set to true.
  Future<SimpleKeyPair> generateKeyPair(bool save) async {
    final keyPair = await _algorithm.newKeyPair();

    if (save) {
      defaultPair = keyPair;
    }

    return keyPair;
  }
}
