import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'ui_package.dart';
import 'ui_package_bundle.dart';

class UiPackageImpl extends DartPackageImpl implements UiPackage {
  UiPackageImpl({
    required Project project,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            '${project.name()}_ui',
            '${project.name()}_ui',
          ),
        );

  final Project _project;
  final GeneratorBuilder _generator;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(uiPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
