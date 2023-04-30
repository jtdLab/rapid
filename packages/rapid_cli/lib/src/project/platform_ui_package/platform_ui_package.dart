import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature for method that returns the [PlatformUiPackage] for [platform].
typedef PlatformUiPackageBuilder = PlatformUiPackage Function({
  required Platform platform,
  required Project project,
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
    required Project project,
  }) =>
      PlatformUiPackageImpl(
        platform,
        project: project,
      );

  @visibleForTesting
  PlatformUiPackageBarrelFileBuilder? barrelFileOverrides;

  @visibleForTesting
  ThemeExtensionsFileBuilder? themeExtensionsFileOverrides;

  @visibleForTesting
  WidgetBuilder? widgetOverrides;

  Platform get platform;

  Project get project;

  PlatformUiPackageBarrelFile get barrelFile;

  ThemeExtensionsFile get themeExtensionsFile;

  Widget widget({
    required String name,
    required String dir,
  });

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

  Future<void> create();
}

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

  void addThemeExtension(String name);

  void removeThemeExtension(String name);
}

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
