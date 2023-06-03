import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_ui_package_impl.dart';

/// Signature of [PlatformUiPackage.new].
typedef PlatformUiPackageBuilder = PlatformUiPackage Function({
  required Platform platform,
  required RapidProject project,
});

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>`
/// {@endtemplate}
abstract class PlatformUiPackage implements DartPackage, OverridableGenerator {
  /// {@macro platform_ui_package}
  factory PlatformUiPackage(
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformUiPackageImpl(
        platform,
        project: project,
      );

  /// Use to override [themeExtensionsFile] for testing.
  @visibleForTesting
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  /// Use to override [barrelFile] for testing.
  @visibleForTesting
  PlatformUiPackageBarrelFileBuilder? barrelFileOverrides;

  /// Use to override [widget] for testing.
  @visibleForTesting
  WidgetBuilder? widgetOverrides;

  /// Returns the platform of this package.
  Platform get platform;

  /// Returns the project associated with this package.
  RapidProject get project;

  /// Returns the theme extensions file of this package.
  ThemeExtensionsFile get themeExtensionsFile;

  /// Returns the barrel file file of this package.
  PlatformUiPackageBarrelFile get barrelFile;

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
  required PlatformUiPackage platformUiPackage,
});

/// {@template widget}
/// Abstraction of a widget of a platform ui package of a Rapid project.
/// {@endtemplate}
abstract class Widget
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro widget}
  factory Widget({
    required String name,
    required String dir,
    required PlatformUiPackage platformUiPackage,
  }) =>
      WidgetImpl(
        name: name,
        dir: dir,
        platformUiPackage: platformUiPackage,
      );

  /// Creates this widget on disk.
  Future<void> create();
}

/// Signature of [ThemeExtensionsFile.new].
typedef ThemeExtensionsFileBuilder = ThemeExtensionsFile Function({
  required PlatformUiPackage platformUiPackage,
});

/// {@template theme_extensions_file}
/// Abstraction of the theme extensions file of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>/lib/src/theme_extensions.dart`
/// {@endtemplate}
abstract class ThemeExtensionsFile implements DartFile {
  /// {@macro theme_extensions_file}
  factory ThemeExtensionsFile({
    required PlatformUiPackage platformUiPackage,
  }) =>
      ThemeExtensionsFileImpl(
        platformUiPackage: platformUiPackage,
      );

  /// Adds the theme extension with [name] to this file.
  void addThemeExtension(String name);

  /// Removes the theme extension with [name] to this file.
  void removeThemeExtension(String name);
}

/// Signature of [PlatformUiPackageBarrelFile.new].
typedef PlatformUiPackageBarrelFileBuilder = PlatformUiPackageBarrelFile
    Function({
  required PlatformUiPackage platformUiPackage,
});

/// {@template platform_ui_package_barrel_file}
/// Abstraction of the barrel file of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>/lib/<project name>_ui_<platform>.dart`
/// {@endtemplate}
abstract class PlatformUiPackageBarrelFile implements DartFile {
  /// {@macro platform_ui_package_barrel_file}
  factory PlatformUiPackageBarrelFile({
    required PlatformUiPackage platformUiPackage,
  }) =>
      PlatformUiPackageBarrelFileImpl(
        platformUiPackage: platformUiPackage,
      );
}
