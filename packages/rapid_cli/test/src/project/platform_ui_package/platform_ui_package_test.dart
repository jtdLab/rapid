void main() {
  // TODO: impl tests
}

/* import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
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
  RapidProject? project,
  WidgetBuilder? widgetBuilder,
  GeneratorBuilder? generator,
}) {
  return PlatformUiPackage(
    platform,
    project: project ?? getProject(),
  )
    ..generatorOverrides = generator
    ..widgetOverrides = widgetBuilder;
}

Widget _getWidget({
  required String name,
  required String dir,
  required PlatformUiPackage platformUiPackage,
  GeneratorBuilder? generator,
}) {
  return Widget(
    name: name,
    dir: dir,
    platformUiPackage: platformUiPackage,
  )..generatorOverrides = generator;
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
      void performTest(Platform platform) {
        // Arrange
        final project = getProject();
        when(() => project.path).thenReturn('project/path');
        when(() => project.name).thenReturn('my_project');
        final platformUiPackage = _getPlatformUiPackage(
          platform,
          project: project,
        );

        // Act + Assert
        expect(
          platformUiPackage.path,
          'project/path/packages/my_project_ui/my_project_ui_$platform.name',
        );
      }

      test('(android)', () => performTest(Platform.android));

      test('(ios)', () => performTest(Platform.ios));

      test('(linux)', () => performTest(Platform.linux));

      test('(macos)', () => performTest(Platform.macos));

      test('(web)', () => performTest(Platform.web));

      test('(windows)', () => performTest(Platform.windows));
    });

    group('.create()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async =>
            withTempDir(() async {
              // Arrange
              final project = getProject();
              when(() => project.path).thenReturn('project/path');
              when(() => project.name).thenReturn('my_project');
              final generator = getMasonGenerator();
              final platformUiPackage = _getPlatformUiPackage(
                platform,
                project: project,
                generator: (_) async => generator,
              );

              // Act
              final logger = FakeLogger();
              await platformUiPackage.create(logger: logger);

              // Assert
              verify(
                () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (g) => g.dir.path,
                      'dir',
                      'project/path/packages/my_project_ui/my_project_ui_${platform.name}',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'my_project',
                    'android': platform == Platform.android,
                    'ios': platform == Platform.ios,
                    'linux': platform == Platform.linux,
                    'macos': platform == Platform.macos,
                    'web': platform == Platform.web,
                    'windows': platform == Platform.windows,
                  },
                  logger: logger,
                ),
              ).called(1);
            });

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.addWidget()', () {
      group('completes successfully with correct output', () {
        void performTest(Platform platform) {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(false);
          final widgetBuilder = getWidgetBuilder(widget);
          final platformUiPackage = _getPlatformUiPackage(
            platform,
            widgetBuilder: widgetBuilder,
          );

          // Act
          final logger = FakeLogger();
          platformUiPackage.addWidget(
            name: 'Cool',
            outputDir: 'my/dir',
            logger: logger,
          );

          // Act + Assert
          verify(
            () => widgetBuilder(
              name: 'Cool',
              dir: 'my/dir',
              platformUiPackage: platformUiPackage,
            ),
          ).called(1);
          verify(() => widget.create(logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws WidgetAlreadyExists when widget exists', () {
        void performTest(Platform platform) {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(true);
          final widgetBuilder = getWidgetBuilder(widget);
          final platformUiPackage = _getPlatformUiPackage(
            platform,
            widgetBuilder: widgetBuilder,
          );

          // Act + Assert
          expect(
            () => platformUiPackage.addWidget(
              name: 'Cool',
              outputDir: 'my/dir',
              logger: FakeLogger(),
            ),
            throwsA(isA<WidgetAlreadyExists>()),
          );
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });

    group('.removeWidget()', () {
      group('completes successfully with correct output', () {
        void performTest(Platform platform) {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(true);
          final widgetBuilder = getWidgetBuilder(widget);
          final platformUiPackage = _getPlatformUiPackage(
            platform,
            widgetBuilder: widgetBuilder,
          );

          // Act
          final logger = FakeLogger();
          platformUiPackage.removeWidget(
            name: 'Cool',
            dir: 'my/dir',
            logger: logger,
          );

          // Act + Assert
          verify(
            () => widgetBuilder(
              name: 'Cool',
              dir: 'my/dir',
              platformUiPackage: platformUiPackage,
            ),
          ).called(1);
          verify(() => widget.delete(logger: logger)).called(1);
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });

      group('throws WidgetDoesNotExist when widget does not exist', () {
        void performTest(Platform platform) {
          // Arrange
          final widget = getWidget();
          when(() => widget.existsAny()).thenReturn(false);
          final widgetBuilder = getWidgetBuilder(widget);
          final platformUiPackage = _getPlatformUiPackage(
            platform,
            widgetBuilder: widgetBuilder,
          );

          // Act + Assert
          expect(
            () => platformUiPackage.removeWidget(
              name: 'Cool',
              dir: 'my/dir',
              logger: FakeLogger(),
            ),
            throwsA(isA<WidgetDoesNotExist>()),
          );
        }

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
    });
  });

  group('Widget', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.create()', () {
      group('completes successfully with correct output', () {
        Future<void> performTest(Platform platform) async =>
            withTempDir(() async {
              // Arrange
              final project = getProject();
              when(() => project.name).thenReturn('my_project');
              final platformUiPackage = getPlatformUiPackage();
              when(() => platformUiPackage.path)
                  .thenReturn('platform_ui_package/path');
              when(() => platformUiPackage.project).thenReturn(project);
              when(() => platformUiPackage.platform).thenReturn(platform);
              final generator = getMasonGenerator();
              final widget = _getWidget(
                name: 'CoolButton',
                dir: 'widget/path',
                platformUiPackage: platformUiPackage,
                generator: (_) async => generator,
              );

              // Act
              final logger = FakeLogger();
              await widget.create(logger: logger);

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
                    'android': platform == Platform.android,
                    'ios': platform == Platform.ios,
                    'linux': platform == Platform.linux,
                    'macos': platform == Platform.macos,
                    'web': platform == Platform.web,
                    'windows': platform == Platform.windows,
                  },
                  logger: logger,
                ),
              ).called(1);
            });

        test('(android)', () => performTest(Platform.android));

        test('(ios)', () => performTest(Platform.ios));

        test('(linux)', () => performTest(Platform.linux));

        test('(macos)', () => performTest(Platform.macos));

        test('(web)', () => performTest(Platform.web));

        test('(windows)', () => performTest(Platform.windows));
      });
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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.addThemeExtension('CoolWidget');

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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.addThemeExtension('SweetWidget');

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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.addThemeExtension('CoolWidget');

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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.removeThemeExtension('CoolWidget');

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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.removeThemeExtension('SweetWidget');

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
          when(() => project.name).thenReturn('my_project');
          final platformUiPackage = getPlatformUiPackage();
          when(() => platformUiPackage.project).thenReturn(project);
          themeExtensionsFile.removeThemeExtension('CoolWidget');

          // Assert
          expect(file.readAsStringSync(), themeExtensionsFileEmpty);
        }),
      );
    });
  });
}
 */
