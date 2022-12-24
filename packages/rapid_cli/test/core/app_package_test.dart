import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/app_package.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:test/test.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

class MockAppPackage extends Mock implements AppPackage {}

void main() {
  group('AppPackage', () {
    const projectName = 'test_app';

    late MelosFile melosFile;
    late Project project;
    late AppPackage appPackage;

    setUp(() {
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = AppPackage(project: project);
    });

    group('path', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>"', () {
        // Assert
        expect(appPackage.path, 'packages/$projectName/$projectName');
      });
    });

    group('directory', () {
      test('is "packages/<PROJECT-NAME>/<PROJECT-NAME>"', () {
        // Assert
        expect(appPackage.directory.path, 'packages/$projectName/$projectName');
      });
    });
  });

  group('MainFile', () {
    late Environment environment;
    late AppPackage appPackage;
    late MainFile mainFile;

    setUp(() {
      environment = Environment.development;
      appPackage = MockAppPackage();
      when(() => appPackage.path).thenReturn('app/package/path');
      mainFile = MainFile(
        environment,
        appPackage: appPackage,
      );
    });

    group('path', () {
      test('is "<APP-PACKAGE-PATH>lib/main_<ENVIRONMENT>.dart"', () {
        // Assert
        expect(
          mainFile.path,
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );
      });
    });

    group('file', () {
      test('is "<APP-PACKAGE-PATH>/lib/main_<ENVIRONMENT>.dart"', () {
        // Assert
        expect(
          mainFile.file.path,
          '${appPackage.path}/lib/main_${environment.name}.dart',
        );
      });
    });

    group('addPlatform', () {
      // TODO: impl
    });

    group('removePlatform', () {
      // TODO: impl
    });
  });
}
