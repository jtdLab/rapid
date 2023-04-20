import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_navigation_package.dart';
import 'platform_navigation_package_bundle.dart';

class PlatformNavigationPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformNavigationPackage {
  PlatformNavigationPackageImpl(
    Platform platform, {
    required Project project,
  })  : _platform = platform,
        _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}_navigation',
          ),
        );

  final Platform _platform;
  final Project _project;

  @override
  Future<void> create() async {
    final projectName = _project.name();

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
      },
    );
  }
}
