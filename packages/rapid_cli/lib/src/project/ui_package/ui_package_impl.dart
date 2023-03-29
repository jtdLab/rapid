import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'ui_package.dart';
import 'ui_package_bundle.dart';

class UiPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements UiPackage {
  UiPackageImpl({
    required Project project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            '${project.name()}_ui',
            '${project.name()}_ui',
          ),
        );

  final Project _project;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    await generate(
      name: 'ui package',
      bundle: uiPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
