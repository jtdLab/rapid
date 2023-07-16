import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

PlatformUiPackage _getPlatformUiPackage({
  String? projectName,
  Platform? platform,
  String? path,
}) {
  return PlatformUiPackage(
    projectName: projectName ?? 'projectName',
    platform: platform ?? Platform.android,
    path: path ?? 'path',
    widget: ({required String name}) => MockWidget(),
    themedWidget: ({required String name}) => MockThemedWidget(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('PlatformUiPackage', () {
    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder;
        final platformUiPackage = _getPlatformUiPackage(
          projectName: 'test_project',
          path: '/path/to/platform_ui_package',
          platform: Platform.ios,
        );

        await platformUiPackage.generate();

        verifyInOrder([
          () => generatorBuilder(platformUiPackageBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/platform_ui_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'platform': 'ios',
                },
              ),
        ]);
      }),
    );
  });
}
