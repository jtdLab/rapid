import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a data transfer object to the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure add data_transfer_object [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-e, --entity        The entity the data transfer object is related to.\n'
      '-o, --output-dir    The output directory relative to <infrastructure_package>/lib/src .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockInfrastructurePackage extends Mock implements InfrastructurePackage {
}

class _MockDomainPackage extends Mock implements DomainPackage {}

class _MockDataTransferObject extends Mock implements DataTransferObject {}

class _MockEntity extends Mock implements Entity {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('infrastructure add service_interface', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late InfrastructurePackage infrastructurePackage;
    late DataTransferObject dataTransferObject;
    late DomainPackage domainPackage;
    late Entity entity;

    late ArgResults argResults;
    late String entityName;
    late String? outputDir;

    late InfrastructureAddDataTransferObjectCommand command;

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
      infrastructurePackage = _MockInfrastructurePackage();
      dataTransferObject = _MockDataTransferObject();
      when(() => dataTransferObject.exists()).thenReturn(false);
      when(() => dataTransferObject.create(logger: logger))
          .thenAnswer((_) async {});
      when(
        () => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(dataTransferObject);
      domainPackage = _MockDomainPackage();
      entity = _MockEntity();
      when(() => entity.exists()).thenReturn(true);
      when(
        () => domainPackage.entity(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(entity);
      when(() => project.exists()).thenReturn(true);

      when(() => project.infrastructurePackage)
          .thenReturn(infrastructurePackage);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
      entityName = 'FooBar';
      outputDir = null;
      when(() => argResults['entity']).thenReturn(entityName);
      when(() => argResults['output-dir']).thenReturn(outputDir);

      command = InfrastructureAddDataTransferObjectCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });
    test('dto is a valid alias', () {
      // Arrange
      final command =
          InfrastructureAddDataTransferObjectCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('dto'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'add', 'data_transfer_object', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'add', 'data_transfer_object', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = InfrastructureAddDataTransferObjectCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when entity is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the entity.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'add', 'data_transfer_object']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when entity is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        entityName = '****::_';
        final expectedErrorMessage =
            '"$entityName" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'add',
          'data_transfer_object',
          '--entity',
          entityName
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
      verify(() => infrastructurePackage.dataTransferObject(
          entityName: entityName, dir: '.')).called(1);
      verify(() => dataTransferObject.exists()).called(1);
      verify(() => dataTransferObject.create(logger: logger)).called(1);
      verify(() =>
              logger.success('Added Data Transfer Object ${entityName}Dto.'))
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
      verify(() => infrastructurePackage.dataTransferObject(
          entityName: entityName, dir: outputDir!)).called(1);
      verify(() => dataTransferObject.exists()).called(1);
      verify(() => dataTransferObject.create(logger: logger)).called(1);
      verify(() =>
              logger.success('Added Data Transfer Object ${entityName}Dto.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when entity does not exist', () async {
      // Arrange
      when(() => entity.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Entity $entityName does not exists.')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when data transfer object does already exist',
        () async {
      // Arrange
      when(() => dataTransferObject.exists()).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err(
          'Data Transfer Object ${entityName}Dto already exists.')).called(1);
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
