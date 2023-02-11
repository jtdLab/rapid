import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui_<platform>`
/// {@endtemplate}
abstract class PlatformUiPackage implements DartPackage {
  /// {@macro platform_ui_package}
  factory PlatformUiPackage(
    Platform platform, {
    required Project project,
    GeneratorBuilder? generator,
  }) =>
      PlatformUiPackageImpl(
        platform,
        project: project,
        generator: generator,
      );

  Platform get platform;

  Project get project;

  Future<void> create({required Logger logger});

  Widget widget({
    required String name,
    required String dir,
  });
}

/// {@template widget}
/// Abstraction of a widget of a platform ui package of a Rapid project.
/// {@endtemplate}
abstract class Widget implements FileSystemEntityCollection {
  /// {@macro widget}
  factory Widget({
    required String name,
    required String dir,
    required PlatformUiPackage platformUiPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      WidgetImpl(
        name: name,
        dir: dir,
        platformUiPackage: platformUiPackage,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get name;

  String get dir;

  PlatformUiPackage get platformUiPackage;

  Future<void> create({required Logger logger});
}
