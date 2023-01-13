import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/infrastructure_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove a service implementation from the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure remove service_implementation [arguments]\n'
      '-h, --help       Print this usage information.\n'
      '\n'
      '\n'
      '-s, --service    The service interface the service implementation is related to.\n'
      '-d, --dir        The directory relative to <infrastructure_package>/lib/ .\n'
      '                 (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockInfrastructurePackage extends Mock implements InfrastructurePackage {
}

class _MockServiceImplementation extends Mock implements ServiceImplementation {
}

class _MockFileSystemEntity extends Mock implements FileSystemEntity {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('infrastructure remove service_implementation', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;

    late MelosFile melosFile;
    const projectName = 'test_app';
    late InfrastructurePackage infrastructurePackage;
    late ServiceImplementation serviceImplementation;
    late List<FileSystemEntity> deletedEntities;
    late FileSystemEntity deletedServiceImplementation1;
    const String deletedServiceImplementation1Path = 'foo/bar/bam';
    late FileSystemEntity deletedServiceImplementation2;
    const String deletedServiceImplementation2Path = 'foo/bar/baz';

    late ArgResults argResults;
    late String? dir;
    late String name;
    late String service;

    late InfrastructureRemoveServiceImplementationCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      final progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = _MockProject();
      melosFile = _MockMelosFile();
      when(() => melosFile.exists()).thenReturn(true);
      when(() => melosFile.name()).thenReturn(projectName);
      infrastructurePackage = _MockInfrastructurePackage();
      serviceImplementation = _MockServiceImplementation();
      deletedServiceImplementation1 = _MockFileSystemEntity();
      when(() => deletedServiceImplementation1.path)
          .thenReturn(deletedServiceImplementation1Path);
      deletedServiceImplementation2 = _MockFileSystemEntity();
      when(() => deletedServiceImplementation2.path)
          .thenReturn(deletedServiceImplementation2Path);
      deletedEntities = [
        deletedServiceImplementation1,
        deletedServiceImplementation2
      ];
      when(() => serviceImplementation.delete()).thenReturn(deletedEntities);
      when(() => serviceImplementation.exists()).thenReturn(true);
      when(() => infrastructurePackage.serviceImplementation(
          name: any(named: 'name'),
          service: any(named: 'service'),
          dir: any(named: 'dir'))).thenReturn(serviceImplementation);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.infrastructurePackage)
          .thenReturn(infrastructurePackage);

      argResults = _MockArgResults();
      dir = null;
      name = 'Fake';
      service = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults['service']).thenReturn(service);
      when(() => argResults.rest).thenReturn([name]);

      command = InfrastructureRemoveServiceImplementationCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('service is a valid alias', () {
      // Arrange
      final command =
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('service'));
    });

    test('si is a valid alias', () {
      // Arrange
      final command =
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('si'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'remove', 'service_implementation', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'remove', 'service_implementation', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command =
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when name is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the name.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'remove', 'service_implementation']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when name is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        name = '****::_';
        final expectedErrorMessage = '"$name" is not a valid dart class name.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'remove', 'service_implementation', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when service is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the service.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'remove', 'service_implementation', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when service is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        service = '****::_';
        final expectedErrorMessage =
            '"$service" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'remove',
          'service_implementation',
          name,
          '--service',
          service
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => infrastructurePackage.serviceImplementation(
          name: name, service: service, dir: '.'));
      verify(() => serviceImplementation.exists()).called(1);
      verify(() => serviceImplementation.delete()).called(1);
      verify(() => logger.info(deletedServiceImplementation1Path)).called(1);
      verify(() => logger.info(deletedServiceImplementation2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Service Implementation $name.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --dir',
        () async {
      // Arrange
      dir = 'foo/bar';
      when(() => argResults['dir']).thenReturn(dir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => infrastructurePackage.serviceImplementation(
          name: name, service: service, dir: dir!));
      verify(() => serviceImplementation.exists()).called(1);
      verify(() => serviceImplementation.delete()).called(1);
      verify(() => logger.info(deletedServiceImplementation1Path)).called(1);
      verify(() => logger.info(deletedServiceImplementation2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Service Implementation $name.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 66 when melos.yaml does not exist', () async {
      // Arrange
      when(() => melosFile.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''')).called(1);
      expect(result, ExitCode.noInput.code);
    });

    test(
        'exits with 78 when the referenced service implementation does not exist',
        () async {
      // Arrange
      when(() => serviceImplementation.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => serviceImplementation.delete());
      verify(() => logger.err('Service Implementation $name not found.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
