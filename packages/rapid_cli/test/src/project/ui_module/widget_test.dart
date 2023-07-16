import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_fs.dart';
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
                  'platform': 'android'
                },
              ),
        ]);
      }),
    );
  });

  group('ThemedWidget', () {
    test('themeFile', () {
      final themedWidget = _getThemedWidget(
        path: '/path/to/ui_package',
        name: 'MyThemedWidget',
      );

      expect(
        themedWidget.themeFile.path,
        '/path/to/ui_package/lib/src/my_themed_widget_theme.dart',
      );
    });

    test('themeTailorFile', () {
      final themedWidget = _getThemedWidget(
        path: '/path/to/ui_package',
        name: 'MyThemedWidget',
      );

      expect(
        themedWidget.themeTailorFile.path,
        '/path/to/ui_package/lib/src/my_themed_widget_theme.tailor.dart',
      );
    });

    test('themeTestFile', () {
      final themedWidget = _getThemedWidget(
        path: '/path/to/ui_package',
        name: 'MyThemedWidget',
      );

      expect(
        themedWidget.themeTestFile.path,
        '/path/to/ui_package/test/src/my_themed_widget_theme_test.dart',
      );
    });

    test('entities', () {
      final themedWidget = _getThemedWidget();

      expect(
        themedWidget.entities,
        entityEquals([
          themedWidget.file,
          themedWidget.testFile,
          themedWidget.themeFile,
          themedWidget.themeTailorFile,
          themedWidget.themeTestFile,
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
                  'platform': 'macos'
                },
              ),
        ]);
      }),
    );
  });
}
