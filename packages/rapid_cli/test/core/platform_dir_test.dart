import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/platform_dir.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:test/test.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  group('PlatformDir', () {
    const projectName = 'test_app';
    const platform = Platform.android;
    const platformName = 'android';

    late MelosFile melosFile;
    late Project project;
    late PlatformDir platformDir;

    setUp(() {
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      platformDir = PlatformDir(platform, project: project);
    });

    group('path', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>_<PLATFORM-NAME>"', () {
        // Assert
        expect(
          platformDir.path,
          'packages/$projectName/${projectName}_$platformName',
        );
      });
    });

    group('directory', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>_<PLATFORM-NAME>"', () {
        // Assert
        expect(
          platformDir.directory.path,
          'packages/$projectName/${projectName}_$platformName',
        );
      });
    });
  });
}
