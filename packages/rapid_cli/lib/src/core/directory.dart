import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/file.dart';

import 'file_system_entity.dart';

// TODO more protected

/// {@template directory}
/// Abstraction of a directory.
/// {@endtemplate}
class Directory extends FileSystemEntity {
  /// {@macro directory}
  Directory({
    String path = '.',
  }) : _directory = io.Directory(
          p.normalize(p.join(path)),
        );

  /// The underlying directory.
  final io.Directory _directory;

  /// The path of the directory.
  @override
  String get path => _directory.path;

  /// Wheter the directory exists.
  @override
  bool exists() => _directory.existsSync();

  List<FileSystemEntity> list({bool recursive = false}) => _directory
      .listSync(recursive: recursive)
      .map(
        (e) => e is io.File
            ? File(
                path: p.dirname(e.path),
                name: p.basenameWithoutExtension(e.path),
                extension: p.extension(e.path).replaceAll('.', ''),
              )
            : Directory(path: e.path),
      )
      .toList();

  /// The parent directory of the directory.
  @override
  Directory get parent => Directory(path: _directory.parent.path);

  /// Wheter the directory is empty.
  bool get isEmpty => _directory.listSync().isEmpty;

  /// Deletes the directory.
  @override
  void delete({required Logger logger}) =>
      _directory.deleteSync(recursive: true);
}
