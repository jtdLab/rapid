import 'package:universal_io/io.dart';

/// {@template project_dir}
/// Base class for a directory in a Rapid project.
/// {@endtemplate}
abstract class ProjectDir {
  /// {@macro project_dir}
  ProjectDir(this.path);

  /// The path of this.
  final String path;

  /// The underlying directory of this.
  late final Directory directory = Directory(path);

  /// Wheter the underlying directory exists
  bool exists() => directory.existsSync();

  /// Delets the underlying directory.
  void delete() => directory.deleteSync(recursive: true);
}
