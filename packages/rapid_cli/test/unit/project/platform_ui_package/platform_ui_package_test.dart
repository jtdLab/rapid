import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

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

    group('.create()', () {
      test('completes successfully with correct output (android)', () async {
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
      });

      test('completes successfully with correct output (ios)', () async {
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
      });

      test('completes successfully with correct output (linux)', () async {
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
      });

      test('completes successfully with correct output (macos)', () async {
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
      });

      test('completes successfully with correct output (web)', () async {
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
      });

      test('completes successfully with correct output (windows)', () async {
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
      });
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
      test('completes successfully with correct output (android)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });

      test('completes successfully with correct output (ios)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });

      test('completes successfully with correct output (linux)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });

      test('completes successfully with correct output (macos)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });

      test('completes successfully with correct output (web)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });

      test('completes successfully with correct output (windows)', () async {
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
          () => dartFormatFix(cwd: 'platform_ui_package/path', logger: logger),
        );
      });
    });

    group('.delete()', () {
      test('deletes all related files', () async {
        // Arrange
        final platformUiPackage = getPlatformUiPackage();
        when(() => platformUiPackage.path)
            .thenReturn('platform_ui_package/path');
        final widget = _getWidget(
          platformUiPackage: platformUiPackage,
          name: 'CoolButton',
          dir: 'widget/path',
        );
        final widgetDir = Directory(
          'platform_ui_package/path/lib/src/widget/path/cool_button',
        )..createSync(recursive: true);
        final widgetTestDir = Directory(
          'platform_ui_package/path/test/src/widget/path/cool_button',
        )..createSync(recursive: true);

        // Act
        final logger = FakeLogger();
        widget.delete(logger: logger);

        // Assert
        expect(widgetDir.existsSync(), false);
        expect(widgetTestDir.existsSync(), false);
      });
    });
  });
}
