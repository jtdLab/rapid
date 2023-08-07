import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO(jtdLab): is it good to use global setup instead of setup fcts with records
// TODO(jtdLab): can platform and non platform arrange or verify be shared ?

void main() {
  late Widget widget;
  late WidgetBuilder widgetBuilder;
  late Theme theme;
  late ThemedWidget themedWidget;
  late ThemedWidgetBuilder themedWidgetBuilder;
  late DartFile uiPackageBarrelFile;
  late DartFile uiPackageThemeExtensionsFile;
  late UiPackage uiPackage;
  late Widget platformWidget;
  late WidgetBuilder platformWidgetBuilder;
  late Theme platformTheme;
  late ThemedWidget platformThemedWidget;
  late ThemedWidgetBuilder platformThemedWidgetBuilder;
  late DartFile platformUiPackageBarrelFile;
  late DartFile platformUiPackageThemeExtensionsFile;
  late PlatformUiPackage platformUiPackage;
  late RapidProject project;

  setUpAll(registerFallbackValues);

  setUp(() {
    widget = MockWidget();
    widgetBuilder = MockWidgetBuilder(widget: widget);
    when(() => widget.entities).thenReturn([
      FakeDartFile(path: 'foo/bar.dart', existsSync: true),
      FakeDartFile(path: 'baz/bam.dart', existsSync: true),
    ]);
    theme = MockTheme();
    when(() => theme.existsAny).thenReturn(false);
    themedWidget = MockThemedWidget();
    when(() => themedWidget.theme).thenReturn(theme);
    when(() => themedWidget.entities).thenReturn([
      FakeDartFile(path: 'fresh/nice.dart', existsSync: true),
      FakeDartFile(path: 'cool/funny.dart', existsSync: true),
    ]);
    themedWidgetBuilder = MockThemedWidgetBuilder(themedWidget: themedWidget);
    uiPackageBarrelFile = MockDartFile();
    uiPackageThemeExtensionsFile = MockDartFile();
    when(
      () => uiPackageThemeExtensionsFile.readTopLevelListVar(
        name: 'lightExtensions',
      ),
    ).thenReturn(['TestProjectNiceButtonTheme.light']);
    when(
      () => uiPackageThemeExtensionsFile.readTopLevelListVar(
        name: 'darkExtensions',
      ),
    ).thenReturn(['TestProjectNiceButtonTheme.dark']);
    uiPackage = MockUiPackage(
      widget: widgetBuilder.call,
      themedWidget: themedWidgetBuilder.call,
      barrelFile: uiPackageBarrelFile,
      themeExtensionsFile: uiPackageThemeExtensionsFile,
    );
    platformWidget = MockWidget();
    when(() => platformWidget.entities).thenReturn([
      FakeDartFile(path: 'foo/bar.dart', existsSync: true),
      FakeDartFile(path: 'baz/bam.dart', existsSync: true),
    ]);
    platformWidgetBuilder = MockWidgetBuilder(widget: platformWidget);
    platformTheme = MockTheme();
    when(() => platformTheme.existsAny).thenReturn(false);
    platformThemedWidget = MockThemedWidget();
    when(() => platformThemedWidget.theme).thenReturn(platformTheme);
    when(() => platformThemedWidget.entities).thenReturn([
      FakeDartFile(path: 'fresh/nice.dart', existsSync: true),
      FakeDartFile(path: 'cool/funny.dart', existsSync: true),
    ]);
    platformThemedWidgetBuilder =
        MockThemedWidgetBuilder(themedWidget: platformThemedWidget);
    platformUiPackageBarrelFile = MockDartFile();
    platformUiPackageThemeExtensionsFile = MockDartFile();
    when(
      () => platformUiPackageThemeExtensionsFile.readTopLevelListVar(
        name: 'lightExtensions',
      ),
    ).thenReturn(['TestProjectNiceButtonTheme.light']);
    when(
      () => platformUiPackageThemeExtensionsFile.readTopLevelListVar(
        name: 'darkExtensions',
      ),
    ).thenReturn(['TestProjectNiceButtonTheme.dark']);
    platformUiPackage = MockPlatformUiPackage(
      widget: platformWidgetBuilder.call,
      themedWidget: platformThemedWidgetBuilder.call,
      barrelFile: platformUiPackageBarrelFile,
      themeExtensionsFile: platformUiPackageThemeExtensionsFile,
    );
    project = MockRapidProject(
      name: 'test_project',
      path: 'project_path',
      uiModule: MockUiModule(
        uiPackage: uiPackage,
        platformUiPackage: ({required platform}) => platformUiPackage,
      ),
    );
  });

  group('uiAddWidget', () {
    test(
      'throws WidgetAlreadyExistsException when widget already exists',
      () async {
        when(() => widget.existsAny).thenReturn(true);
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
      },
    );

    test(
      'throws WidgetAlreadyExistsException when themed widget already exists',
      () async {
        when(() => themedWidget.existsAny).thenReturn(true);
        final rapid = getRapid(project: project);

        expect(
          () => rapid.uiAddWidget(name: 'CoolButton', theme: true),
          throwsA(
            isA<WidgetAlreadyExistsException>().having(
              (e) => e.toString(),
              'toString',
              multiLine([
                'Some files of Widget CoolButton already exist.',
                'Existing file(s):',
                '',
                'fresh/nice.dart',
                'cool/funny.dart',
              ]),
            ),
          ),
        );
      },
    );

    test(
      'creates widget',
      withMockEnv((manager) async {
        when(() => widget.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.uiAddWidget(name: 'CoolButton', theme: false);

        verifyInOrder([
          logger.newLine,
          () => widgetBuilder(name: 'CoolButton'),
          () => logger.progress('Creating widget'),
          () => widget.generate(),
          () => uiPackageBarrelFile.addExport('src/cool_button.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'creates themed widget',
      withMockEnv((manager) async {
        when(() => themedWidget.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.uiAddWidget(name: 'CoolButton', theme: true);

        verifyInOrder([
          logger.newLine,
          () => themedWidgetBuilder(name: 'CoolButton'),
          () => logger.progress('Creating widget'),
          () => themedWidget.generate(),
          () => uiPackageBarrelFile.addExport('src/cool_button.dart'),
          () => uiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'lightExtensions',
                value: [
                  'TestProjectCoolButtonTheme.light',
                  'TestProjectNiceButtonTheme.light',
                ],
              ),
          () => uiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'darkExtensions',
                value: [
                  'TestProjectCoolButtonTheme.dark',
                  'TestProjectNiceButtonTheme.dark',
                ],
              ),
          () => uiPackageBarrelFile.addExport('src/cool_button_theme.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('uiPlatformAddWidget', () {
    test(
      'throws WidgetAlreadyExistsException when widget already exists',
      () async {
        when(() => platformWidget.existsAny).thenReturn(true);
        final rapid = getRapid(project: project);

        final platform = randomPlatform();
        expect(
          () => rapid.uiPlatformAddWidget(
            platform,
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
      },
    );

    test(
      'throws WidgetAlreadyExistsException when themed widget already exists',
      () async {
        when(() => platformThemedWidget.existsAny).thenReturn(true);
        final rapid = getRapid(project: project);

        final platform = randomPlatform();
        expect(
          () => rapid.uiPlatformAddWidget(
            platform,
            name: 'CoolButton',
            theme: true,
          ),
          throwsA(
            isA<WidgetAlreadyExistsException>().having(
              (e) => e.toString(),
              'toString',
              multiLine([
                'Some files of Widget CoolButton already exist.',
                'Existing file(s):',
                '',
                'fresh/nice.dart',
                'cool/funny.dart',
              ]),
            ),
          ),
        );
      },
    );

    test(
      'creates widget',
      withMockEnv((manager) async {
        when(() => platformWidget.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        final platform = randomPlatform();
        await rapid.uiPlatformAddWidget(
          platform,
          name: 'CoolButton',
          theme: false,
        );

        verifyInOrder([
          logger.newLine,
          () => platformWidgetBuilder(name: 'CoolButton'),
          () => logger.progress('Creating widget'),
          () => platformWidget.generate(),
          () => platformUiPackageBarrelFile.addExport('src/cool_button.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'creates themed widget',
      withMockEnv((manager) async {
        when(() => platformThemedWidget.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        final platform = randomPlatform();
        await rapid.uiPlatformAddWidget(
          platform,
          name: 'CoolButton',
          theme: true,
        );

        verifyInOrder([
          logger.newLine,
          () => platformThemedWidgetBuilder(name: 'CoolButton'),
          () => logger.progress('Creating widget'),
          () => platformThemedWidget.generate(),
          () => platformUiPackageBarrelFile.addExport('src/cool_button.dart'),
          () => platformUiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'lightExtensions',
                value: [
                  'TestProjectCoolButtonTheme.light',
                  'TestProjectNiceButtonTheme.light',
                ],
              ),
          () => platformUiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'darkExtensions',
                value: [
                  'TestProjectCoolButtonTheme.dark',
                  'TestProjectNiceButtonTheme.dark',
                ],
              ),
          () => platformUiPackageBarrelFile
              .addExport('src/cool_button_theme.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('uiRemoveWidget', () {
    test(
      'throws WidgetNotFoundException when widget does not exist',
      () async {
        when(() => widget.existsAny).thenReturn(false);
        final rapid = getRapid(project: project);

        expect(
          () => rapid.uiRemoveWidget(
            name: 'CoolButton',
          ),
          throwsA(isA<WidgetNotFoundException>()),
        );
      },
    );

    test(
      'deletes widget',
      withMockEnv((manager) async {
        when(() => widget.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.uiRemoveWidget(name: 'NiceButton');

        verifyInOrder([
          logger.newLine,
          () => widgetBuilder(name: 'NiceButton'),
          () => logger.progress('Deleting widget'),
          () => widget.delete(),
          () => uiPackageBarrelFile.removeExport('src/nice_button.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'deletes themed widget',
      withMockEnv((manager) async {
        when(() => theme.existsAny).thenReturn(true);
        when(() => themedWidget.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.uiRemoveWidget(name: 'NiceButton');

        verifyInOrder([
          logger.newLine,
          () => themedWidgetBuilder(name: 'NiceButton'),
          () => logger.progress('Deleting widget'),
          () => themedWidget.delete(),
          () => uiPackageBarrelFile.removeExport('src/nice_button.dart'),
          () => uiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'lightExtensions',
                value: [],
              ),
          () => uiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'darkExtensions',
                value: [],
              ),
          () => uiPackageBarrelFile.removeExport('src/nice_button_theme.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('uiPlatformRemoveWidget', () {
    test(
      'throws WidgetNotFoundException when widget not found',
      () async {
        final platform = randomPlatform();
        when(() => platformWidget.existsAny).thenReturn(false);
        final rapid = getRapid(project: project);

        expect(
          () => rapid.uiPlatformRemoveWidget(platform, name: 'CoolButton'),
          throwsA(isA<WidgetNotFoundException>()),
        );
      },
    );

    test(
      'deletes widget',
      withMockEnv((manager) async {
        when(() => platformWidget.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        final platform = randomPlatform();
        await rapid.uiPlatformRemoveWidget(
          platform,
          name: 'NiceButton',
        );

        verifyInOrder([
          logger.newLine,
          () => platformWidgetBuilder(name: 'NiceButton'),
          () => logger.progress('Deleting widget'),
          () => platformWidget.delete(),
          () =>
              platformUiPackageBarrelFile.removeExport('src/nice_button.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    test(
      'deletes themed widget',
      withMockEnv((manager) async {
        when(() => platformTheme.existsAny).thenReturn(true);
        when(() => platformThemedWidget.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        final platform = randomPlatform();
        await rapid.uiPlatformRemoveWidget(
          platform,
          name: 'NiceButton',
        );

        verifyInOrder([
          logger.newLine,
          () => platformThemedWidgetBuilder(name: 'NiceButton'),
          () => logger.progress('Deleting widget'),
          () => platformThemedWidget.delete(),
          () =>
              platformUiPackageBarrelFile.removeExport('src/nice_button.dart'),
          () => platformUiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'lightExtensions',
                value: [],
              ),
          () => platformUiPackageThemeExtensionsFile.setTopLevelListVar(
                name: 'darkExtensions',
                value: [],
              ),
          () => platformUiPackageBarrelFile
              .removeExport('src/nice_button_theme.dart'),
          progress.complete,
          logger.newLine,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Widget!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });
}
