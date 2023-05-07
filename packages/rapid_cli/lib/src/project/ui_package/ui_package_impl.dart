import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/platform_ui_package/widget_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'ui_package.dart';
import 'ui_package_bundle.dart';

class UiPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements UiPackage {
  UiPackageImpl({
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            '${project.name()}_ui',
            '${project.name()}_ui',
          ),
        );

  @override
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  @override
  UiPackageBarrelFileBuilder? barrelFileOverrides;

  @override
  WidgetBuilder? widgetOverrides;

  @override
  final Project project;

  @override
  ThemeExtensionsFile get themeExtensionsFile =>
      (themeExtensionsFileOverrides ?? ThemeExtensionsFile.new)(
        uiPackage: this,
      );

  @override
  UiPackageBarrelFile get barrelFile =>
      (barrelFileOverrides ?? UiPackageBarrelFile.new)(
        uiPackage: this,
      );

  @override
  Widget widget({
    required String name,
    required String dir,
  }) =>
      (widgetOverrides ?? Widget.new)(
        name: name,
        dir: dir,
        uiPackage: this,
      );

  @override
  Future<void> create() async {
    final projectName = project.name();

    await generate(
      bundle: uiPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
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
    required UiPackage uiPackage,
  })  : _uiPackage = uiPackage,
        _name = name,
        _dir = dir,
        super([
          DartFile(
            path: p.join(
              uiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              uiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme',
          ),
          DartFile(
            path: p.join(
              uiPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme.tailor',
          ),
          DartFile(
            path: p.join(
              uiPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
          DartFile(
            path: p.join(
              uiPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_theme_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final UiPackage _uiPackage;

  @override
  Future<void> create() async {
    final projectName = _uiPackage.project.name();

    final generator = await super.generator(widgetBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_uiPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'android': false,
        'ios': false,
        'linux': false,
        'macos': false,
        'web': false,
        'windows': false,
      },
    );
  }
}

class ThemeExtensionsFileImpl extends DartFileImpl
    implements ThemeExtensionsFile {
  ThemeExtensionsFileImpl({
    required UiPackage uiPackage,
  })  : _uiPackage = uiPackage,
        super(
          path: p.join(
            uiPackage.path,
            'lib',
            'src',
          ),
          name: 'theme_extensions',
        );

  final UiPackage _uiPackage;

  @override
  void addThemeExtension(String name) {
    final projectName = _uiPackage.project.name();

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
    final projectName = _uiPackage.project.name();

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

class UiPackageBarrelFileImpl extends DartFileImpl
    implements UiPackageBarrelFile {
  UiPackageBarrelFileImpl({
    required UiPackage uiPackage,
  }) : super(
          path: p.join(
            uiPackage.path,
            'lib',
          ),
          name: uiPackage.packageName(),
        );
}
