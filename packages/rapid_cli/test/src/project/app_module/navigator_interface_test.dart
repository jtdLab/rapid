import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_env.dart';
import '../../mocks.dart';

NavigatorInterface _getNavigatorInterface({
  String? path,
  String? name,
}) {
  return NavigatorInterface(
    path: path ?? 'path',
    name: name ?? 'Name',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('NavigatorInterface', () {
    test('file', () {
      final navigator = _getNavigatorInterface(
        path: '/path/to/platform_navigation_package',
        name: 'HomePage',
      );

      expect(
        navigator.file.path,
        '/path/to/platform_navigation_package/lib/src/i_home_page_navigator.dart',
      );
    });

    test('entities', () {
      final navigator = _getNavigatorInterface(
        path: '/path/to/platform_navigation_package',
        name: 'HomePage',
      );

      expect(
        navigator.entities,
        entityEquals([
          navigator.file,
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
        final navigator = _getNavigatorInterface(
          path: '/path/to/platform_navigation_package',
          name: 'HomePage',
        );

        await navigator.generate();

        verifyInOrder([
          () => generatorBuilder(navigatorInterfaceBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/platform_navigation_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'name': 'HomePage',
                },
              ),
        ]);
      }),
    );
  });
}
