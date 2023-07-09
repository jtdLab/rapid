part of '../project.dart';

class Cubit extends FileSystemEntityCollection {
  Cubit({
    required this.projectName,
    required this.platform,
    required this.name,
    required this.path,
    required this.featureName,
  });

  final String projectName;

  final Platform platform;

  final String name;

  final String path;

  final String featureName;

  File get file =>
      File(p.join(path, 'lib', 'src', 'application', '${name}_cubit.dart'));

  File get freezedFile => File(
      p.join(path, 'lib', 'src', 'application', '${name}_cubit.freezed.dart'));

  File get stateFile =>
      File(p.join(path, 'lib', 'src', 'application', '${name}_state.dart'));

  File get testFile => File(
      p.join(path, 'test', 'src', 'application', '${name}_cubit_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        stateFile,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: cubitBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform.name,
        'feature_name': featureName,
      },
    );
  }
}
