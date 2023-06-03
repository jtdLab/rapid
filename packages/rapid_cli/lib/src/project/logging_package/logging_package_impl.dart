import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'logging_package.dart';
import 'logging_package_bundle.dart';

class LoggingPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements LoggingPackage {
  LoggingPackageImpl({
    required RapidProject project,
  })  : _project = project,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name,
            '${project.name}_logging',
          ),
        );

  final RapidProject _project;

  @override
  Future<void> create() async {
    final projectName = _project.name;

    await generate(
      bundle: loggingPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }
}
