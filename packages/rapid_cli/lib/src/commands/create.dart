part of 'runner.dart';

mixin _CreateMixin on _Rapid {
  Future<void> create({
    required String projectName,
    required String outputDir,
    required String description,
    required String orgName,
    required String language,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool mobile,
    required bool web,
    required bool windows,
  }) async {
    project = RapidProject(
      config: RapidProjectConfig(
        path: outputDir,
        name: projectName,
      ),
    );

    if (project.exists() && !project.isEmpty) {
      _logAndThrow(
        RapidCreateException._outputDirNotEmpty(outputDir),
      );
    }

    logger
      ..command('rapid create')
      ..newLine();

    await task(
      'Generating project files',
      () async => project.create(
        projectName: projectName,
        description: description,
        orgName: orgName,
        language: language,
        platforms: {
          if (android) Platform.android,
          if (ios) Platform.ios,
          if (linux) Platform.linux,
          if (macos) Platform.macos,
          if (web) Platform.web,
          if (windows) Platform.windows,
          if (mobile) Platform.mobile,
        },
      ),
    );

    await flutterPubGet([
      project,
      ...project.packages,
    ]);

    await flutterGenl10n(project.featurePackages);

    await dartFormatFix(project);

    if (android || mobile) {
      await flutterConfigEnableAndroid(project);
    }
    if (ios || mobile) {
      await flutterConfigEnableIos(project);
    }
    if (linux) {
      await flutterConfigEnableLinux(project);
    }
    if (macos) {
      await flutterConfigEnableMacos(project);
    }
    if (web) {
      await flutterConfigEnableWeb(project);
    }
    if (windows) {
      await flutterConfigEnableWindows(project);
    }

    // TODO log better summary + refs to doc
    logger
      ..newLine()
      ..success('Success $checkLabel');
  }
}

class RapidCreateException extends RapidException {
  RapidCreateException._(super.message);

  factory RapidCreateException._outputDirNotEmpty(String outputDir) {
    return RapidCreateException._(
      'The output directory "$outputDir" must be empty.',
    );
  }

  @override
  String toString() {
    return 'RapidCreateException: $message';
  }
}
