part of 'runner.dart';

mixin _UiMixin on _Rapid {
  Future<void> uiAddWidget({
    required String name,
    required bool theme,
  }) async =>
      _uiAddWidget(name: name, theme: theme);

  Future<void> uiRemoveWidget({required String name}) async =>
      _uiRemoveWidget(name: name);

  Future<void> uiPlatformAddWidget(
    Platform platform, {
    required String name,
    required bool theme,
  }) async =>
      _uiAddWidget(platform: platform, name: name, theme: theme);

  Future<void> uiPlatformRemoveWidget(
    Platform platform, {
    required String name,
  }) async =>
      _uiRemoveWidget(platform: platform, name: name);

  Future<void> _uiAddWidget({
    required String name,
    required bool theme,
    Platform? platform,
  }) async {
    logger.newLine();

    final uiPackage = switch (platform) {
      null => project.uiModule.uiPackage,
      _ => project.uiModule.platformUiPackage(platform: platform),
    };
    final widget = switch (theme) {
      true => uiPackage.themedWidget(name: name),
      false => uiPackage.widget(name: name),
    };
    if (!widget.existsAny) {
      final barrelFile = uiPackage.barrelFile;

      await task('Creating widget', () async {
        await widget.generate();
        barrelFile.addExport('src/${name.snakeCase}.dart');

        if (widget is ThemedWidget) {
          final themeExtensionsFile = uiPackage.themeExtensionsFile;
          final projectName = project.name;
          // TODO read from theme tailor config file
          final themes = ['light', 'dark'];
          for (final theme in themes) {
            final extension =
                '${projectName.pascalCase}${name.pascalCase}Theme.$theme';
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

          barrelFile.addExport('src/${name.snakeCase}_theme.dart');
        }
      });

      logger.newLine();

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Added Widget!');
    } else {
      throw WidgetAlreadyExistsException._(
        name: name,
        existingEntities: widget.entities
            .whereType<File>()
            .where((e) => e.existsSync())
            .toList(),
      );
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
    final widget = uiPackage.themedWidget(name: name).theme.existsAny
        ? uiPackage.themedWidget(name: name)
        : uiPackage.widget(name: name);
    if (widget.existsAny) {
      final barrelFile = uiPackage.barrelFile;

      await task('Deleting widget', () async {
        widget.delete();
        barrelFile.removeExport('src/${name.snakeCase}.dart');

        if (widget is ThemedWidget) {
          final themeExtensionsFile = uiPackage.themeExtensionsFile;
          final projectName = project.name;

          // TODO read from theme tailor config file
          final themes = ['light', 'dark'];
          for (final theme in themes) {
            final extension =
                '${projectName.pascalCase}${name.pascalCase}Theme.$theme';
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

          barrelFile.removeExport('src/${name.snakeCase}_theme.dart');
        }
      });

      logger.newLine();

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Removed Widget!');
    } else {
      throw WidgetNotFoundException._(name);
    }
  }
}

class WidgetAlreadyExistsException extends RapidException {
  WidgetAlreadyExistsException._({
    required String name,
    required List<File> existingEntities,
  }) : super(
          multiLine(
            [
              'Some files of Widget $name already exist.',
              'Existing file(s):',
              '',
              for (final existingEntity in existingEntities) ...[
                existingEntity.path,
              ],
            ],
          ),
        );
}

class WidgetNotFoundException extends RapidException {
  WidgetNotFoundException._(String name) : super('Widget $name not found.');
}
