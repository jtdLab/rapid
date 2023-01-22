import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/domain/remove/value_object/value_object.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove a value object from the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain remove value_object <name> [arguments]\n'
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

class _MockDomainPackage extends Mock implements DomainPackage {}

class _MockValueObject extends Mock implements ValueObject {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('domain add value_object', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late DomainPackage domainPackage;
    late ValueObject valueObject;

    late ArgResults argResults;
    late String? dir;
    late String name;

    late DomainRemoveValueObjectCommand command;

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
      domainPackage = _MockDomainPackage();
      valueObject = _MockValueObject();
      when(() => valueObject.exists()).thenReturn(true);
      when(
        () => domainPackage.valueObject(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(valueObject);
      when(() => project.exists()).thenReturn(true);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
      dir = null;
      name = 'FooBarDto';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = DomainRemoveValueObjectCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('vo is a valid alias', () {
      // Arrange
      final command = DomainRemoveValueObjectCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('vo'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['domain', 'remove', 'value_object', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', 'remove', 'value_object', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = DomainRemoveValueObjectCommand(project: project);

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
            await commandRunner.run(['domain', 'remove', 'value_object']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when multiple names are provided',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'Multiple names specified.';

        // Act
        final result = await commandRunner.run([
          'domain',
          'remove',
          'value_object',
          'name1',
          'name2',
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
      verify(() => domainPackage.valueObject(name: name, dir: '.')).called(1);
      verify(() => valueObject.exists()).called(1);
      verify(() => valueObject.delete()).called(1);
      verify(() => logger.success('Removed Value Object ${name.pascalCase}.'))
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
      verify(() => domainPackage.valueObject(name: name, dir: dir!)).called(1);
      verify(() => valueObject.exists()).called(1);
      verify(() => valueObject.delete()).called(1);
      verify(() => logger.success('Removed Value Object ${name.pascalCase}.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when value object does not exist', () async {
      // Arrange
      when(() => valueObject.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Value Object ${name.pascalCase} not found.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
