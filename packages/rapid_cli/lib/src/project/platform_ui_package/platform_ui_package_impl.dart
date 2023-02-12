import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_ui_package.dart';
import 'platform_ui_package_bundle.dart';
import 'widget_bundle.dart';

class PlatformUiPackageImpl extends DartPackageImpl
    implements PlatformUiPackage {
  PlatformUiPackageImpl(
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

  @override
  final Platform platform;

  @override
  final Project project;

  @override
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

  @override
  Widget widget({
    required String name,
    required String dir,
  }) =>
      Widget(name: name, dir: dir, platformUiPackage: this);
}

class WidgetImpl extends FileSystemEntityCollection implements Widget {
  WidgetImpl({
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

  @override
  final String name;

  @override
  final String dir;

  @override
  final PlatformUiPackage platformUiPackage;

  @override
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
