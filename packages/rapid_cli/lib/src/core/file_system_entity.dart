import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory.dart';

/// {@template file_system_entity}
/// Base class of any file system entity.
/// {@endtemplate}
abstract class FileSystemEntity {
  /// The path of the file system entity.
  String get path;

  /// Wheter the file system entity exists.
  bool exists();

  /// The parent directory of the file system entity.
  Directory get parent;

  /// Deletes the file system entity.
  void delete({required Logger logger});
}
