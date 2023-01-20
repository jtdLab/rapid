import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

import 'ui_package_bundle.dart';

/// {@template ui_package}
/// Abstraction of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui`
/// {@endtemplate}
class UiPackage extends ProjectPackage {
  /// {@macro ui_package}
  UiPackage({
    required Project project,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        path = p.join(
          project.path,
          'packages',
          '${project.name()}_ui',
          '${project.name()}_ui',
        );

  final Project _project;
  final GeneratorBuilder _generator;

  @override
  final String path;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(uiPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
