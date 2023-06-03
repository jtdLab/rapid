import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../project.dart';
import 'platform_ui_package.dart';
import 'platform_ui_package_bundle.dart';
import 'widget_bundle.dart';

class PlatformUiPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformUiPackage {
  PlatformUiPackageImpl(
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            '${project.name}_ui',
            '${project.name}_ui_${platform.name}',
          ),
        );

  @override
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  @override
  PlatformUiPackageBarrelFileBuilder? barrelFileOverrides;

  @override
  WidgetBuilder? widgetOverrides;

  @override
  final Platform platform;

  @override
  final RapidProject project;

  @override
  ThemeExtensionsFile get themeExtensionsFile =>
      (themeExtensionsFileOverrides ?? ThemeExtensionsFile.new)(
        platformUiPackage: this,
      );

  @override
  PlatformUiPackageBarrelFile get barrelFile =>
      (barrelFileOverrides ?? PlatformUiPackageBarrelFile.new)(
        platformUiPackage: this,
      );

  @override
  Widget widget({
    required String name,
    required String dir,
  }) =>
      (widgetOverrides ?? Widget.new)(
        name: name,
        dir: dir,
        platformUiPackage: this,
      );

  @override
  Future<void> create() async {
    final projectName = project.name;

    await generate(
      bundle: platformUiPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
        'mobile': platform == Platform.mobile,
      },
    );
  }
}

class WidgetImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Widget {
  WidgetImpl({
    required String name,
    required String dir,
    required PlatformUiPackage platformUiPackage,
  })  : _platformUiPackage = platformUiPackage,
        _name = name,
        _dir = dir,
        super([
          DartFile(
            path: p.join(
              platformUiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              platformUiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme',
          ),
          DartFile(
            path: p.join(
              platformUiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme.tailor',
          ),
          DartFile(
            path: p.join(
              platformUiPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
          DartFile(
            path: p.join(
              platformUiPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final PlatformUiPackage _platformUiPackage;

  @override
  Future<void> create() async {
    final projectName = _platformUiPackage.project.name;
    final platform = _platformUiPackage.platform;

    final generator = await super.generator(widgetBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformUiPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
        'mobile': platform == Platform.mobile,
      },
    );
  }
}

class ThemeExtensionsFileImpl extends DartFileImpl
    implements ThemeExtensionsFile {
  ThemeExtensionsFileImpl({
    required PlatformUiPackage platformUiPackage,
  })  : _platformUiPackage = platformUiPackage,
        super(
          path: p.join(
            platformUiPackage.path,
            'lib',
            'src',
          ),
          name: 'theme_extensions',
        );

  final PlatformUiPackage _platformUiPackage;

  @override
  void addThemeExtension(String name) {
    final projectName = _platformUiPackage.project.name;

    final themes = ['light', 'dark']; // TODO read from file

    for (final theme in themes) {
      final extension = '${projectName.pascalCase}${name}Theme.$theme';
      final existingExtensions =
          readTopLevelListVar(name: '${theme}Extensions');

      if (!existingExtensions.contains(extension)) {
        setTopLevelListVar(
          name: '${theme}Extensions',
          value: [
            extension,
            ...existingExtensions,
          ]..sort(),
        );
      }
    }
  }

  @override
  void removeThemeExtension(String name) {
    final projectName = _platformUiPackage.project.name;

    final themes = ['light', 'dark']; // TODO read from file

    for (final theme in themes) {
      final extension = '${projectName.pascalCase}${name}Theme.$theme';
      final existingExtensions =
          readTopLevelListVar(name: '${theme}Extensions');

      if (existingExtensions.contains(extension)) {
        setTopLevelListVar(
          name: '${theme}Extensions',
          value: existingExtensions..remove(extension),
        );
      }
    }
  }
}

class PlatformUiPackageBarrelFileImpl extends DartFileImpl
    implements PlatformUiPackageBarrelFile {
  PlatformUiPackageBarrelFileImpl({
    required PlatformUiPackage platformUiPackage,
  }) : super(
          path: p.join(
            platformUiPackage.path,
            'lib',
          ),
          name: platformUiPackage.packageName(),
        );
}
