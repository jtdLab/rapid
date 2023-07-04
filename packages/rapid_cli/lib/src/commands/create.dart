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

    await task('Creating project', () async {
      await project.rootPackage.generate();
      await project.appModule.diPackage.generate();
      await project.appModule.domainDirectory.domainPackage().generate();
      await project.appModule.infrastructureDirectory
          .infrastructurePackage()
          .generate();
      await project.appModule.loggingPackage.generate();
      await project.uiModule.uiPackage.generate();
    });

    for (final platform in platforms) {
      await task('Activating ${platform.prettyName}', () async {
        await __activatePlatform(
          platform,
          orgName: orgName,
          description: description,
          language: language,
        );

        // TODO log platform success
      });
    }

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
