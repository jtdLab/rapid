import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory.dart';

// TODO more protected

/// {@template file_system_entity}
/// Abstraction of a file system entity.
/// {@endtemplate}
abstract class FileSystemEntity {
  /// {@macro file_system_entity}

  /// The path of the file system entity.
  String get path;

  /// Wheter the file system entity exists.
  bool exists();

  /// The parent directory of the file system entity.
  Directory get parent;

  /// Deletes the file system entity.
  void delete({required Logger logger});
}
