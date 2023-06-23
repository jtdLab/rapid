import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../project.dart';
import 'platform_feature_package/platform_feature_package.dart';
import 'platform_features_directory_impl.dart';

typedef PlatformFeaturesDirectoryBuilder = PlatformFeaturesDirectory Function(
  Platform platform, {
  required RapidProject project,
});

/// {@template platform_features_directory}
/// Abstraction of a platform features directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features`
/// {@endtemplate}
abstract class PlatformFeaturesDirectory implements Directory {
  /// {@macro platform_features_directory}
  factory PlatformFeaturesDirectory(
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformFeaturesDirectoryImpl(
        platform,
        project: project,
      );

  @visibleForTesting
  PlatformFeaturePackageBuilder? featurePackageOverrides;

  @visibleForTesting
  List<PlatformFeaturePackage>? featurePackagesOverrides;

  RapidProject get project;

  T featurePackage<T extends PlatformFeaturePackage>({required String name});

  List<PlatformFeaturePackage> featurePackages();
}
