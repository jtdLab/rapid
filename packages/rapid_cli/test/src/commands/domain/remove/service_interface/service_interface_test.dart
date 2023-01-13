import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/domain/remove/service_interface/service_interface.dart';
import 'package:rapid_cli/src/project/domain_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove a service interface from the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain remove service_interface [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '-d, --dir     The directory relative to <domain_package>/lib/ .\n'
      '              (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockDomainPackage extends Mock implements DomainPackage {}

class _MockServiceInterface extends Mock implements ServiceInterface {}

class _MockFileSystemEntity extends Mock implements FileSystemEntity {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('domain remove service_interface', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;

    late MelosFile melosFile;
    const projectName = 'test_app';
    late DomainPackage domainPackage;
    late ServiceInterface serviceInterface;
    late List<FileSystemEntity> deletedEntities;
    late FileSystemEntity deletedServiceInterface1;
    const String deletedServiceInterface1Path = 'foo/bar/bam';
    late FileSystemEntity deletedServiceInterface2;
    const String deletedServiceInterface2Path = 'foo/bar/baz';

    late ArgResults argResults;
    late String? dir;
    late String name;

    late DomainRemoveServiceInterfaceCommand command;

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
      domainPackage = _MockDomainPackage();
      serviceInterface = _MockServiceInterface();
      deletedServiceInterface1 = _MockFileSystemEntity();
      when(() => deletedServiceInterface1.path)
          .thenReturn(deletedServiceInterface1Path);
      deletedServiceInterface2 = _MockFileSystemEntity();
      when(() => deletedServiceInterface2.path)
          .thenReturn(deletedServiceInterface2Path);
      deletedEntities = [deletedServiceInterface1, deletedServiceInterface2];
      when(() => serviceInterface.delete()).thenReturn(deletedEntities);
      when(() => serviceInterface.exists()).thenReturn(true);
      when(() => domainPackage.serviceInterface(
          name: any(named: 'name'),
          dir: any(named: 'dir'))).thenReturn(serviceInterface);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
      dir = null;
      name = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = DomainRemoveServiceInterfaceCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['domain', 'remove', 'service_interface', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', 'remove', 'service_interface', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = DomainRemoveServiceInterfaceCommand(project: project);

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
        final result =
            await commandRunner.run(['domain', 'remove', 'service_interface']);

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
            .run(['domain', 'remove', 'service_interface', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => domainPackage.serviceInterface(name: name, dir: '.'));
      verify(() => serviceInterface.exists()).called(1);
      verify(() => serviceInterface.delete()).called(1);
      verify(() => logger.info(deletedServiceInterface1Path)).called(1);
      verify(() => logger.info(deletedServiceInterface2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Service Interface $name.'))
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
      verify(() => domainPackage.serviceInterface(name: name, dir: dir!));
      verify(() => serviceInterface.exists()).called(1);
      verify(() => serviceInterface.delete()).called(1);
      verify(() => logger.info(deletedServiceInterface1Path)).called(1);
      verify(() => logger.info(deletedServiceInterface2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Service Interface $name.'))
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

    test('exits with 78 when the referenced service interface does not exist',
        () async {
      // Arrange
      when(() => serviceInterface.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => serviceInterface.delete());
      verify(() => logger.err('Service Interface $name not found.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
