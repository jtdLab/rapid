import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';

import 'platform_native_directory_impl.dart';

/// {@template platform_native_directory}
/// Abstraction of a platform native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/<platform>`
/// {@endtemplate}
abstract class PlatformNativeDirectory implements Directory {
  /// {@macro platform_native_directory}
  factory PlatformNativeDirectory(
    Platform platform, {
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  }) =>
      PlatformNativeDirectoryImpl(
        platform,
        appPackage: appPackage,
        generator: generator,
      );

  Platform get platform;

  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  });
}
