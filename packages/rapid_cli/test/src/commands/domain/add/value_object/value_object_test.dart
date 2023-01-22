import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/domain/add/value_object/value_object.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
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
    late String? outputDir;
    late String name;

    late DomainAddValueObjectCommand command;

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
      when(() => valueObject.exists()).thenReturn(false);
      when(() => valueObject.create(logger: logger)).thenAnswer((_) async {});
      when(
        () => domainPackage.valueObject(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(valueObject);
      when(() => project.exists()).thenReturn(true);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
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
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => domainPackage.valueObject(name: name, dir: '.')).called(1);
      verify(() => valueObject.exists()).called(1);
      verify(() => valueObject.create(logger: logger)).called(1);
      verify(() => logger.success('Added Value Object ${name.pascalCase}.'))
          .called(1);
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
      verify(() => domainPackage.valueObject(name: name, dir: outputDir!))
          .called(1);
      verify(() => valueObject.exists()).called(1);
      verify(() => valueObject.create(logger: logger)).called(1);
      verify(() => logger.success('Added Value Object ${name.pascalCase}.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when value object does already exist', () async {
      // Arrange
      when(() => valueObject.exists()).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Value Object $name already exists.')).called(1);
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
