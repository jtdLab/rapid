import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import 'directory.dart';
import 'file.dart';
import 'file_system_entity.dart';

class DirectoryImpl implements Directory {
  DirectoryImpl({
    String path = '.',
  }) : _directory = io.Directory(
          p.normalize(path),
        );

  /// The underlying native directory.
  final io.Directory _directory;

  @override
  String get path => _directory.path;

  @override
  bool get isEmpty => _directory.listSync().isEmpty;

  @override
  bool exists() => _directory.existsSync();

  @override
  List<FileSystemEntity> list({bool recursive = false}) => _directory
      .listSync(recursive: recursive)
      .map(
        (e) => e is io.File
            ? File(
                path: p.dirname(e.path),
                name: p.basenameWithoutExtension(e.path),
                extension: p.extension(e.path).replaceAll('.', ''),
              )
            : DirectoryImpl(path: e.path),
      )
      .toList();

  @override
  DirectoryImpl get parent => DirectoryImpl(path: _directory.parent.path);

  @override
  void delete({required Logger logger}) =>
      _directory.deleteSync(recursive: true);
}
