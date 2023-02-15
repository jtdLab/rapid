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
    required this.project,
  }) : super(
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

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  late final PlatformAppFeaturePackage appFeaturePackage;

  @override
  late final PlatformRoutingFeaturePackage routingFeaturePackage;

  @override
  bool allFeaturesHaveSameLanguages() {
    final featurePackages = [
      appFeaturePackage,
      ...customFeaturePackages(),
    ];

    return EqualitySet.from(
          DeepCollectionEquality.unordered(),
          featurePackages.map((e) => e.supportedLanguages()),
        ).length ==
        1;
  }

  @override
  bool allFeaturesHaveSameDefaultLanguage() {
    final featurePackages = [
      appFeaturePackage,
      ...customFeaturePackages(),
    ];

    return featurePackages.map((e) => e.defaultLanguage()).toSet().length == 1;
  }

  @override
  PlatformCustomFeaturePackage customFeaturePackage({required String name}) =>
      PlatformCustomFeaturePackage(name, platform, project: project);

  @override
  List<PlatformCustomFeaturePackage> customFeaturePackages() => list()
      .whereType<Directory>()
      .where((e) => !e.path.endsWith('routing') && !e.path.endsWith('app'))
      .map(
        (e) => PlatformCustomFeaturePackage(
          p
              .basename(e.path)
              .replaceAll('${project.name()}_${platform.name}_', ''),
          platform,
          project: project,
        ),
      )
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}
