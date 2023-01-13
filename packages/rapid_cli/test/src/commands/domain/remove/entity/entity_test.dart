import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/domain/remove/entity/entity.dart';
import 'package:rapid_cli/src/project/domain_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove an entity from the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain remove entity [arguments]\n'
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

class _MockEntity extends Mock implements Entity {}

class _MockFileSystemEntity extends Mock implements FileSystemEntity {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('domain remove entity', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;

    late MelosFile melosFile;
    const projectName = 'test_app';
    late DomainPackage domainPackage;
    late Entity entity;
    late List<FileSystemEntity> deletedEntities;
    late FileSystemEntity deletedEntity1;
    const String deletedEntity1Path = 'foo/bar/bam';
    late FileSystemEntity deletedEntity2;
    const String deletedEntity2Path = 'foo/bar/baz';

    late ArgResults argResults;
    late String? dir;
    late String name;

    late DomainRemoveEntityCommand command;

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
      entity = _MockEntity();
      deletedEntity1 = _MockFileSystemEntity();
      when(() => deletedEntity1.path).thenReturn(deletedEntity1Path);
      deletedEntity2 = _MockFileSystemEntity();
      when(() => deletedEntity2.path).thenReturn(deletedEntity2Path);
      deletedEntities = [deletedEntity1, deletedEntity2];
      when(() => entity.delete()).thenReturn(deletedEntities);
      when(() => entity.exists()).thenReturn(true);
      when(() => domainPackage.entity(
          name: any(named: 'name'), dir: any(named: 'dir'))).thenReturn(entity);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
      dir = null;
      name = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = DomainRemoveEntityCommand(
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
          ['domain', 'remove', 'entity', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', 'remove', 'entity', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = DomainRemoveEntityCommand(project: project);

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
        final result = await commandRunner.run(['domain', 'remove', 'entity']);

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
        final result =
            await commandRunner.run(['domain', 'remove', 'entity', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => domainPackage.entity(name: name, dir: '.'));
      verify(() => entity.exists()).called(1);
      verify(() => entity.delete()).called(1);
      verify(() => logger.info(deletedEntity1Path)).called(1);
      verify(() => logger.info(deletedEntity2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Entity $name.')).called(1);
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
      verify(() => domainPackage.entity(name: name, dir: dir!));
      verify(() => entity.exists()).called(1);
      verify(() => entity.delete()).called(1);
      verify(() => logger.info(deletedEntity1Path)).called(1);
      verify(() => logger.info(deletedEntity2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Entity $name.')).called(1);
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

    test('exits with 78 when the referenced entity does not exist', () async {
      // Arrange
      when(() => entity.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => entity.delete());
      verify(() => logger.err('Entity $name not found.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
