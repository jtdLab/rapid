import 'package:rapid_cli/src/core/directory_impl.dart';

import 'file_system_entity.dart';

/// {@template directory}
/// Abstraction of a directory.
/// {@endtemplate}
abstract class Directory implements FileSystemEntity {
  /// {@macro directory}
  factory Directory({
    String path = '.',
  }) =>
      DirectoryImpl(path: path);

  /// Wheter the directory is empty.
  bool get isEmpty;

  /// Lists the sub-directories and files of the directory.
  ///
  /// Recurses into sub-directories when [recursive] is `true`.
  List<FileSystemEntity> list({bool recursive = false});
}
