import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
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
  }) : _project = project {
    appFeaturePackage = PlatformAppFeaturePackage(platform, project: project);
    routingFeaturePackage =
        PlatformRoutingFeaturePackage(platform, project: project);
  }

  final Project _project;

  final Platform platform;

  @override
  String get path => p.join(
        _project.path,
        'packages',
        _project.name(),
        '${_project.name()}_${platform.name}',
      );

  late final PlatformAppFeaturePackage appFeaturePackage;

  late final PlatformRoutingFeaturePackage routingFeaturePackage;

  bool allFeaturesHaveSameLanguages() {
    // TODO include app and routing ?
    final featurePackages = customFeaturePackages();

    return EqualitySet.from(
          DeepCollectionEquality.unordered(),
          featurePackages.map((e) => e.supportedLanguages()),
        ).length ==
        1;
  }

  bool allFeaturesHaveSameDefaultLanguage() {
    // TODO include app and routing ?
    final featurePackages = customFeaturePackages();

    return featurePackages.map((e) => e.defaultLanguage()).toSet().length == 1;
  }

  PlatformCustomFeaturePackage customFeaturePackage({required String name}) =>
      PlatformCustomFeaturePackage(name, platform, project: _project);

  List<PlatformCustomFeaturePackage> customFeaturePackages() {
    final dir = Directory(path);
    final subDirs = dir.listSync().whereType<Directory>();
    return subDirs
        .where((e) => !e.path.endsWith('routing') && !e.path.endsWith('app'))
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
