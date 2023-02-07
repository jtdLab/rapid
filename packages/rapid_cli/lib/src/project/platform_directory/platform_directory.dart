import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_feature_package/platform_feature_package.dart';

/// {@template platform_directory}
/// Abstraction of a platform directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
class PlatformDirectory extends DartPackage {
  /// {@macro platform_directory}
  PlatformDirectory(
    this.platform, {
    required Project project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
          ),
        ) {
    appFeaturePackage = PlatformAppFeaturePackage(platform, project: project);
    routingFeaturePackage =
        PlatformRoutingFeaturePackage(platform, project: project);
  }

  final Project _project;

  final Platform platform;

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

  @visibleForTesting
  List<PlatformCustomFeaturePackage>? customFeaturePackagesOverrides;

  List<PlatformCustomFeaturePackage> customFeaturePackages() =>
      (customFeaturePackagesOverrides ??
          list()
              .whereType<Directory>()
              .where(
                  (e) => !e.path.endsWith('routing') && !e.path.endsWith('app'))
              .map(
                // TODO mayb add ofDir constructor to platfor custom feature package
                (e) => PlatformCustomFeaturePackage(
                  p
                      .basename(e.path)
                      .replaceAll('${_project.name()}_${platform.name}_', ''),
                  platform,
                  project: _project,
                ),
              )
              .toList())
        ..sort((a, b) => a.name.compareTo(b.name));
}
