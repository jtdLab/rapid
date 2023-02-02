import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/domain/add/value_object/value_object.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a value object to the domain part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid domain add value_object <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The output directory relative to <domain_package>/lib/ .\n'
      '                    (defaults to ".")\n'
      '    --type          The type that gets wrapped by this value object.\n'
      '                    Generics get escaped via "#" e.g Tuple<#A, #B, String>.\n'
      '                    (defaults to "String")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('domain add value_object', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? outputDir;
    late String? type;
    late String name;

    late DomainAddValueObjectCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.addValueObject(
          name: any(named: 'name'),
          outputDir: any(named: 'outputDir'),
          type: any(named: 'type'),
          generics: any(named: 'generics'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);

      argResults = _MockArgResults();
      outputDir = null;
      outputDir = null;
      name = 'FooBar';
      when(() => argResults['output-dir']).thenReturn(outputDir);
      when(() => argResults.rest).thenReturn([name]);

      command = DomainAddValueObjectCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('vo is a valid alias', () {
      // Arrange
      final command = DomainAddValueObjectCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('vo'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['domain', 'add', 'value_object', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['domain', 'add', 'value_object', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = DomainAddValueObjectCommand(project: project);

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
            await commandRunner.run(['domain', 'add', 'value_object']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
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
          'add',
          'value_object',
          'name1',
          'name2',
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when name is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const name = 'name1';
        const expectedErrorMessage = '"$name" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'domain',
          'add',
          'value_object',
          name,
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Value Object ...')).called(1);
      verify(
        () => project.addValueObject(
          name: name,
          outputDir: '.',
          type: 'String',
          generics: '',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Value Object $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --output-dir',
        () async {
      // Arrange
      outputDir = 'foo/bar';
      when(() => argResults['output-dir']).thenReturn(outputDir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Value Object ...')).called(1);
      verify(
        () => project.addValueObject(
          name: name,
          outputDir: outputDir!,
          type: 'String',
          generics: '',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Value Object $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output with custom type without generics',
        () async {
      // Arrange
      type = 'int';
      when(() => argResults['type']).thenReturn(type);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Value Object ...')).called(1);
      verify(
        () => project.addValueObject(
          name: name,
          outputDir: '.',
          type: type!,
          generics: '',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Value Object $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output with custom type with generics',
        () async {
      // Arrange
      type = 'Pair<#A, int>';
      when(() => argResults['type']).thenReturn(type);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Value Object ...')).called(1);
      verify(
        () => project.addValueObject(
          name: name,
          outputDir: '.',
          type: 'Pair<A, int>',
          generics: '<A>',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Value Object $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test(
        'completes successfully with correct output with custom type with nested generics',
        () async {
      // Arrange
      type = 'Pair<#A, Triple<#B, #A, #C>>';
      when(() => argResults['type']).thenReturn(type);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Value Object ...')).called(1);
      verify(
        () => project.addValueObject(
          name: name,
          outputDir: '.',
          type: 'Pair<A, Triple<B, A, C>>',
          generics: '<A, B, C>',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Value Object $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when value object does already exist', () async {
      // Arrange
      when(
        () => project.addValueObject(
          name: any(named: 'name'),
          outputDir: any(named: 'outputDir'),
          type: any(named: 'type'),
          generics: any(named: 'generics'),
          logger: logger,
        ),
      ).thenThrow(ValueObjectAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Value Object $name already exists.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'This command should be run from the root of an existing Rapid project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
