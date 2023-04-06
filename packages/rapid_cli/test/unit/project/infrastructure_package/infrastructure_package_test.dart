import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

InfrastructurePackage _getInfrastructurePackage({
  DomainPackage? domainPackage,
  Project? project,
  GeneratorBuilder? generator,
  DataTransferObjectBuilder? dataTransferObjectBuilder,
  ServiceImplementationBuilder? serviceImplementationBuilder,
}) {
  return InfrastructurePackage(
    domainPackage: domainPackage ?? getDomainPackage(),
    project: project ?? getProject(),
  )
    ..generatorOverrides = generator
    ..dataTransferObjectOverrides = dataTransferObjectBuilder
    ..serviceImplementationOverrides = serviceImplementationBuilder;
}

DataTransferObject _getDataTransferObject({
  required String entityName,
  required String dir,
  InfrastructurePackage? infrastructurePackage,
  GeneratorBuilder? generator,
}) {
  return DataTransferObject(
    name: entityName,
    dir: dir,
    infrastructurePackage: infrastructurePackage ?? getInfrastructurePackage(),
  )..generatorOverrides = generator;
}

ServiceImplementation _getServiceImplementation({
  required String name,
  required String serviceName,
  required String dir,
  InfrastructurePackage? infrastructurePackage,
  GeneratorBuilder? generator,
}) {
  return ServiceImplementation(
    name: name,
    serviceName: serviceName,
    dir: dir,
    infrastructurePackage: infrastructurePackage ?? getInfrastructurePackage(),
  )..generatorOverrides = generator;
}

