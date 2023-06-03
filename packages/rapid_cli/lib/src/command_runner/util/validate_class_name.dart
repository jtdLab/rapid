// The regex for a dart class name.
final _classNameRegExp = RegExp('[A-Z][a-zA-Z0-9]*');

/// Whether [name] is valid class name.
bool isValidClassName(String name) {
  final match = _classNameRegExp.matchAsPrefix(name);
  return match != null && match.end == name.length;
}
