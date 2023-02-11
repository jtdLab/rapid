import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';
import 'package:rapid_cli/src/project/di_package/di_package.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

const projectName = 'foo_bar';

const melos = '''
name: $projectName
''';

const melosWithName = '''
name: foo_bar
''';

const melosWithoutName = '''
some: value
''';

Project _getProject({
  String path = '.',
  MelosFile? melosFile,
  AppPackage? appPackage,
  DiPackage? diPackage,
  DomainPackage? domainPackage,
  InfrastructurePackage? infrastructurePackage,
  LoggingPackage? loggingPackage,
  PlatformDirectoryBuilder? platformDirectory,
  UiPackage? uiPackage,
  PlatformUiPackageBuilder? platformUiPackage,
  MelosBootstrapCommand? melosBootstrap,
  FlutterPubGetCommand? flutterPubGet,
  FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return Project(
    path: path,
    melosFile: melosFile,
    appPackage: appPackage,
    diPackage: diPackage,
    domainPackage: domainPackage,
    infrastructurePackage: infrastructurePackage,
    loggingPackage: loggingPackage,
    platformDirectory: platformDirectory,
    uiPackage: uiPackage,
    platformUiPackage: platformUiPackage,
    melosBootstrap: melosBootstrap,
    flutterPubGet: flutterPubGet,
    flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    dartFormatFix: dartFormatFix,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

MelosFile _getMelosFile({Project? project}) {
  return MelosFile(
    project: project ?? getProject(),
  );
}

void main() {
  group('Project', () {
    test('.path', () {
      // Arrange
      final project = _getProject(path: 'project/path');

      // Act + Assert
      expect(project.path, 'project/path');
    });

    test('.melosFile', () {
      // Arrange
      final project = _getProject();

      // Act + Assert
      expect(
        project.melosFile,
        isA<MelosFile>().having(
          (melosFile) => melosFile.project,
          'project',
          project,
        ),
      );
    });

    test('.appPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.appPackage,
        isA<AppPackage>().having(
          (appPackage) => appPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.diPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.diPackage,
        isA<DiPackage>().having(
          (diPackage) => diPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.domainPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.domainPackage,
        isA<DomainPackage>().having(
          (domainPackage) => domainPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.infrastructurePackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.infrastructurePackage,
        isA<InfrastructurePackage>().having(
          (infrastructurePackage) => infrastructurePackage.project,
          'project',
          project,
        ),
      );
    });

    test('.loggingPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.loggingPackage,
        isA<LoggingPackage>().having(
          (loggingPackage) => loggingPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.platformDirectory', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.platformDirectory,
        isA<PlatformDirectoryBuilder>().having(
          (platformDirectory) => platformDirectory(platform: Platform.android),
          'returns',
          isA<PlatformDirectory>()
              .having(
                (platformDirectory) => platformDirectory.platform,
                'platform',
                Platform.android,
              )
              .having(
                (platformDirectory) => platformDirectory.project,
                'project',
                project,
              ),
        ),
      );
    });

    test('.uiPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.uiPackage,
        isA<UiPackage>().having(
          (uiPackage) => uiPackage.project,
          'project',
          project,
        ),
      );
    });

    test('.platformUiPackage', () {
      // Arrange
      final project = _getProject(melosFile: getMelosFile());

      // Act + Assert
      expect(
        project.platformUiPackage,
        isA<PlatformUiPackageBuilder>().having(
          (platformUiPackage) => platformUiPackage(platform: Platform.android),
          'returns',
          isA<PlatformUiPackage>()
              .having(
                (platformUiPackage) => platformUiPackage.platform,
                'platform',
                Platform.android,
              )
              .having(
                (platformUiPackage) => platformUiPackage.project,
                'project',
                project,
              ),
        ),
      );
    });

    test('.name()', () {
      // Arrange
      final melosFile = getMelosFile();
      when(() => melosFile.readName()).thenReturn('my_project');
      final project = _getProject(melosFile: melosFile);

      // Act + Assert
      expect(project.name(), 'my_project');
    });

    group('.existsAll()', () {
      test(
          'returns true when melos file, app package, di package, domain package '
          'infrastructure package, logging package and ui package exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(true);
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(true);
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(true);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(true);
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(true);
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(true);
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: melosFile,
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAll(), true);
      });

      test('returns false when melos file does not exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(false);
        final project = _getProject(melosFile: melosFile);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when app package does not exist', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(false);
        final project = _getProject(appPackage: appPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when di package does not exist', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(false);
        final project = _getProject(diPackage: diPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when domain package does not exist', () {
        // Arrange
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(false);
        final project = _getProject(domainPackage: domainPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when infrastructure package does not exist', () {
        // Arrange
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(false);
        final project =
            _getProject(infrastructurePackage: infrastructurePackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when logging package does not exist', () {
        // Arrange
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(false);
        final project = _getProject(loggingPackage: loggingPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });

      test('returns false when ui package does not exist', () {
        // Arrange
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(false);
        final project = _getProject(uiPackage: uiPackage);

        // Act + Assert
        expect(project.existsAll(), false);
      });
    });

    group('.existsAny()', () {
      test('returns true when melos file does exist', () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(true);
        final project = _getProject(melosFile: melosFile);

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when app package does exist', () {
        // Arrange
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(true);
        final project = _getProject(appPackage: appPackage);

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when di package does exist', () {
        // Arrange
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          diPackage: diPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when domain package does exist', () {
        // Arrange
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          domainPackage: domainPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when infrastructure package does exist', () {
        // Arrange
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          infrastructurePackage: infrastructurePackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when logging package does exist', () {
        // Arrange
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          loggingPackage: loggingPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test('returns true when ui package does exist', () {
        // Arrange
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(true);
        final project = _getProject(
          melosFile: getMelosFile(),
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAny(), true);
      });

      test(
          'returns false when melos file, app package, di package, domain package '
          'infrastructure package, logging package and ui package do not exist',
          () {
        // Arrange
        final melosFile = getMelosFile();
        when(() => melosFile.exists()).thenReturn(false);
        final appPackage = getAppPackage();
        when(() => appPackage.exists()).thenReturn(false);
        final diPackage = getDiPackage();
        when(() => diPackage.exists()).thenReturn(false);
        final domainPackage = getDomainPackage();
        when(() => domainPackage.exists()).thenReturn(false);
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.exists()).thenReturn(false);
        final loggingPackage = getLoggingPackage();
        when(() => loggingPackage.exists()).thenReturn(false);
        final uiPackage = getUiPackage();
        when(() => uiPackage.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: melosFile,
          appPackage: appPackage,
          diPackage: diPackage,
          domainPackage: domainPackage,
          infrastructurePackage: infrastructurePackage,
          loggingPackage: loggingPackage,
          uiPackage: uiPackage,
        );

        // Act + Assert
        expect(project.existsAny(), false);
      });
    });

    group('.platformIsActivated()', () {
      test('returns true when platform directory and platform ui package exist',
          () {
        // Arrange
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.exists()).thenReturn(true);
        final platformUiPackage = getPlatformUiPackage();
        when(() => platformUiPackage.exists()).thenReturn(true);
        final project = _getProject(
          platformDirectory: ({required Platform platform}) =>
              platformDirectory,
          platformUiPackage: ({required Platform platform}) =>
              platformUiPackage,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), true);
      });

      test('returns false when platform directory does not exist', () {
        // Arrange
        final platformDirectory = getPlatformDirectory();
        when(() => platformDirectory.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: getMelosFile(),
          platformDirectory: ({required Platform platform}) =>
              platformDirectory,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), false);
      });

      test('returns false when platform ui package does not exist', () {
        // Arrange

        final platformUiPackage = getPlatformUiPackage();
        when(() => platformUiPackage.exists()).thenReturn(false);
        final project = _getProject(
          melosFile: getMelosFile(),
          platformUiPackage: ({required Platform platform}) =>
              platformUiPackage,
        );

        // Act + Assert
        expect(project.platformIsActivated(Platform.android), false);
      });
    });

    group('.create()', () {});

    group('.addPlatform()', () {});

    group('.removePlatform()', () {});

    group('.addFeature()', () {});

    group('.removeFeature()', () {});

    group('.addLanguage()', () {});

    group('.removeLanguage()', () {});

    group('.addEntity()', () {});

    group('.removeEntity()', () {});

    group('.addServiceInterface()', () {});

    group('.removeServiceInterface()', () {});

    group('.addValueObject()', () {});

    group('.removeValueObject()', () {});

    group('.addDataTransferObject()', () {});

    group('.removeDataTransferObject()', () {});

    group('.addServiceImplementation()', () {});

    group('.removeServiceImplementation()', () {});

    group('.addBloc()', () {});

    group('.addCubit()', () {});

    group('.addWidget()', () {});

    group('.removeWidget()', () {});
  });

  group('MelosFile', () {
    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      final melosFile = _getMelosFile(project: project);

      // Act + Assert
      expect(melosFile.path, 'project/path/melos.yaml');
    });

    test('.project', () {
      // Arrange
      final project = getProject();
      final melosFile = _getMelosFile(
        project: project,
      );

      // Act + Assert
      expect(melosFile.project, project);
    });

    group('.exists', () {
      test(
        'returns true when the file exists',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path).createSync(recursive: true);

          // Act + Assert
          expect(melosFile.exists(), true);
        }),
      );

      test(
        'returns false when the file does not exists',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();

          // Act + Assert
          expect(melosFile.exists(), false);
        }),
      );
    });

    group('.name', () {
      test(
        'returns name',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(melosWithName);

          // Act + Assert
          expect(melosFile.readName(), 'foo_bar');
        }),
      );

      test(
        'throws read name failure when name is not present',
        withTempDir(() {
          // Arrange
          final melosFile = _getMelosFile();
          File(melosFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(melosWithoutName);

          // Act + Assert
          expect(
            () => melosFile.readName(),
            throwsA(isA<ReadNameFailure>()),
          );
        }),
      );
    });
  });
}