void main() {
  group('InfrastructurePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final infrastructurePackage = _getInfrastructurePackage(project: project);

      // Act + Assert
      expect(
        infrastructurePackage.path,
        'project/path/packages/my_project/my_project_infrastructure',
      );
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final infrastructurePackage = _getInfrastructurePackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await infrastructurePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_infrastructure',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.addDataTransferObject()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(false);
        final dataTransferObjectBuilder = getDataTransferObjectBuilder(
          dataTransferObject,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          dataTransferObjectBuilder: dataTransferObjectBuilder,
        );

        // Act
        final logger = FakeLogger();
        infrastructurePackage.addDataTransferObject(
          name: 'Cool',
          outputDir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => dataTransferObjectBuilder(
            entityName: 'Cool',
            dir: 'my/dir',
            infrastructurePackage: infrastructurePackage,
          ),
        ).called(1);
        verify(() => dataTransferObject.create(logger: logger)).called(1);
      });

      test(
          'throws DataTransferObjectAlreadyExists when dataTransferObject exists',
          () {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(true);
        final dataTransferObjectBuilder = getDataTransferObjectBuilder(
          dataTransferObject,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          dataTransferObjectBuilder: dataTransferObjectBuilder,
        );

        // Act + Assert
        expect(
          () => infrastructurePackage.addDataTransferObject(
            name: 'Cool',
            outputDir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<DataTransferObjectAlreadyExists>()),
        );
      });
    });

    group('.removeDataTransferObject()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(true);
        final dataTransferObjectBuilder = getDataTransferObjectBuilder(
          dataTransferObject,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          dataTransferObjectBuilder: dataTransferObjectBuilder,
        );

        // Act
        final logger = FakeLogger();
        infrastructurePackage.removeDataTransferObject(
          name: 'CoolDto',
          dir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => dataTransferObjectBuilder(
            entityName: 'Cool',
            dir: 'my/dir',
            infrastructurePackage: infrastructurePackage,
          ),
        ).called(1);
        verify(() => dataTransferObject.delete(logger: logger)).called(1);
      });

      test(
          'throws DataTransferObjectDoesNotExist when dataTransferObject does not exist',
          () {
        // Arrange
        final dataTransferObject = getDataTransferObject();
        when(() => dataTransferObject.existsAny()).thenReturn(false);
        final dataTransferObjectBuilder = getDataTransferObjectBuilder(
          dataTransferObject,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          dataTransferObjectBuilder: dataTransferObjectBuilder,
        );

        // Act + Assert
        expect(
          () => infrastructurePackage.removeDataTransferObject(
            name: 'CoolDto',
            dir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<DataTransferObjectDoesNotExist>()),
        );
      });
    });

    group('.addServiceImplementation()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(false);
        final serviceImplementationBuilder = getServiceImplementationBuilder(
          serviceImplementation,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          serviceImplementationBuilder: serviceImplementationBuilder,
        );

        // Act
        final logger = FakeLogger();
        infrastructurePackage.addServiceImplementation(
          name: 'Fake',
          serviceName: 'Cool',
          outputDir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => serviceImplementationBuilder(
            name: 'Fake',
            serviceName: 'Cool',
            dir: 'my/dir',
            infrastructurePackage: infrastructurePackage,
          ),
        ).called(1);
        verify(() => serviceImplementation.create(logger: logger)).called(1);
      });

      test(
          'throws ServiceImplementationAlreadyExists when service implementation exists',
          () {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(true);
        final serviceImplementationBuilder = getServiceImplementationBuilder(
          serviceImplementation,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          serviceImplementationBuilder: serviceImplementationBuilder,
        );

        // Act + Assert
        expect(
          () => infrastructurePackage.addServiceImplementation(
            name: 'Fake',
            serviceName: 'Cool',
            outputDir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceImplementationAlreadyExists>()),
        );
      });
    });

    group('.removeServiceImplementation()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(true);
        final serviceImplementationBuilder = getServiceImplementationBuilder(
          serviceImplementation,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          serviceImplementationBuilder: serviceImplementationBuilder,
        );

        // Act
        final logger = FakeLogger();
        infrastructurePackage.removeServiceImplementation(
          name: 'Fake',
          serviceName: 'Cool',
          dir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => serviceImplementationBuilder(
            name: 'Fake',
            serviceName: 'Cool',
            dir: 'my/dir',
            infrastructurePackage: infrastructurePackage,
          ),
        ).called(1);
        verify(() => serviceImplementation.delete(logger: logger)).called(1);
      });

      test(
          'throws ServiceImplementationDoesNotExist when service implementation does not exist',
          () {
        // Arrange
        final serviceImplementation = getServiceImplementation();
        when(() => serviceImplementation.existsAny()).thenReturn(false);
        final serviceImplementationBuilder = getServiceImplementationBuilder(
          serviceImplementation,
        );
        final infrastructurePackage = _getInfrastructurePackage(
          serviceImplementationBuilder: serviceImplementationBuilder,
        );

        // Act + Assert
        expect(
          () => infrastructurePackage.removeServiceImplementation(
            name: 'Fake',
            serviceName: 'Cool',
            dir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceImplementationDoesNotExist>()),
        );
      });
    });
  });

  group('DataTransferObject', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          when(() => infrastructurePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final dataTransferObject = _getDataTransferObject(
            entityName: 'MyDataTransferObject',
            dir: 'data_transfer_object/path',
            infrastructurePackage: infrastructurePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await dataTransferObject.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'infrastructure_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'dataTransferObject_name': 'MyDataTransferObject',
                'output_dir': 'data_transfer_object/path',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          final dataTransferObject = _getDataTransferObject(
            entityName: 'Cool',
            dir: '.',
            infrastructurePackage: infrastructurePackage,
          );
          final dataTransferObjectDir =
              Directory('infrastructure_package/path/lib/src/cool')
                ..createSync(recursive: true);
          final dataTransferObjectTestDir =
              Directory('infrastructure_package/path/test/src/cool')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          dataTransferObject.delete(logger: logger);

          // Assert
          expect(dataTransferObjectDir.existsSync(), false);
          expect(dataTransferObjectTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          final dataTransferObject = _getDataTransferObject(
            entityName: 'Cool',
            dir: 'foo',
            infrastructurePackage: infrastructurePackage,
          );
          final dataTransferObjectDir =
              Directory('infrastructure_package/path/lib/src/foo/cool')
                ..createSync(recursive: true);
          final dataTransferObjectTestDir =
              Directory('infrastructure_package/path/test/src/foo/cool')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          dataTransferObject.delete(logger: logger);

          // Assert
          expect(
            Directory(
              'infrastructure_package/path/lib/src/foo',
            ).existsSync(),
            false,
          );
          expect(
            Directory(
              'infrastructure_package/path/test/src/foo',
            ).existsSync(),
            false,
          );
          expect(dataTransferObjectDir.existsSync(), false);
          expect(dataTransferObjectTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('ServiceImplementation', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          when(() => infrastructurePackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final serviceImplementation = _getServiceImplementation(
            name: 'Fake',
            serviceName: 'MyService',
            dir: 'service_implementation/path',
            infrastructurePackage: infrastructurePackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await serviceImplementation.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'infrastructure_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Fake',
                'service_name': 'MyService',
                'output_dir': 'service_implementation/path',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          final serviceImplementation = _getServiceImplementation(
            name: 'Fake',
            serviceName: 'MyService',
            dir: '.',
            infrastructurePackage: infrastructurePackage,
          );
          final serviceImplementationDir =
              Directory('infrastructure_package/path/lib/src/my_service')
                ..createSync(recursive: true);
          final serviceImplementationTestDir =
              Directory('infrastructure_package/path/test/src/my_service')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          serviceImplementation.delete(logger: logger);

          // Assert
          expect(serviceImplementationDir.existsSync(), false);
          expect(serviceImplementationTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          final serviceImplementation = _getServiceImplementation(
            name: 'Fake',
            serviceName: 'MyService',
            dir: 'foo',
            infrastructurePackage: infrastructurePackage,
          );
          final serviceImplementationDir =
              Directory('infrastructure_package/path/lib/src/foo/my_service')
                ..createSync(recursive: true);
          final serviceImplementationTestDir =
              Directory('infrastructure_package/path/test/src/foo/my_service')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          serviceImplementation.delete(logger: logger);

          // Assert
          expect(
            Directory('infrastructure_package/path/lib/src/foo').existsSync(),
            false,
          );
          expect(
            Directory('infrastructure_package/path/test/src/foo').existsSync(),
            false,
          );
          expect(serviceImplementationDir.existsSync(), false);
          expect(serviceImplementationTestDir.existsSync(), false);
        }),
      );
    });
  });
}
