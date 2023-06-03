part of 'runner.dart';

// TODO consider removing output-dir/dir option for widgets completly

mixin _UiMixin on _Rapid {
  Future<void> uiAddWidget({required String name}) async {
    logger
      ..command('rapid ui add widget')
      ..newLine();

    final uiPackage = project.uiPackage;
    final widget = uiPackage.widget(name: name, dir: '.');
    if (!widget.existsAny()) {
      final themeExtensionsFile = uiPackage.themeExtensionsFile;
      final barrelFile = uiPackage.barrelFile;

      await task(
        'Creating widget files',
        () async => widget.create(),
      );

      // TODO better title
      await task(
        'Adding ThemeExtension to ${p.relative(themeExtensionsFile.path, from: project.path)} ',
        () async => themeExtensionsFile.addThemeExtension(name),
      );

      // TODO better title
      await task(
        'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
        () {
          barrelFile.addExport('src/${name.snakeCase}.dart');
          barrelFile.addExport('src/${name.snakeCase}_theme.dart');
        },
      );

      await dartFormatFix(uiPackage);

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      // TODO: maybe add info which files exists
      _logAndThrow(
        RapidUiException._widgetAlreadyExists(name),
      );
    }
  }

  Future<void> uiRemoveWidget({required String name}) async {
    logger
      ..command('rapid ui remove widget')
      ..newLine();

    final uiPackage = project.uiPackage;
    final widget = uiPackage.widget(name: name, dir: '.');
    if (widget.existsAny()) {
      final themeExtensionsFile = uiPackage.themeExtensionsFile;
      final barrelFile = uiPackage.barrelFile;

      await task(
        'Deleting widget files',
        () async => widget.delete(),
      );

      // TODO better title
      await task(
        'Removing ThemeExtension from ${p.relative(themeExtensionsFile.path, from: project.path)} ',
        () async => themeExtensionsFile.removeThemeExtension(name),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () {
          barrelFile.removeExport('src/${name.snakeCase}.dart');
          barrelFile.removeExport('src/${name.snakeCase}_theme.dart');
        },
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidUiException._widgetNotFound(name),
      );
    }
  }

  Future<void> uiPlatformAddWidget(
    Platform platform, {
    required String name,
  }) async {
    logger
      ..command('rapid ui ${platform.name} add widget')
      ..newLine();

    final platformUiPackage = project.platformUiPackage(platform: platform);
    final widget = platformUiPackage.widget(name: name, dir: '.');
    if (!widget.existsAny()) {
      final themeExtensionsFile = platformUiPackage.themeExtensionsFile;
      final barrelFile = platformUiPackage.barrelFile;

      await task(
        'Creating widget files',
        () async => widget.create(),
      );

      // TODO better title
      await task(
        'Adding ThemeExtension to ${p.relative(themeExtensionsFile.path, from: project.path)} ',
        () async => themeExtensionsFile.addThemeExtension(name),
      );

      // TODO better title
      await task(
        'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
        () {
          barrelFile.addExport('src/${name.snakeCase}.dart');
          barrelFile.addExport('src/${name.snakeCase}_theme.dart');
        },
      );

      await dartFormatFix(platformUiPackage);

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      // TODO: maybe add info which files exists
      _logAndThrow(
        RapidUiException._widgetAlreadyExists(name, platform),
      );
    }
  }

  Future<void> uiPlatformRemoveWidget(
    Platform platform, {
    required String name,
  }) async {
    logger
      ..command('rapid ui ${platform.name} remove widget')
      ..newLine();

    final platformUiPackage = project.platformUiPackage(platform: platform);
    // TODO remove dir completly ?
    final widget = platformUiPackage.widget(name: name, dir: '.');

    if (widget.existsAny()) {
      final themeExtensionsFile = platformUiPackage.themeExtensionsFile;
      final barrelFile = platformUiPackage.barrelFile;

      await task(
        'Deleting widget files',
        () async => widget.delete(),
      );

      // TODO better title
      await task(
        'Removing ThemeExtension from ${p.relative(themeExtensionsFile.path, from: project.path)} ',
        () async => themeExtensionsFile.removeThemeExtension(name),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () {
          barrelFile.removeExport('src/${name.snakeCase}.dart');
          barrelFile.removeExport('src/${name.snakeCase}_theme.dart');
        },
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidUiException._widgetNotFound(name, platform),
      );
    }
  }
}

class RapidUiException extends RapidException {
  RapidUiException._(super.message);

  factory RapidUiException._widgetAlreadyExists(
    String name, [
    Platform? platform,
  ]) {
    final suffix = platform != null ? ' (${platform.prettyName})' : '';
    return RapidUiException._(
      'Widget $name already exists$suffix.',
    );
  }

  factory RapidUiException._widgetNotFound(
    String name, [
    Platform? platform,
  ]) {
    final suffix = platform != null ? ' (${platform.prettyName})' : '';
    return RapidUiException._(
      'Widget $name not found$suffix.',
    );
  }

  @override
  String toString() {
    return 'RapidUiException: $message';
  }
}
