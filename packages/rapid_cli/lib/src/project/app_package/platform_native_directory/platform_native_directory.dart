import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'android_native_directory_bundle.dart';
import 'ios_native_directory_bundle.dart';
import 'linux_native_directory_bundle.dart';
import 'macos_native_directory_bundle.dart';
import 'web_native_directory_bundle.dart';
import 'windows_native_directory_bundle.dart';

/// {@template platform_native_directory}
/// Abstraction of a platform native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/<platform>`
/// {@endtemplate}
class PlatformNativeDirectory extends ProjectDirectory {
  /// {@macro platform_native_directory}
  PlatformNativeDirectory(
    this.platform, {
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  })  : _appPackage = appPackage,
        _generator = generator ?? MasonGenerator.fromBundle;

  final AppPackage _appPackage;
  final GeneratorBuilder _generator;

  final Platform platform;

  @override
  String get path => p.join(_appPackage.path, platform.name);

  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final projectName = _appPackage.project.name();

    late final MasonGenerator generator;
    if (platform == Platform.android) {
      generator = await _generator(androidNativeDirectoryBundle);
    } else if (platform == Platform.ios) {
      generator = await _generator(iosNativeDirectoryBundle);
    } else if (platform == Platform.linux) {
      generator = await _generator(linuxNativeDirectoryBundle);
    } else if (platform == Platform.macos) {
      generator = await _generator(macosNativeDirectoryBundle);
    } else if (platform == Platform.web) {
      generator = await _generator(webNativeDirectoryBundle);
    } else {
      generator = await _generator(windowsNativeDirectoryBundle);
    }

    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
      },
      logger: logger,
    );
  }
}
