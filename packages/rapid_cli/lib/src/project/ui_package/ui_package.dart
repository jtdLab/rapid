import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package_impl.dart';

typedef UiPackageBuilder = UiPackage Function({required Project project});

/// {@template ui_package}
/// Abstraction of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui`
/// {@endtemplate}
abstract class UiPackage implements DartPackage, OverridableGenerator {
  /// {@macro ui_package}
  factory UiPackage({
    required Project project,
  }) =>
      UiPackageImpl(
        project: project,
      );

  @visibleForTesting
  BarrelFileBuilder? barrelFileOverrides;

  @visibleForTesting
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  @visibleForTesting
  WidgetBuilder? widgetOverrides;

  Project get project;

  BarrelFile get barrelFile;

  ThemeExtensionsFile get themeExtensionsFile;

  Widget widget({
    required String name,
    required String dir,
  });

  /// Creates the ui package.
  Future<void> create();

  // TODO consider required !

  Future<Widget> addWidget({
    required String name,
    required String dir,
  });

  Future<Widget> removeWidget({
    required String name,
    required String dir,
  });
}

typedef WidgetBuilder = Widget Function({
  required String name,
  required String dir,
  required UiPackage uiPackage,
});

/// {@template widget}
/// Abstraction of a widget of the ui package of a Rapid project.
/// {@endtemplate}
abstract class Widget
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro widget}
  factory Widget({
    required String name,
    required String dir,
    required UiPackage uiPackage,
  }) =>
      WidgetImpl(
        name: name,
        dir: dir,
        uiPackage: uiPackage,
      );

  Future<void> create();
}

typedef ThemeExtensionsFileBuilder = ThemeExtensionsFile Function({
  required UiPackage uiPackage,
});

/// {@template theme_extensions_file}
/// Abstraction of the theme extensions file of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui/lib/src/theme_extensions.dart`
/// {@endtemplate}
abstract class ThemeExtensionsFile implements DartFile {
  /// {@macro theme_extensions_file}
  factory ThemeExtensionsFile({
    required UiPackage uiPackage,
  }) =>
      ThemeExtensionsFileImpl(
        uiPackage: uiPackage,
      );

  void addThemeExtension(String name);

  void removeThemeExtension(String name);
}

typedef BarrelFileBuilder = BarrelFile Function({
  required UiPackage uiPackage,
});

/// {@template barrel_file}
/// Abstraction of the barrel file of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui/lib/<project name>_ui_<platform>.dart`
/// {@endtemplate}
abstract class BarrelFile implements DartFile {
  /// {@macro barrel_file}
  factory BarrelFile({
    required UiPackage uiPackage,
  }) =>
      BarrelFileImpl(
        uiPackage: uiPackage,
      );
}
