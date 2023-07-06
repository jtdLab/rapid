part of 'runner.dart';

mixin _CreateMixin on _ActivateMixin {
  Future<void> create({
    required String projectName,
    required String outputDir,
    required String description,
    required String orgName,
    required Language language,
    required Set<Platform> platforms,
  }) async {
    if (!dirIsEmpty(outputDir)) {
      throw OutputDirNotEmptyException._(outputDir);
    }

    project = RapidProject.fromConfig(
      RapidProjectConfig(
        path: outputDir,
        name: projectName,
      ),
    );

    logger.newLine();

    await taskGroup(
      description: '$paket ${taskGroupTitleStyle('Creating project')}',
      tasks: [
        (
          'Generating platform-independent packages',
          () async {
            await project.rootPackage.generate();
            await project.appModule.diPackage.generate();
            await project.appModule.domainDirectory.domainPackage().generate();
            await project.appModule.infrastructureDirectory
                .infrastructurePackage()
                .generate();
            await project.appModule.loggingPackage.generate();
            await project.uiModule.uiPackage.generate();
          }
        ),
      ],
      parallelism: 1,
    );

    await taskGroup(
      tasks: [
        project.rootPackage,
        project.appModule.diPackage,
        project.appModule.domainDirectory.domainPackage(),
        project.appModule.infrastructureDirectory.infrastructurePackage(),
        project.appModule.loggingPackage,
        project.uiModule.uiPackage,
      ]
          .map(
            (package) => (
              'Running "flutter pub get" in ${package.packageName}',
              () async => flutterPubGet(package: package)
            ),
          )
          .toList(),
    );

    logger.newLine();

    for (final platform in platforms) {
      await __activatePlatform(
        platform,
        orgName: orgName,
        description: description,
        language: language,
      );
    }

    await task(
      'Running "dart format . --fix" in project',
      () async => dartFormatFix(package: project.rootPackage),
    );

    // TODO log better summary + refs to doc
    logger
      ..newLine()
      ..commandSuccess('Created Project!');
  }
}

class OutputDirNotEmptyException extends RapidException {
  OutputDirNotEmptyException._(this.outputDir);

  final String outputDir;

  @override
  String toString() {
    return 'The output directory "$outputDir" must be empty.';
  }
}
