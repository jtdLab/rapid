part of 'runner.dart';

mixin _DeactivateMixin on _Rapid {
  Future<void> deactivatePlatform(Platform platform) async {
    if (!project.platformIsActivated(platform)) {
      _logAndThrow(
        RapidDeactivateException._platformAlreadyDeactivated(platform),
      );
    }

    logger
      ..command('rapid deactivate ${platform.name}')
      ..newLine();

    await task(
      'Delete platform directory (${platform.prettyName})',
      () async => project.platformDirectory(platform: platform).delete(),
    );

    await task(
      'Delete platform ui package (${platform.prettyName})',
      () async => project.platformUiPackage(platform: platform).delete(),
    );

    logger
      ..newLine()
      ..success('Success $checkLabel');
  }
}

class RapidDeactivateException extends RapidException {
  RapidDeactivateException._(super.message);

  factory RapidDeactivateException._platformAlreadyDeactivated(
    Platform platform,
  ) {
    return RapidDeactivateException._(
      'The platform ${platform.prettyName} is already deactivated.',
    );
  }

  @override
  String toString() {
    return 'RapidDeactivateException: $message';
  }
}
