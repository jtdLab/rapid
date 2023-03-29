import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'di_package.dart';
import 'di_package_bundle.dart';

class DiPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements DiPackage {
  DiPackageImpl({
    required Project project,
    super.pubspecFile,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_di',
          ),
        );

  final Project _project;

  @override
  Future<void> create({
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  }) async {
    final projectName = _project.name();

    await generate(
      name: 'di package',
      bundle: diPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': android,
        'ios': ios,
        'linux': linux,
        'macos': macos,
        'web': web,
        'windows': windows,
      },
      logger: logger,
    );
  }
}
