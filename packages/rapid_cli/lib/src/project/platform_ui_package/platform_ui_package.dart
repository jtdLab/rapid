import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_ui_package_bundle.dart';
import 'widget_bundle.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>`
/// {@endtemplate}
class PlatformUiPackage extends DartPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage(
    this.platform, {
    required this.project,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            '${project.name()}_ui',
            '${project.name()}_ui_${platform.name}',
          ),
        );

  final GeneratorBuilder _generator;

  final Platform platform;
  final Project project;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(platformUiPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
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
class Widget extends FileSystemEntityCollection {
  /// {@macro widget}
  Widget({
    required this.name,
    required this.dir,
    required this.platformUiPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.join(
              platformUiPackage.path,
              'lib',
              'src',
              dir,
              name.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              platformUiPackage.path,
              'test',
              'src',
              dir,
              name.snakeCase,
            ),
          ),
        ]);

  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  final String name;
  final String dir;
  final PlatformUiPackage platformUiPackage;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = platformUiPackage.project.name();
    final platform = platformUiPackage.platform;

    final generator = await _generator(widgetBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(platformUiPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: platformUiPackage.path, logger: logger);
  }
}
