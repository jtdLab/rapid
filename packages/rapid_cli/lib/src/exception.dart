abstract class RapidException implements Exception {
  RapidException(this.message);

  final String message;

  @override
  String toString();
}
