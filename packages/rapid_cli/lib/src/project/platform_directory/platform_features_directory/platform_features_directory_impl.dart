import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_features_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

class PlatformFeaturesDirectoryImpl extends DartPackageImpl
    implements PlatformFeaturesDirectory {
  PlatformFeaturesDirectoryImpl(
    Platform platform, {
    required this.project,
  })  : _platform = platform,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}_features',
          ),
        );

  final Platform _platform;

  @override
  PlatformFeaturePackageBuilder? featurePackageOverrides;

  @override
  List<PlatformFeaturePackage>? featurePackagesOverrides;

  @override
  final Project project;

  @override
  T featurePackage<T extends PlatformFeaturePackage>({required String name}) =>
      featurePackageOverrides?.call(name, _platform, project: project) as T? ??
      (name == 'app'
          ? PlatformAppFeaturePackage(_platform, project: project)
          : PlatformFeaturePackage(name, _platform, project: project)) as T;

  @override
  List<PlatformFeaturePackage> featurePackages() => featurePackagesOverrides ??
      list().whereType<Directory>().map(
        (e) {
          final name = p
              .basename(e.path)
              .replaceAll('${project.name()}_${_platform.name}_', '');

          return featurePackage(name: name);
        },
      ).toList()
    ..sort();
}
