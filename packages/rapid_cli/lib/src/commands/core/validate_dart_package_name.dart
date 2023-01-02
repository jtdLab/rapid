// The regex for a dart package name, i.e. no capital letters.
// https://dart.dev/guides/language/language-tour#important-concepts
final _packageRegExp = RegExp('[a-z_][a-z0-9_]*');

/// Whether [name] is valid project name.
bool isValidPackageName(String name) {
  final match = _packageRegExp.matchAsPrefix(name);
  return match != null && match.end == name.length;
}
