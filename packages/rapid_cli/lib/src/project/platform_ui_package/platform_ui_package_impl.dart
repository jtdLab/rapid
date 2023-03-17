import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

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
            '${project.name()}_ui',
            '${project.name()}_ui_${platform.name}',
          ),
        );

  ThemeExtensionsFile get _themeExtensionsFile =>
      (themeExtensionsFileOverrides ?? ThemeExtensionsFileImpl.new)(
        platformUiPackage: this,
      );

  Widget _widget({required String name, required String dir}) =>
      (widgetOverrides ?? Widget.new)(
        name: name,
        dir: dir,
        platformUiPackage: this,
      );

  @override
  WidgetBuilder? widgetOverrides;

  @override
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    await generate(
      name: 'ui package (${platform.name})',
      bundle: platformUiPackageBundle,
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
  Future<void> addWidget({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    final widget = _widget(name: name, dir: outputDir);
    if (widget.existsAny()) {
      // TODO maybe log which files
      throw WidgetAlreadyExists();
    }

    await widget.create(logger: logger);
    _themeExtensionsFile.addThemeExtension(name);
  }

  @override
  Future<void> removeWidget({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final widget = _widget(name: name, dir: dir);
    if (!widget.existsAny()) {
      throw WidgetDoesNotExist();
    }

    widget.delete(logger: logger);
    _themeExtensionsFile.removeThemeExtension(name);
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

  final String _name;
  final String _dir;
  final PlatformUiPackage _platformUiPackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _platformUiPackage.project.name();
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
      },
      logger: logger,
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
    final projectName = _platformUiPackage.project.name();

    addImport('${name.snakeCase}/${name.snakeCase}_theme.dart');

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
    final projectName = _platformUiPackage.project.name();

    removeImport('${name.snakeCase}/${name.snakeCase}_theme.dart');

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
