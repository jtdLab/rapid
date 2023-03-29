import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'logging_package_bundle.dart';

class LoggingPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements LoggingPackage {
  LoggingPackageImpl({
    required Project project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_logging',
          ),
        );

  final Project _project;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    await generate(
      name: 'logging package',
      bundle: loggingPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
