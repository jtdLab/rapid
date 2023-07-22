import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('uiAddWidget', () {
    test('creates widget', () async {
      final manager = MockProcessManager();
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final uiPackage = MockUiPackage(
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiAddWidget(name: 'CoolButton', theme: false),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => uiPackage.widget(name: 'CoolButton'),
        () => widget.generate(),
        () => barrelFile.addExport('src/cool_button.dart'),
        () => logger.newLine(),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Widget!')
      ]);
    });

    test('creates themed widget', () async {
      final manager = MockProcessManager();
      final themedWidget = MockThemedWidget();
      when(() => themedWidget.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final themeExtensionFile = MockDartFile();
      when(() =>
              themeExtensionFile.readTopLevelListVar(name: 'lightExtensions'))
          .thenReturn(['TestProjectNiceButtonTheme.light']);
      when(() => themeExtensionFile.readTopLevelListVar(name: 'darkExtensions'))
          .thenReturn(['TestProjectNiceButtonTheme.dark']);
      final uiPackage = MockUiPackage(
        themedWidget: ({required name}) => themedWidget,
        barrelFile: barrelFile,
        themeExtensionsFile: themeExtensionFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiAddWidget(name: 'CoolButton', theme: true),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => uiPackage.themedWidget(name: 'CoolButton'),
        () => themedWidget.generate(),
        () => barrelFile.addExport('src/cool_button.dart'),
        () => logger.newLine(),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'lightExtensions',
              value: [
                'TestProjectCoolButtonTheme.light',
                'TestProjectNiceButtonTheme.light',
              ],
            ),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'darkExtensions',
              value: [
                'TestProjectCoolButtonTheme.dark',
                'TestProjectNiceButtonTheme.dark',
              ],
            ),
        () => barrelFile.addExport('src/cool_button_theme.dart'),
        () => logger.newLine(),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Widget!')
      ]);
    });

    test('throws WidgetAlreadyExistsException when widget already exists',
        () async {
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(true);
      final entities = [
        MockDartFile(path: 'foo/bar.dart', existsSync: true),
        MockDartFile(path: 'baz/bam.dart', existsSync: true),
      ];
      when(() => widget.entities).thenReturn(entities);
      final barrelFile = MockDartFile();
      final uiPackage = MockUiPackage(
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.uiAddWidget(name: 'CoolButton', theme: false),
        throwsA(
          isA<WidgetAlreadyExistsException>().having(
            (e) => e.toString(),
            'toString',
            multiLine([
              'Some files of Widget CoolButton already exist.',
              'Existing file(s):',
              '',
              'foo/bar.dart',
              'baz/bam.dart',
            ]),
          ),
        ),
      );
    });
  });

  group('uiPlatformAddWidget', () {
    test('creates widget', () async {
      final manager = MockProcessManager();
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final platformUiPackage = MockPlatformUiPackage(
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiPlatformAddWidget(
          Platform.android,
          name: 'CoolButton',
          theme: false,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformUiPackage.widget(name: 'CoolButton'),
        () => widget.generate(),
        () => barrelFile.addExport('src/cool_button.dart'),
        () => logger.newLine(),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Widget!')
      ]);
    });

    test('creates themed widget', () async {
      final manager = MockProcessManager();
      final themedWidget = MockThemedWidget();
      when(() => themedWidget.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final themeExtensionFile = MockDartFile();
      when(() =>
              themeExtensionFile.readTopLevelListVar(name: 'lightExtensions'))
          .thenReturn(['TestProjectNiceButtonTheme.light']);
      when(() => themeExtensionFile.readTopLevelListVar(name: 'darkExtensions'))
          .thenReturn(['TestProjectNiceButtonTheme.dark']);
      final platformUiPackage = MockPlatformUiPackage(
        themedWidget: ({required name}) => themedWidget,
        barrelFile: barrelFile,
        themeExtensionsFile: themeExtensionFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiPlatformAddWidget(
          Platform.android,
          name: 'CoolButton',
          theme: true,
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformUiPackage.themedWidget(name: 'CoolButton'),
        () => themedWidget.generate(),
        () => barrelFile.addExport('src/cool_button.dart'),
        () => logger.newLine(),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'lightExtensions',
              value: [
                'TestProjectCoolButtonTheme.light',
                'TestProjectNiceButtonTheme.light',
              ],
            ),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'darkExtensions',
              value: [
                'TestProjectCoolButtonTheme.dark',
                'TestProjectNiceButtonTheme.dark',
              ],
            ),
        () => barrelFile.addExport('src/cool_button_theme.dart'),
        () => logger.newLine(),
        ...dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Widget!')
      ]);
    });

    test('throws WidgetAlreadyExistsException when widget already exists',
        () async {
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(true);
      final entities = [
        MockDartFile(path: 'foo/bar.dart', existsSync: true),
        MockDartFile(path: 'baz/bam.dart', existsSync: true),
      ];
      when(() => widget.entities).thenReturn(entities);
      final barrelFile = MockDartFile();
      final platformUiPackage = MockPlatformUiPackage(
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.uiPlatformAddWidget(
          Platform.android,
          name: 'CoolButton',
          theme: false,
        ),
        throwsA(
          isA<WidgetAlreadyExistsException>().having(
            (e) => e.toString(),
            'toString',
            multiLine([
              'Some files of Widget CoolButton already exist.',
              'Existing file(s):',
              '',
              'foo/bar.dart',
              'baz/bam.dart',
            ]),
          ),
        ),
      );
    });
  });

  group('uiRemoveWidget', () {
    test('deletes widget', () async {
      final manager = MockProcessManager();
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(false);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(false);
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final uiPackage = MockUiPackage(
        themedWidget: ({required name}) => themedWidget,
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiRemoveWidget(name: 'CoolButton'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => uiPackage.widget(name: 'CoolButton'),
        () => widget.delete(),
        () => barrelFile.removeExport('src/cool_button.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Widget!')
      ]);
    });

    test('deletes themed widget', () async {
      final manager = MockProcessManager();
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(true);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final themeExtensionFile = MockDartFile();
      when(() =>
              themeExtensionFile.readTopLevelListVar(name: 'lightExtensions'))
          .thenReturn([
        'TestProjectCoolButtonTheme.light',
        'TestProjectNiceButtonTheme.light',
      ]);
      when(() => themeExtensionFile.readTopLevelListVar(name: 'darkExtensions'))
          .thenReturn([
        'TestProjectCoolButtonTheme.dark',
        'TestProjectNiceButtonTheme.dark',
      ]);
      when(() => barrelFile.existsSync()).thenReturn(true);
      final uiPackage = MockUiPackage(
        themedWidget: ({required name}) => themedWidget,
        barrelFile: barrelFile,
        themeExtensionsFile: themeExtensionFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.uiRemoveWidget(name: 'CoolButton'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => uiPackage.themedWidget(name: 'CoolButton'),
        () => themedWidget.delete(),
        () => barrelFile.removeExport('src/cool_button.dart'),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'lightExtensions',
              value: [
                'TestProjectNiceButtonTheme.light',
              ],
            ),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'darkExtensions',
              value: [
                'TestProjectNiceButtonTheme.dark',
              ],
            ),
        () => barrelFile.removeExport('src/cool_button_theme.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Widget!')
      ]);
    });

    test('throws WidgetNotFoundException when widget not found', () async {
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(false);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(false);
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(false);
      final uiPackage = MockUiPackage(
        themedWidget: ({required name}) => themedWidget,
        widget: ({required name}) => widget,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(uiPackage: uiPackage),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.uiRemoveWidget(name: 'CoolButton'),
        throwsA(isA<WidgetNotFoundException>()),
      );
    });
  });

  group('uiPlatformRemoveWidget', () {
    test('deletes widget', () async {
      final manager = MockProcessManager();
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(false);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(false);
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final platformUiPackage = MockPlatformUiPackage(
        themedWidget: ({required name}) => themedWidget,
        widget: ({required name}) => widget,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async =>
            rapid.uiPlatformRemoveWidget(Platform.android, name: 'CoolButton'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformUiPackage.widget(name: 'CoolButton'),
        () => widget.delete(),
        () => barrelFile.removeExport('src/cool_button.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Widget!')
      ]);
    });

    test('deletes themed widget', () async {
      final manager = MockProcessManager();
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(true);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final themeExtensionFile = MockDartFile();
      when(() =>
              themeExtensionFile.readTopLevelListVar(name: 'lightExtensions'))
          .thenReturn([
        'TestProjectCoolButtonTheme.light',
        'TestProjectNiceButtonTheme.light',
      ]);
      when(() => themeExtensionFile.readTopLevelListVar(name: 'darkExtensions'))
          .thenReturn([
        'TestProjectCoolButtonTheme.dark',
        'TestProjectNiceButtonTheme.dark',
      ]);
      when(() => barrelFile.existsSync()).thenReturn(true);
      final platformUiPackage = MockPlatformUiPackage(
        themedWidget: ({required name}) => themedWidget,
        barrelFile: barrelFile,
        themeExtensionsFile: themeExtensionFile,
      );
      final project = MockRapidProject(
        name: 'test_project',
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async =>
            rapid.uiPlatformRemoveWidget(Platform.android, name: 'CoolButton'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => platformUiPackage.themedWidget(name: 'CoolButton'),
        () => themedWidget.delete(),
        () => barrelFile.removeExport('src/cool_button.dart'),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'lightExtensions',
              value: [
                'TestProjectNiceButtonTheme.light',
              ],
            ),
        () => themeExtensionFile.setTopLevelListVar(
              name: 'darkExtensions',
              value: [
                'TestProjectNiceButtonTheme.dark',
              ],
            ),
        () => barrelFile.removeExport('src/cool_button_theme.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Widget!')
      ]);
    });

    test('throws WidgetNotFoundException when widget not found', () async {
      final theme = MockTheme();
      when(() => theme.existsAny).thenReturn(false);
      final themedWidget = MockThemedWidget(theme: theme);
      when(() => themedWidget.existsAny).thenReturn(false);
      final widget = MockWidget();
      when(() => widget.existsAny).thenReturn(false);
      final platformUiPackage = MockPlatformUiPackage(
        themedWidget: ({required name}) => themedWidget,
        widget: ({required name}) => widget,
      );
      final project = MockRapidProject(
        uiModule: MockUiModule(
          platformUiPackage: ({required platform}) => platformUiPackage,
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () =>
            rapid.uiPlatformRemoveWidget(Platform.android, name: 'CoolButton'),
        throwsA(isA<WidgetNotFoundException>()),
      );
    });
  });
}
