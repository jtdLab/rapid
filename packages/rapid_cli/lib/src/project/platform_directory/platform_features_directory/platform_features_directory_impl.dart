import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../project.dart';
import 'platform_feature_package/platform_feature_package.dart';
import 'platform_features_directory.dart';

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
            project.name,
            '${project.name}_${platform.name}',
            '${project.name}_${platform.name}_features',
          ),
        );

  final Platform _platform;

  @override
  PlatformFeaturePackageBuilder? featurePackageOverrides;

  @override
  List<PlatformFeaturePackage>? featurePackagesOverrides;

  @override
  final RapidProject project;

  @override
  T featurePackage<T extends PlatformFeaturePackage>({required String name}) {
    if (T == PlatformAppFeaturePackage && name.endsWith('app')) {
      return PlatformAppFeaturePackage(_platform, project: project) as T;
    } else if (T == PlatformPageFeaturePackage && name.endsWith('_page')) {
      return PlatformPageFeaturePackage(name, _platform, project: project) as T;
    } else if (T == PlatformFlowFeaturePackage && name.endsWith('_flow')) {
      return PlatformFlowFeaturePackage(name, _platform, project: project) as T;
    } else if (T == PlatformWidgetFeaturePackage && name.endsWith('_widget')) {
      return PlatformWidgetFeaturePackage(name, _platform, project: project)
          as T;
    } else {
      return PlatformCustomFeaturePackage(name, _platform, project: project)
          as T;
    }
  }

  @override
  List<PlatformFeaturePackage> featurePackages() {
    return featurePackagesOverrides ??
        (exists()
            ? list().whereType<Directory>().map(
                (e) {
                  final name = p
                      .basename(e.path)
                      .replaceAll('${project.name}_${_platform.name}_', '');

                  return featurePackage(name: name);
                },
              ).toList()
            : [])
      ..sort();
  }
}
