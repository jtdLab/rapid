part of '../project.dart';

/// {@template navigator_implementation}
/// Abstraction of a navigator implementation of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class NavigatorImplementation extends FileSystemEntityCollection {
  /// {@macro navigator_implementation}
  NavigatorImplementation({
    required this.projectName,
    required this.platform,
    required this.path,
    required this.name, // TODO(jtdLab): might be renamed to feature name
  });

  /// The name of the project this navigator implementation is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The path of the platform feature package this navigator implementation
  /// is part of.
  final String path;

  /// The name of this navigator implementation.
  final String name;

  /// The `lib/src/presentation/navigator.dart` file.
  File get file =>
      File(p.join(path, 'lib', 'src', 'presentation', 'navigator.dart'));

  /// The `test/src/presentation/navigator_test.dart` file.
  File get testFile =>
      File(p.join(path, 'test', 'src', 'presentation', 'navigator_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
      };

  /// Generate this navigator implementation on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: navigatorImplementationBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        ...platformVars(platform),
      },
    );
  }
}
