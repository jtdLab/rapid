import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../../project.dart';
import 'navigator_bundle.dart';
import 'platform_navigation_package.dart';
import 'platform_navigation_package_bundle.dart';

class PlatformNavigationPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformNavigationPackage {
  PlatformNavigationPackageImpl(
    Platform platform, {
    required RapidProject project,
  })  : _platform = platform,
        _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name,
            '${project.name}_${platform.name}',
            '${project.name}_${platform.name}_navigation',
          ),
        );

  final Platform _platform;
  final RapidProject _project;

  @override
  NavigatorBuilder? navigatorOverrides;

  @override
  PlatformNavigationPackageBarrelFileBuilder? barrelFileOverrides;

  @override
  PlatformNavigationPackageBarrelFile get barrelFile => (barrelFileOverrides ??
      PlatformNavigationPackageBarrelFile.new)(platformNavigationPackage: this);

  @override
  Navigator navigator({required String name}) => (navigatorOverrides ??
      Navigator.new)(name: name, platformNavigationPackage: this);

  @override
  Future<void> create() async {
    final projectName = _project.name;

    await generate(
      bundle: platformNavigationPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': _platform == Platform.android,
        'ios': _platform == Platform.ios,
        'linux': _platform == Platform.linux,
        'macos': _platform == Platform.macos,
        'web': _platform == Platform.web,
        'windows': _platform == Platform.windows,
        'mobile': _platform == Platform.mobile,
      },
    );
  }
}

class NavigatorImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Navigator {
  NavigatorImpl({
    required String name,
    required PlatformNavigationPackage platformNavigationPackage,
  })  : _platformNavigationPackage = platformNavigationPackage,
        _name = name,
        super([
          DartFile(
            path: p.join(
              platformNavigationPackage.path,
              'lib',
              'src',
            ),
            name: 'i_${name.snakeCase}_navigator',
          ),
        ]);

  final String _name;
  final PlatformNavigationPackage _platformNavigationPackage;

  @override
  Future<void> create() async {
    final generator = await super.generator(navigatorBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformNavigationPackage.path)),
      vars: <String, dynamic>{
        'name': _name,
      },
    );
  }
}

class PlatformNavigationPackageBarrelFileImpl extends DartFileImpl
    implements PlatformNavigationPackageBarrelFile {
  PlatformNavigationPackageBarrelFileImpl({
    required PlatformNavigationPackage platformNavigationPackage,
  }) : super(
          path: p.join(
            platformNavigationPackage.path,
            'lib',
          ),
          name: platformNavigationPackage.packageName(),
        );
}
