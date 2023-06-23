/*  import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

void main() {
  group('create', () {
    test('', () async {
      final logger = Logger();
      final rapid = Rapid(logger: logger);
      await rapid.create(
        projectName: projectName,
        outputDir: outputDir,
        description: description,
        orgName: orgName,
        language: language,
        android: android,
        ios: ios,
        linux: linux,
        macos: macos,
        mobile: mobile,
        web: web,
        windows: windows,
      );
    });
  });
}

   test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --desc', () async {
      // Arrange
      final description = 'My cool description.';
      when(() => argResults['desc']).thenReturn(description);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: description,
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --android', () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: true,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --ios', () async {
      // Arrange
      when(() => argResults['ios']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: true,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --linux', () async {
      // Arrange
      when(() => argResults['linux']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: true,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --macos', () async {
      // Arrange
      when(() => argResults['macos']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: true,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --web', () async {
      // Arrange
      when(() => argResults['web']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: true,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --windows', () async {
      // Arrange
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: false,
          macos: false,
          web: false,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test(
        'completes successfully with correct output w/ --android --ios --linux --macos --web --windows',
        () async {
      // Arrange
      when(() => argResults['android']).thenReturn(true);
      when(() => argResults['ios']).thenReturn(true);
      when(() => argResults['linux']).thenReturn(true);
      when(() => argResults['macos']).thenReturn(true);
      when(() => argResults['web']).thenReturn(true);
      when(() => argResults['windows']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: true,
          ios: true,
          linux: true,
          macos: true,
          web: true,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --mobile', () async {
      // Arrange
      when(() => argResults['mobile']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: true,
          ios: true,
          linux: false,
          macos: false,
          web: false,
          windows: false,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --desktop', () async {
      // Arrange
      when(() => argResults['desktop']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: false,
          ios: false,
          linux: true,
          macos: true,
          web: false,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('completes successfully with correct output w/ --all', () async {
      // Arrange
      when(() => argResults['all']).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => flutterInstalled(logger: logger)).called(1);
      verify(() => melosInstalled(logger: logger)).called(1);
      verify(() => flutterConfigEnableAndroid(logger: logger)).called(1);
      verify(() => flutterConfigEnableIos(logger: logger)).called(1);
      verify(() => flutterConfigEnableLinux(logger: logger)).called(1);
      verify(() => flutterConfigEnableMacos(logger: logger)).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(() => flutterConfigEnableWindows(logger: logger)).called(1);
      verify(() => projectBuilder(path: outputDir)).called(1);
      verify(
        () => project.create(
          projectName: projectName,
          description: 'A Rapid app.',
          orgName: 'com.example',
          language: language,
          example: false,
          android: true,
          ios: true,
          linux: true,
          macos: true,
          web: true,
          windows: true,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Created a Rapid App!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, equals(ExitCode.success.code));
    });

    test('exits with 69 when flutter is not installed', () async {
      // Arrange
      when(() => flutterInstalled(logger: logger))
          .thenAnswer((_) async => false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Flutter not installed.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.unavailable.code);
    });

    test('exits with 69 when melos is not installed', () async {
      // Arrange
      when(() => melosInstalled(logger: logger)).thenAnswer((_) async => false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Melos not installed.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.unavailable.code);
    });

    test('exits with 78 when output dir is not empty', () async {
      // Arrange
      when(() => project.isEmpty).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Output directory must be empty.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

 */
