part of 'runner.dart';

mixin _DeactivateMixin on _Rapid {
  Future<void> deactivatePlatform(Platform platform) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformAlreadyDeactivatedException._(platform);
    }

    logger.newLine();

    await task(
      'Deleting Platform Directory',
      () => project.appModule
          .platformDirectory(platform: platform)
          .deleteSync(recursive: true),
    );

    await task(
      'Deleting Platform Ui Package',
      () => project.uiModule
          .platformUiPackage(platform: platform)
          .deleteSync(recursive: true),
    );

    logger
      ..newLine()
      ..commandSuccess('Deactivated ${platform.prettyName}!');
  }
}

/// An exception thrown when platform is already deactivated.
class PlatformAlreadyDeactivatedException extends RapidException {
  PlatformAlreadyDeactivatedException._(Platform platform)
      : super('The platform ${platform.prettyName} is already deactivated.');
}
