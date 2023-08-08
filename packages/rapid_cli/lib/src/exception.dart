/// {@template rapid_exception}
/// Base class for all exceptions.
/// {@endtemplate}
abstract class RapidException implements Exception {
  /// {@macro rapid_exception}
  RapidException(this.message);

  /// A descriptive message describing the failure.
  final String message;

  @override
  String toString() => message;
}
