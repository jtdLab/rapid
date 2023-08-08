part of '../project.dart';

/// {@template bloc}
/// Abstraction of a bloc of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class Bloc extends FileSystemEntityCollection {
  /// {@macro bloc}
  Bloc({
    required this.platform,
    required this.projectName,
    required this.name,
    required this.path,
    required this.featureName,
  });

  /// The platform.
  final Platform platform;

  /// The name of the project this bloc is part of.
  final String projectName;

  /// The name of this bloc.
  final String name;

  /// The path of the platform feature package this bloc is part of.
  final String path;

  /// The name of the platform feature package this bloc is part of.
  final String featureName;

  /// The `lib/src/application/<name>_bloc.dart` file.
  File get file => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_bloc.dart',
        ),
      );

  /// The `lib/src/application/<name>_bloc.freezed.dart` file.
  File get freezedFile => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_bloc.freezed.dart',
        ),
      );

  /// The `lib/src/application/<name>_event.dart` file.
  File get eventFile => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_event.dart',
        ),
      );

  /// The `lib/src/application/<name>_state.dart` file.
  File get stateFile => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_state.dart',
        ),
      );

  /// The `test/src/application/<name>_bloc_test.dart` file.
  File get testFile => File(
        p.join(
          path,
          'test',
          'src',
          'application',
          '${name.snakeCase}_bloc_test.dart',
        ),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        eventFile,
        stateFile,
        testFile,
      };

  /// Generate this bloc on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: blocBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform.name,
        'feature_name': featureName,
        'output_dir': '.',
      },
    );
  }
}
