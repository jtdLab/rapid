part of '../project.dart';

/// {@template cubit}
/// Abstraction of a cubit of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class Cubit extends FileSystemEntityCollection {
  /// {@macro cubit}
  Cubit({
    required this.platform,
    required this.projectName,
    required this.name,
    required this.path,
    required this.featureName,
  });

  /// The platform.
  final Platform platform;

  /// The name of the project this cubit is part of.
  final String projectName;

  /// The name of this cubit.
  final String name;

  /// The path of the platform feature package this cubit is part of.
  final String path;

  /// The name of the platform feature package this cubit is part of.
  final String featureName;

  /// The `lib/src/application/<name>_cubit.dart` file.
  File get file => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_cubit.dart',
        ),
      );

  /// The `lib/src/application/<name>_cubit.freezed.dart` file.
  File get freezedFile => File(
        p.join(
          path,
          'lib',
          'src',
          'application',
          '${name.snakeCase}_cubit.freezed.dart',
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

  /// The `test/src/application/<name>_cubit_test.dart` file.
  File get testFile => File(
        p.join(
          path,
          'test',
          'src',
          'application',
          '${name.snakeCase}_cubit_test.dart',
        ),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        stateFile,
        testFile,
      };

  /// Generate this cubit on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: cubitBundle,
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
