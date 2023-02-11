import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

import 'directory.dart';
import 'file.dart';

class FileImpl implements File {
  FileImpl({
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

  @override
  final String? name;

  @override
  final String? extension;

  /// The underlying native file.
  final io.File _file;

  @override
  String get path => _file.path;

  @override
  bool exists() => _file.existsSync();

  @override
  Directory get parent => Directory(path: _file.parent.path);

  @override
  String read() => _file.readAsStringSync();

  @override
  void write(String contents) => _file.writeAsStringSync(contents, flush: true);

  @override
  void delete({required Logger logger}) => _file.deleteSync(recursive: true);
}
