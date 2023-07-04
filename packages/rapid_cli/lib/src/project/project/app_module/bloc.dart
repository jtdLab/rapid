part of '../../project.dart';

class Bloc extends FileSystemEntityCollection {
  Bloc({
    required this.platform,
    required this.projectName,
    required this.name,
    required this.path,
    required this.featureName,
  });

  final Platform platform;

  final String projectName;

  final String name;

  final String path;

  final String featureName;

  File get file =>
      File(p.join(path, 'lib', 'src', 'application', '${name}_bloc.dart'));

  File get freezedFile => File(
      p.join(path, 'lib', 'src', 'application', '${name}_bloc.freezed.dart'));

  File get eventFile =>
      File(p.join(path, 'lib', 'src', 'application', '${name}_event.dart'));

  File get stateFile =>
      File(p.join(path, 'lib', 'src', 'application', '${name}_state.dart'));

  File get testFile => File(
      p.join(path, 'test', 'src', 'application', '${name}_bloc_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        eventFile,
        stateFile,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: blocBundle,
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
