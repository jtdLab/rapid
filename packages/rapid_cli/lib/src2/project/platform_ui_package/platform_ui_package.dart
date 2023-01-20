import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

import 'platform_ui_package_bundle.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>`
/// {@endtemplate}
class PlatformUiPackage extends ProjectPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage(
    this.platform, {
    required Project project,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        path = p.join(
          project.path,
          'packages',
          '${project.name()}_ui',
          '${project.name()}_ui_${platform.name}',
        );

  final Project _project;
  final GeneratorBuilder _generator;

  final Platform platform;

  @override
  final String path;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(platformUiPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );
  }

  Future<void> addWidget({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeWidget({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }
}
