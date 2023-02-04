import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'directory.dart';
import 'file_system_entity.dart';

// TODO more protected

/// {@template file}
/// Abstraction of a file.
/// {@endtemplate}
class File extends FileSystemEntity {
  /// {@macro file}
  File({
    String path = '.',
    this.name,
    this.extension,
  })  : assert(
          !(name == null && extension == null),
          'Properties name and extension can not be null at the same time',
        ),
        _file = io.File(
          p.normalize(
            p.join(path, '${name ?? ''}.${extension ?? ''}'),
          ),
        );

  final String? name;
  final String? extension;

  /// The underlying file
  final io.File _file;

  /// The path of the file.
  @override
  String get path => _file.path;

  /// Wheter the file exists.
  @override
  bool exists() => _file.existsSync();

  /// The parent directory of the file.
  @override
  Directory get parent => Directory(path: _file.parent.path);

  /// Reads the contents of the file.
  @protected
  String read() => _file.readAsStringSync();

  /// Writes [contents] to the file.
  @protected
  void write(String contents) => _file.writeAsStringSync(contents, flush: true);

  /// Deletes the file.
  @override
  void delete({required Logger logger}) => _file.deleteSync(recursive: true);
}
