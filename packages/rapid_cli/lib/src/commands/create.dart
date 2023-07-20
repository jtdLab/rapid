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
    outputDir = Directory(outputDir).absolute.path;
    if (dirExists(outputDir) && !dirIsEmpty(outputDir)) {
      throw OutputDirNotEmptyException._(outputDir);
    }

    project = projectBuilder(
      config: RapidProjectConfig(
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

    await flutterPubGetTaskGroup(
      packages: [
        project.rootPackage,
        project.appModule.diPackage,
        project.appModule.domainDirectory.domainPackage(),
        project.appModule.infrastructureDirectory.infrastructurePackage(),
        project.appModule.loggingPackage,
        project.uiModule.uiPackage,
      ],
    );

    logger.newLine();

    for (final platform in platforms) {
      switch (platform) {
        case Platform.android:
          await _activateAndroid(
            description: description,
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
        case Platform.ios:
          await _activateIos(
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
        case Platform.linux:
          await _activateLinux(
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
        case Platform.macos:
          await _activateMacos(
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
        case Platform.web:
          await _activateWeb(
            description: description,
            language: language,
            cleanUp: false,
          );
        case Platform.windows:
          await _activateWindows(
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
        case Platform.mobile:
          await _activateMobile(
            description: description,
            orgName: orgName,
            language: language,
            cleanUp: false,
          );
      }
    }

    await dartFormatFixTask();

    // TODO log better summary + refs to doc
    logger
      ..newLine()
      ..commandSuccess('Created Project!');
  }
}

class OutputDirNotEmptyException extends RapidException {
  OutputDirNotEmptyException._(String outputDir)
      : super('The output directory "$outputDir" must be empty.');
}
