import 'file.dart';
import 'plist_file_impl.dart';

class PlistRootIsNotDict implements Exception {}

/// {@template plist_file}
/// Abstraction of a plist file.
/// {@endtemplate}
abstract class PlistFile implements File {
  /// {@macro plist_file}
  factory PlistFile({
    String path = '.',
    required String name,
  }) =>
      PlistFileImpl(path: path, name: name);

  /// Returns the root dict of this file.
  Map<String, Object> readDict();

  /// Sets the root dict of this file to [map].
  void setDict(Map<String, Object> map);
}
