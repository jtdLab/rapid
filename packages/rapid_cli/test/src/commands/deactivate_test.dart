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
    for (final platform in Platform.values) {
      test(
          'throws PlatformAlreadyDeactivatedException when platform is already deactivated (${platform.name})',
          () async {
        final project = MockRapidProject();
        when(() => project.platformIsActivated(platform)).thenReturn(false);
        final logger = MockRapidLogger();
        final rapid = getRapid(project: project, logger: logger);

        expect(
          () => rapid.deactivatePlatform(platform),
          throwsA(isA<PlatformAlreadyDeactivatedException>()),
        );
        verifyNever(
            () => project.appModule.platformDirectory(platform: platform));
        verifyNever(
            () => project.uiModule.platformUiPackage(platform: platform));
        verifyNever(() => logger.newLine());
        verifyNever(() => logger.commandSuccess(any()));
      });

      test('completes (${platform.name})', () async {
        final appModule = MockAppModule();
        final platformDirectory = MockPlatformDirectory();
        when(() => appModule.platformDirectory)
            .thenReturn(({required Platform platform}) => platformDirectory);
        final uiModule = MockUiModule();
        final platformUiPackage = MockPlatformUiPackage();
        when(() => uiModule.platformUiPackage)
            .thenReturn(({required Platform platform}) => platformUiPackage);
        final logger = MockRapidLogger();
        final project = MockRapidProject();
        when(() => project.platformIsActivated(platform)).thenReturn(true);
        when(() => project.appModule).thenReturn(appModule);
        when(() => project.uiModule).thenReturn(uiModule);
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
    }
  });
}
