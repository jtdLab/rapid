import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'platform_ui_package_bundle.dart';
import 'widget_bundle.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>`
/// {@endtemplate}
class PlatformUiPackage extends ProjectPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage(
    this.platform, {
    required this.project,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle;

  final Project project;
  final GeneratorBuilder _generator;

  final Platform platform;

  @override
  String get path => p.join(
        project.path,
        'packages',
        '${project.name()}_ui',
        '${project.name()}_ui_${platform.name}',
      );

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

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

  Widget widget({
    required String name,
    required String dir,
  }) =>
      Widget(name: name, dir: dir, platformUiPackage: this);
}

/// {@template widget}
/// Abstraction of a widget of a platform ui package of a Rapid project.
/// {@endtemplate}
class Widget {
  /// {@macro widget}
  Widget({
    required this.name,
    required this.dir,
    required this.platformUiPackage,
    GeneratorBuilder? generator,
  })  : _widgetDirectory = Directory(
          p.join(
            platformUiPackage.path,
            'lib',
            'src',
            dir,
            name,
          ),
        ),
        _widgetTestDirectory = Directory(
          p.join(
            platformUiPackage.path,
            'test',
            'src',
            dir,
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _widgetDirectory;
  final Directory _widgetTestDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final String dir;
  final PlatformUiPackage platformUiPackage;

  bool exists() =>
      _widgetDirectory.existsSync() || _widgetTestDirectory.existsSync();

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = platformUiPackage.project.name();
    final generator = await _generator(widgetBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(platformUiPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
      },
      logger: logger,
    );
  }

  // TODO logger ?
  void delete() {
    _widgetDirectory.deleteSync(recursive: true);
    _widgetTestDirectory.deleteSync(recursive: true);
  }
}
