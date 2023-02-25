import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const themeExtensionsFileEmpty = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

const lightExtensions = <ThemeExtension>[];

const darkExtensions = <ThemeExtension>[];
''';

const themeExtensionsFileWithExtensions = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

import 'cool_widget/cool_widget_theme.dart';

const lightExtensions = <ThemeExtension>[
  MyProjectCoolWidgetTheme.light,
];

const darkExtensions = <ThemeExtension>[
  MyProjectCoolWidgetTheme.dark,
];
''';

const themeExtensionsFileWithMoreExtensions = '''
import 'package:ab_cd_ui_android/ab_cd_ui_android.dart';

import 'cool_widget/cool_widget_theme.dart';
import 'sweet_widget/sweet_widget_theme.dart';

const lightExtensions = <ThemeExtension>[
  MyProjectCoolWidgetTheme.light,
  MyProjectSweetWidgetTheme.light,
];

const darkExtensions = <ThemeExtension>[
  MyProjectCoolWidgetTheme.dark,
  MyProjectSweetWidgetTheme.dark,
];
''';

PlatformUiPackage _getPlatformUiPackage(
  Platform platform, {
  Project? project,
  GeneratorBuilder? generator,
}) {
  return PlatformUiPackage(
    platform,
    project: project ?? getProject(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

Widget _getWidget({
  required String name,
  required String dir,
  required PlatformUiPackage platformUiPackage,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return Widget(
    name: name,
    dir: dir,
    platformUiPackage: platformUiPackage,
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

ThemeExtensionsFile _getThemeExtensionsFile({
  PlatformUiPackage? platformUiPackage,
}) {
  return ThemeExtensionsFile(
    platformUiPackage: platformUiPackage ?? getPlatformUiPackage(),
  );
}

void main() {
  group('PlatformUiPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.path', () {
      test('(android)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.android,
          project: project,
        );

        // Act + Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_android',
        );
      });

      test('(ios)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.ios,
          project: project,
        );

        // Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_ios',
        );
      });

      test('(linux)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.linux,
          project: project,
        );

        // Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_linux',
        );
      });

      test('(macos)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.macos,
          project: project,
        );

        // Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_macos',
        );
      });

      test('(web)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.web,
          project: project,
        );

        // Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_web',
        );
      });

      test('(windows)', () {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name()).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          Platform.windows,
          project: project,
        );

        // Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_windows',
        );
      });
    });

    group('.themeExtensionsFile', () {
      test('(android)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.android);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });

      test('(ios)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.ios);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });

      test('(linux)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.linux);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });

      test('(macos)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.macos);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });

      test('(web)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.web);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });

      test('(windows)', () {
        // Arrange
        final platformUiPackage = _getPlatformUiPackage(Platform.windows);

        // Act + Assert
        expect(
          platformUiPackage.themeExtensionsFile,
          isA<ThemeExtensionsFile>().having(
            (extFile) => extFile.platformUiPackage,
            'platformUiPackage',
            platformUiPackage,
          ),
        );
      });
    });

    group('.create()', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.android,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_android',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.ios,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_ios',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': true,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.linux,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_linux',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.macos,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_macos',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.web,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_web',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': true,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final platformUiPackage = _getPlatformUiPackage(
            Platform.windows,
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await platformUiPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project_ui/my_project_ui_windows',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    test('.widget()', () {
      // Arrange
      final platformUiPackage = _getPlatformUiPackage(Platform.android);

      // Act + Assert
      expect(
        platformUiPackage.widget(name: 'FooBar', dir: 'some/path'),
        isA<Widget>()
            .having((widget) => widget.name, 'name', 'FooBar')
            .having((widget) => widget.dir, 'name', 'some/path')
            .having(
              (widget) => widget.platformUiPackage,
              'platformUiPackage',
              platformUiPackage,
            ),
      );
    });
  });

  group('Widget', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.create()', () {
      test(
        'completes successfully with correct output (android)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.android);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': true,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (ios)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.ios);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': false,
                'ios': true,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (linux)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.linux);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': false,
                'ios': false,
                'linux': true,
                'macos': false,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (macos)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.macos);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': true,
                'web': false,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (web)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.web);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': true,
                'windows': false,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );

      test(
        'completes successfully with correct output (windows)',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          when(() => platformUiPackage.project).thenReturn(project);
          when(() => platformUiPackage.platform).thenReturn(Platform.windows);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final widget = _getWidget(
            name: 'CoolButton',
            dir: 'widget/path',
            platformUiPackage: platformUiPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await widget.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'platform_ui_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'CoolButton',
                'output_dir': 'widget/path',
                'android': false,
                'ios': false,
                'linux': false,
                'macos': false,
                'web': false,
                'windows': true,
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'platform_ui_package/path',
              logger: logger,
            ),
          );
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          final widget = _getWidget(
            platformUiPackage: platformUiPackage,
            name: 'CoolButton',
            dir: '.',
          );
          final widgetDir = Directory(
            'platform_ui_package/path/lib/src/cool_button',
          )..createSync(recursive: true);
          final widgetTestDir = Directory(
            'platform_ui_package/path/test/src/cool_button',
          )..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          widget.delete(logger: logger);

          // Assert
          expect(widgetDir.existsSync(), false);
          expect(widgetTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.path)
              .thenReturn('platform_ui_package/path');
          final widget = _getWidget(
            platformUiPackage: platformUiPackage,
            name: 'CoolButton',
            dir: 'foo',
          );
          final widgetDir = Directory(
            'platform_ui_package/path/lib/src/foo/cool_button',
          )..createSync(recursive: true);
          final widgetTestDir = Directory(
            'platform_ui_package/path/test/src/foo/cool_button',
          )..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          widget.delete(logger: logger);

          // Assert
          expect(
            Directory(
              'platform_ui_package/path/lib/src/foo/cool_button',
            ).existsSync(),
            false,
          );
          expect(
            Directory(
              'platform_ui_package/path/test/src/foo/cool_button',
            ).existsSync(),
            false,
          );
          expect(widgetDir.existsSync(), false);
          expect(widgetTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('ThemeExtensionsFile', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
    });

    test('.platformUiPackage', () {
      // Arrange
      final platformUiPackage = getPlatformUiPackage();
      final themeExtensionsFile = _getThemeExtensionsFile(
        platformUiPackage: platformUiPackage,
      );

      // Act + Assert
      expect(themeExtensionsFile.platformUiPackage, platformUiPackage);
    });

    group('.addThemeExtension()', () {
      test(
        'adds import and the light and dark theme extension correctly',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileEmpty);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('CoolWidget');
          themeExtensionsFile.addThemeExtension(widget);

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileWithExtensions);
        }),
      );

      test(
        'adds import and the light and dark theme extension correctly when diffrent packages already present',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileWithExtensions);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('SweetWidget');
          themeExtensionsFile.addThemeExtension(widget);

          // Assert
          expect(
            file.readAsStringSync(),
            themeExtensionsFileWithMoreExtensions,
          );
        }),
      );

      test(
        'does nothing when same package already present',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileWithExtensions);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('CoolWidget');
          themeExtensionsFile.addThemeExtension(widget);

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileWithExtensions);
        }),
      );
    });

    group('.removeThemeExtension()', () {
      test(
        'removes import and the localizations delegate correctly',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileWithExtensions);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('CoolWidget');
          themeExtensionsFile.removeThemeExtension(widget);

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileEmpty);
        }),
      );

      test(
        'removes import and the localizations delegate correctly when diffrent packages already present',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileWithMoreExtensions);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('SweetWidget');
          themeExtensionsFile.removeThemeExtension(widget);

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileWithExtensions);
        }),
      );

      test(
        'does nothing when no packages are present',
        withTempDir(() {
          // Arrange
          final themeExtensionsFile = _getThemeExtensionsFile();
          final file = File(themeExtensionsFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(themeExtensionsFileEmpty);

          // Act
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          final widget = getWidget();
          when(() => widget.platformUiPackage).thenReturn(platformUiPackage);
          when(() => widget.name).thenReturn('CoolWidget');
          themeExtensionsFile.removeThemeExtension(widget);

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileEmpty);
        }),
      );
    });
  });
}
