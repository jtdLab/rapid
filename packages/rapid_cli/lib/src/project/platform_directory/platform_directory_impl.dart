import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_directory.dart';
import 'platform_feature_package/platform_feature_package.dart';

class PlatformDirectoryImpl extends DartPackageImpl
    implements PlatformDirectory {
  PlatformDirectoryImpl(
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
    appFeaturePackage = PlatformAppFeaturePackage(platform, project: _project);
    routingFeaturePackage =
        PlatformRoutingFeaturePackage(platform, project: _project);
  }

  final Project _project;

  @override
  final Platform platform;

  @override
  late final PlatformAppFeaturePackage appFeaturePackage;

  @override
  late final PlatformRoutingFeaturePackage routingFeaturePackage;

  @override
  bool allFeaturesHaveSameLanguages() {
    // TODO include app and routing ?
    final featurePackages = customFeaturePackages();

    return EqualitySet.from(
          DeepCollectionEquality.unordered(),
          featurePackages.map((e) => e.supportedLanguages()),
        ).length ==
        1;
  }

  @override
  bool allFeaturesHaveSameDefaultLanguage() {
    // TODO include app and routing ?
    final featurePackages = customFeaturePackages();

    return featurePackages.map((e) => e.defaultLanguage()).toSet().length == 1;
  }

  @override
  PlatformCustomFeaturePackage customFeaturePackage({required String name}) =>
      PlatformCustomFeaturePackage(name, platform, project: _project);

  @override
  List<PlatformCustomFeaturePackage> customFeaturePackages() => list()
      .whereType<Directory>()
      .where((e) => !e.path.endsWith('routing') && !e.path.endsWith('app'))
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
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}
