import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_env.dart';
import '../../mocks.dart';

Widget _getWidget({
  String? projectName,
  Platform? platform,
  String? name,
  String? path,
}) {
  return Widget(
    projectName: projectName ?? 'projectName',
    platform: platform,
    name: name ?? 'Name',
    path: path ?? 'path',
  );
}

ThemedWidget _getThemedWidget({
  String? projectName,
  Platform? platform,
  String? name,
  String? path,
}) {
  return ThemedWidget(
    projectName: projectName ?? 'projectName',
    platform: platform,
    name: name ?? 'Name',
    path: path ?? 'path',
  );
}

Theme _getTheme({
  String? widgetName,
  String? path,
}) {
  return Theme(
    widgetName: widgetName ?? 'Cool',
    path: path ?? 'path',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('Widget', () {
    test('file', () {
      final widget = _getWidget(path: '/path/to/ui_package', name: 'MyWidget');

      expect(widget.file.path, '/path/to/ui_package/lib/src/my_widget.dart');
    });

    test('testFile', () {
      final widget = _getWidget(path: '/path/to/ui_package', name: 'MyWidget');

      expect(
        widget.testFile.path,
        '/path/to/ui_package/test/src/my_widget_test.dart',
      );
    });

    test('entities', () {
      final widget = _getWidget();

      expect(
        widget.entities,
        entityEquals([widget.file, widget.testFile]),
      );
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final widget = _getWidget(
          projectName: 'test_project',
          name: 'CoolButton',
          path: '/path/to/ui_package',
          platform: Platform.android,
        );

        await widget.generate();

        verifyInOrder([
          () => generatorBuilder(widgetBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/ui_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'name': 'CoolButton',
                  'platform': 'android',
                  'android': true,
                  'ios': false,
                  'linux': false,
                  'macos': false,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
        ]);
      }),
    );
  });

  group('ThemedWidget', () {
    test('entities', () {
      final themedWidget = _getThemedWidget();

      expect(
        themedWidget.entities,
        entityEquals([
          themedWidget.file,
          themedWidget.testFile,
          themedWidget.theme.file,
          themedWidget.theme.tailorFile,
          themedWidget.theme.testFile,
        ]),
      );
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final widget = _getThemedWidget(
          projectName: 'test_project',
          name: 'CoolButton',
          path: '/path/to/ui_package',
          platform: Platform.macos,
        );

        await widget.generate();

        verifyInOrder([
          () => generatorBuilder(themedWidgetBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/ui_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'name': 'CoolButton',
                  'platform': 'macos',
                  'android': false,
                  'ios': false,
                  'linux': false,
                  'macos': true,
                  'web': false,
                  'windows': false,
                  'mobile': false,
                },
              ),
        ]);
      }),
    );
  });

  group('Theme', () {
    test('themeFile', () {
      final theme = _getTheme(
        widgetName: 'MyThemedWidget',
        path: '/path/to/ui_package',
      );

      expect(
        theme.file.path,
        '/path/to/ui_package/lib/src/my_themed_widget_theme.dart',
      );
    });

    test('themeTailorFile', () {
      final theme = _getTheme(
        widgetName: 'MyThemedWidget',
        path: '/path/to/ui_package',
      );

      expect(
        theme.tailorFile.path,
        '/path/to/ui_package/lib/src/my_themed_widget_theme.tailor.dart',
      );
    });

    test('themeTestFile', () {
      final theme = _getTheme(
        widgetName: 'MyThemedWidget',
        path: '/path/to/ui_package',
      );

      expect(
        theme.testFile.path,
        '/path/to/ui_package/test/src/my_themed_widget_theme_test.dart',
      );
    });
  });
}
