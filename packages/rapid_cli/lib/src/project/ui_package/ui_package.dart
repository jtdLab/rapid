import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'ui_package_impl.dart';

// TODO: ThemeExtensionsFile methods should be considered

/// Signature of [UiPackage.new].
typedef UiPackageBuilder = UiPackage Function({required RapidProject project});

/// {@template ui_package}
/// Abstraction of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui`
/// {@endtemplate}
abstract class UiPackage implements DartPackage, OverridableGenerator {
  /// {@macro ui_package}
  factory UiPackage({
    required RapidProject project,
  }) =>
      UiPackageImpl(
        project: project,
      );

  /// Use to override [themeExtensionsFile] for testing.
  @visibleForTesting
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  /// Use to override [barrelFile] for testing.
  @visibleForTesting
  UiPackageBarrelFileBuilder? barrelFileOverrides;

  /// Use to override [widget] for testing.
  @visibleForTesting
  WidgetBuilder? widgetOverrides;

  /// Returns the project associated with this package.
  RapidProject get project;

  /// Returns the theme extensions file of this package.
  ThemeExtensionsFile get themeExtensionsFile;

  /// Returns the barrel file of this package.
  UiPackageBarrelFile get barrelFile;

  /// Returns the Widget with the given [name] and [dir].
  ///
  /// The [name] parameter specifies the name of the Widget.
  ///
  /// The [dir] parameter specifies the directory where the Widget is stored,
  /// relative to the `lib/src` directory of the package.
  Widget widget({
    required String name,
    required String dir,
  });

  /// Creates this package on disk.
  Future<void> create();
}

/// Signature of [Widget.new].
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

  /// Creates this widget on disk.
  Future<void> create();
}

/// Signature of [ThemeExtensionsFile.new].
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

  /// Adds the theme extension with [name] to this file.
  void addThemeExtension(String name);

  /// Removes the theme extension with [name] to this file.
  void removeThemeExtension(String name);
}

/// Signature of [UiPackageBarrelFile.new].
typedef UiPackageBarrelFileBuilder = UiPackageBarrelFile Function({
  required UiPackage uiPackage,
});

/// {@template ui_package_barrel_file}
/// Abstraction of the barrel file of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui/lib/<project name>_ui_<platform>.dart`
/// {@endtemplate}
abstract class UiPackageBarrelFile implements DartFile {
  /// {@macro ui_package_barrel_file}
  factory UiPackageBarrelFile({
    required UiPackage uiPackage,
  }) =>
      UiPackageBarrelFileImpl(
        uiPackage: uiPackage,
      );
}
