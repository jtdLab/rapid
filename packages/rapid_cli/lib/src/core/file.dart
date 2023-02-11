import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/file_impl.dart';

import 'file_system_entity.dart';

/// {@template file}
/// Abstraction of a file.
/// {@endtemplate}
abstract class File implements FileSystemEntity {
  /// {@macro file}
  factory File({
    String path = '.',
    String? name,
    String? extension,
  }) =>
      FileImpl(path: path, name: name, extension: extension);

  /// The name of the file.
  String? get name;

  /// The extension of the file.
  String? get extension;

  /// Reads the contents of the file.
  String read();

  /// Writes [contents] to the file.
  ///
  /// This flushes the data to disc before returning.
  void write(String contents);

  /// Deletes the file.
  @override
  void delete({required Logger logger});
}
