import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/platform_ui_package.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:test/test.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  group('PlatformUiPackage', () {
    const projectName = 'test_app';
    const platform = Platform.android;

    late MelosFile melosFile;
    late Project project;
    late PlatformUiPackage platformUiPackage;

    setUp(() {
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      platformUiPackage = PlatformUiPackage(platform, project: project);
    });

    group('path', () {
      test('is "packages/<PROJECT-NAME>_ui/<PROJECT-NAME>_ui_<PLATFORM-NAME>"',
          () {
        // Assert
        expect(
          platformUiPackage.path,
          'packages/${projectName}_ui/${projectName}_ui_${platform.name}',
        );
      });
    });

    group('directory', () {
      test('is "packages/<PROJECT-NAME>_ui/<PROJECT-NAME>_ui_<PLATFORM-NAME>"',
          () {
        // Assert
        expect(
          platformUiPackage.directory.path,
          'packages/${projectName}_ui/${projectName}_ui_${platform.name}',
        );
      });
    });
  });
}
