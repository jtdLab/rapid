import '../../utils.dart';

// TODO move to utils and share

/// Whether [name] is valid project name.
bool isValidPackageName(String name) {
  final match = dartPackageRegExp.matchAsPrefix(name);
  return match != null && match.end == name.length;
}
