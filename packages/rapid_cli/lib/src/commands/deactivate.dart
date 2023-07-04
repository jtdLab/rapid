part of 'runner.dart';

mixin _DeactivateMixin on _Rapid {
  Future<void> deactivatePlatform(Platform platform) async {
    if (!project.platformIsActivated(platform)) {
      throw PlatformAlreadyDeactivatedException._(platform);
    }

    logger.newLine();

    await task(
      'Deleting Platform Directory',
      () =>
          project.appModule.platformDirectory(platform: platform).deleteSync(),
    );

    await task(
      'Deleting Platform Ui Package',
      () => project.uiModule.platformUiPackage(platform: platform).deleteSync(),
    );

    logger
      ..newLine()
      ..commandSuccess('Deactivated ${platform.prettyName}!');
  }
}

class PlatformAlreadyDeactivatedException extends RapidException {
  final Platform platform;

  PlatformAlreadyDeactivatedException._(this.platform);

  @override
  String toString() {
    return 'The platform ${platform.prettyName} is already deactivated.';
  }
}
