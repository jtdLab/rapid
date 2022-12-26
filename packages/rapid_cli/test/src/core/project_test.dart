import 'package:rapid_cli/src/core/app_package.dart';
import 'package:rapid_cli/src/core/di_package.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/platform_dir.dart';
import 'package:rapid_cli/src/core/platform_ui_package.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:rapid_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const melosYaml = '''
name: foo
''';

void main() {
  group('Project', () {
    final cwd = Directory.current;

    late Project project;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      project = Project();
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('rootDir', () {
      test('returns a root dir', () {
        // Assert
        expect(project.rootDir, isA<RootDir>());
      });
    });

    group('melos', () {
      test('returns a melos file', () {
        // Assert
        expect(project.melosFile, isA<MelosFile>());
      });
    });

    group('appPackage', () {
      setUp(() {
        final melosFile = File(project.melosFile.path);
        melosFile.createSync(recursive: true);
        melosFile.writeAsStringSync(melosYaml);
      });

      test('returns an app package with reference to the project', () {
        // Assert
        expect(
          project.appPackage,
          isA<AppPackage>().having(
            (appPackage) => appPackage.project,
            '',
            project,
          ),
        );
      });
    });

    group('diPackage', () {
      setUp(() {
        final melosFile = File(project.melosFile.path);
        melosFile.createSync(recursive: true);
        melosFile.writeAsStringSync(melosYaml);
      });

      test('returns a di package with reference to the project', () {
        // Assert
        expect(
          project.diPackage,
          isA<DiPackage>().having(
            (diPackage) => diPackage.project,
            '',
            project,
          ),
        );
      });
    });

    group('platformDir', () {
      late Platform platform;

      setUp(() {
        platform = Platform.linux;
        final melosFile = File(project.melosFile.path);
        melosFile.createSync(recursive: true);
        melosFile.writeAsStringSync(melosYaml);
      });

      test('returns an platform dir with correct platform', () {
        // Assert
        expect(
          project.platformDir(platform),
          isA<PlatformDir>().having(
            (platformDir) => platformDir.platform,
            '',
            platform,
          ),
        );
      });
    });

    group('platformUiPackage', () {
      late Platform platform;

      setUp(() {
        platform = Platform.linux;
        final melosFile = File(project.melosFile.path);
        melosFile.createSync(recursive: true);
        melosFile.writeAsStringSync(melosYaml);
      });

      test('returns an platform ui package with correct platform', () {
        // Assert
        expect(
          project.platformUiPackage(platform),
          isA<PlatformUiPackage>().having(
            (platformUiPackage) => platformUiPackage.platform,
            '',
            platform,
          ),
        );
      });
    });

    group('isActivated', () {
      late Platform platform;

      setUp(() {
        platform = Platform.linux;
        final melosFile = File(project.melosFile.path);
        melosFile.createSync(recursive: true);
        melosFile.writeAsStringSync(melosYaml);
      });

      test(
          'returns true when platform dir and platform ui package for given platform exists',
          () {
        // Arrange
        final platformDir = Directory(project.platformDir(platform).path);
        platformDir.createSync(recursive: true);
        final platformUiPackage =
            Directory(project.platformUiPackage(platform).path);
        platformUiPackage.createSync(recursive: true);

        // Assert
        expect(project.isActivated(platform), true);
      });

      test('returns false when platform dir for given platform does not exist',
          () {
        // Arrange
        final platformUiPackage =
            Directory(project.platformUiPackage(platform).path);
        platformUiPackage.createSync(recursive: true);

        // Assert
        expect(project.isActivated(platform), false);
      });

      test(
          'returns false when platform ui package for given platform does not exist',
          () {
        // Arrange
        final platformDir = Directory(project.platformDir(platform).path);
        platformDir.createSync(recursive: true);

        // Assert
        expect(project.isActivated(platform), false);
      });
    });
  });
}
