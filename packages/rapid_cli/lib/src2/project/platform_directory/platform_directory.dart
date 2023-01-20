import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

import 'platform_feature_package/platform_feature_package.dart';

/// {@template platform_directory}
/// Abstraction of a platform directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
class PlatformDirectory extends ProjectDirectory {
  /// {@macro platform_directory}
  PlatformDirectory(
    this.platform, {
    required Project project,
  })  : _project = project,
        path = p.join(
          project.path,
          'packages',
          project.name(),
          '${project.name()}_${platform.name}',
        ) {
    appFeaturePackage = PlatformAppFeaturePackage(platform, project: project);
    routingFeaturePackage = PlatformRoutingFeaturePackage(platform, project: project);
  }

  final Project _project;

  final Platform platform;

  @override
  final String path;

  late final PlatformAppFeaturePackage appFeaturePackage;

  late final PlatformRoutingFeaturePackage routingFeaturePackage;

  PlatformCustomFeaturePackage customFeaturePackage({required String name}) =>
      PlatformCustomFeaturePackage(name, platform, project: _project);

  List<PlatformCustomFeaturePackage> customFeaturePackages() {
    final dir = Directory(path);
    final subDirs = dir.listSync().whereType<Directory>();
    return subDirs
        .map(
          (e) => PlatformCustomFeaturePackage(
            p
                .basename(e.path)
                .replaceAll('${_project.name()}_${platform.name}_', ''),
            platform,
            project: _project,
          ),
        )
        .toList();
  }
}
