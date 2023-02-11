import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory.dart';

import 'file_system_entity.dart';

/// {@template file_system_entity_collection}
/// Abstraction of a collection of file system entities.
/// {@endtemplate}
abstract class FileSystemEntityCollection {
  /// {@macro file_system_entity_collection}
  FileSystemEntityCollection(List<FileSystemEntity> fileSystemEnties)
      : _fileSystemEnties = fileSystemEnties;

  final List<FileSystemEntity> _fileSystemEnties;

  /// Wheter ANY file system entity of this file system entity collection exists.
  bool existsAny() => _fileSystemEnties.any((e) => e.exists());

  /// Deletes the file system entity collection.
  void delete({required Logger logger}) {
    for (final fileSystemEntity in _fileSystemEnties) {
      if (fileSystemEntity.exists()) {
        fileSystemEntity.delete(logger: logger);
      }

      final parent = fileSystemEntity.parent;
      if (_shouldDeleteParent(parent)) {
        if (parent.exists()) {
          parent.delete(logger: logger);
        }
      }
    }
  }

  /// Wheter [parent] should be deleted.
  ///
  /// This is used to avoid unwanted empty directories.
  bool _shouldDeleteParent(Directory parent) =>
      parent.isEmpty &&
      !(parent.path.endsWith('test') ||
          parent.path.endsWith('lib') ||
          parent.path.endsWith('lib/src'));
}
