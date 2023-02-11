import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_directory_impl.dart';
import 'platform_feature_package/platform_feature_package.dart';

/// {@template platform_directory}
/// Abstraction of a platform directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
abstract class PlatformDirectory implements DartPackage {
  /// {@macro platform_directory}
  factory PlatformDirectory(
    Platform platform, {
    required Project project,
  }) =>
      PlatformDirectoryImpl(platform, project: project);

  Platform get platform;

  PlatformAppFeaturePackage get appFeaturePackage;

  PlatformRoutingFeaturePackage get routingFeaturePackage;

  bool allFeaturesHaveSameLanguages();

  bool allFeaturesHaveSameDefaultLanguage();

  PlatformCustomFeaturePackage customFeaturePackage({required String name});

  List<PlatformCustomFeaturePackage> customFeaturePackages();
}
