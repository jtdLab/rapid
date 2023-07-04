part of 'runner.dart';

mixin _UiMixin on _Rapid {
  Future<void> uiAddWidget({required String name}) async =>
      _uiAddWidget(name: name);

  Future<void> uiRemoveWidget({required String name}) async =>
      _uiRemoveWidget(name: name);

  Future<void> uiPlatformAddWidget(
    Platform platform, {
    required String name,
  }) async =>
      _uiAddWidget(platform: platform, name: name);

  Future<void> uiPlatformRemoveWidget(
    Platform platform, {
    required String name,
  }) async =>
      _uiAddWidget(platform: platform, name: name);

  Future<void> _uiAddWidget({
    required String name,
    Platform? platform,
  }) async {
    logger.newLine();

    final uiPackage = switch (platform) {
      null => project.uiModule.uiPackage,
      _ => project.uiModule.platformUiPackage(platform: platform),
    };
    final widget = uiPackage.widget(name: name);
    if (!widget.existsAny) {
      final themeExtensionsFile = uiPackage.themeExtensionsFile;
      final barrelFile = uiPackage.barrelFile;

      await task('Creating widget', () async {
        // TODO maybe 2 sub tasks with create widget and create theme
        await widget.generate();
        barrelFile.addExport('src/${name.snakeCase}.dart');
        // ### TODO
        final projectName = uiPackage.projectName;

        final themes = ['light', 'dark']; // TODO read from file

        for (final theme in themes) {
          final extension = '${projectName.pascalCase}${name}Theme.$theme';
          final existingExtensions = themeExtensionsFile.readTopLevelListVar(
            name: '${theme}Extensions',
          );

          if (!existingExtensions.contains(extension)) {
            themeExtensionsFile.setTopLevelListVar(
              name: '${theme}Extensions',
              value: [
                extension,
                ...existingExtensions,
              ]..sort(),
            );
          }
        }
        // ###
        barrelFile.addExport('src/${name.snakeCase}_theme.dart');
        await dartFormatFix(package: uiPackage);
      });

      logger
        ..newLine()
        ..commandSuccess('Added Widget!');
    } else {
      // TODO: maybe add info which files exists

      throw WidgetAlreadyExistsException._(name);
    }
  }

  Future<void> _uiRemoveWidget({
    required String name,
    Platform? platform,
  }) async {
    logger.newLine();

    final uiPackage = switch (platform) {
      null => project.uiModule.uiPackage,
      _ => project.uiModule.platformUiPackage(platform: platform),
    };
    final widget = uiPackage.widget(name: name);
    if (widget.existsAny) {
      final themeExtensionsFile = uiPackage.themeExtensionsFile;
      final barrelFile = uiPackage.barrelFile;

      await task('Deleting widget', () async {
        // TODO maybe 2 sub tasks with delete widget and delete theme
        widget.delete();
        barrelFile.removeExport('src/${name.snakeCase}.dart');

        // TODO ####
        final projectName = uiPackage.projectName;

        final themes = ['light', 'dark']; // TODO read from file

        for (final theme in themes) {
          final extension = '${projectName.pascalCase}${name}Theme.$theme';
          final existingExtensions = themeExtensionsFile.readTopLevelListVar(
            name: '${theme}Extensions',
          );

          if (existingExtensions.contains(extension)) {
            themeExtensionsFile.setTopLevelListVar(
              name: '${theme}Extensions',
              value: existingExtensions..remove(extension),
            );
          }
        }

        // ####

        barrelFile.removeExport('src/${name.snakeCase}_theme.dart');
      });

      logger
        ..newLine()
        ..commandSuccess('Removed Widget!');
    } else {
      throw WidgetNotFoundException._(name);
    }
  }
}

class WidgetAlreadyExistsException extends RapidException {
  WidgetAlreadyExistsException._(this.name);

  final String name;

  @override
  String toString() {
    return 'Widget $name already exists.';
  }
}

class WidgetNotFoundException extends RapidException {
  WidgetNotFoundException._(this.name);

  final String name;

  @override
  String toString() {
    return 'Widget $name not found.';
  }
}
