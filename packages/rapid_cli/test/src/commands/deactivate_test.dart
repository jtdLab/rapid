import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('deactivatePlatform', () {
    test(
        'throws PlatformAlreadyDeactivatedException when platform is already deactivated',
        () async {
      final platform = randomPlatform();
      final project = MockRapidProject();
      when(() => project.platformIsActivated(platform)).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.deactivatePlatform(platform),
        throwsA(isA<PlatformAlreadyDeactivatedException>()),
      );
    });

    test('deactivates platform', () async {
      final platform = randomPlatform();
      final platformDirectory = MockPlatformDirectory();
      final appModule = MockAppModule(
        platformDirectory: ({required Platform platform}) => platformDirectory,
      );
      final platformUiPackage = MockPlatformUiPackage();
      final uiModule = MockUiModule(
        platformUiPackage: ({required Platform platform}) => platformUiPackage,
      );
      final logger = MockRapidLogger();
      final project =
          MockRapidProject(appModule: appModule, uiModule: uiModule);
      when(() => project.platformIsActivated(platform)).thenReturn(true);
      final rapid = getRapid(project: project, logger: logger);

      await rapid.deactivatePlatform(platform);

      verifyInOrder([
        () => logger.newLine(),
        () => logger.progress('Deleting Platform Directory'),
        () => project.appModule.platformDirectory(platform: platform),
        () => platformDirectory.deleteSync(recursive: true),
        () => logger.progress('Deleting Platform Ui Package'),
        () => project.uiModule.platformUiPackage(platform: platform),
        () => platformUiPackage.deleteSync(recursive: true),
        () => logger.newLine(),
        () => logger.commandSuccess('Deactivated ${platform.prettyName}!')
      ]);
    });
  });
}
