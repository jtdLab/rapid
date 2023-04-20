import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

DomainPackage _getDomainPackage({
  Project? project,
  GeneratorBuilder? generator,
  EntityBuilder? entityBuilder,
  ServiceInterfaceBuilder? serviceInterfaceBuilder,
  ValueObjectBuilder? valueObjectBuilder,
}) {
  return DomainPackage(
    project: project ?? getProject(),
  )
    ..generatorOverrides = generator
    ..entityOverrides = entityBuilder
    ..serviceInterfaceOverrides = serviceInterfaceBuilder
    ..valueObjectOverrides = valueObjectBuilder;
}

Entity _getEntity({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  GeneratorBuilder? generator,
}) {
  return Entity(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
  )..generatorOverrides = generator;
}

ServiceInterface _getServiceInterface({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  GeneratorBuilder? generator,
}) {
  return ServiceInterface(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
  )..generatorOverrides = generator;
}

ValueObject _getValueObject({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  GeneratorBuilder? generator,
}) {
  return ValueObject(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
  )..generatorOverrides = generator;
}

void main() {
  group('DomainPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final domainPackage = _getDomainPackage(project: project);

      // Act + Assert
      expect(
        domainPackage.path,
        'project/path/packages/my_project/my_project_domain',
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
          final domainPackage = _getDomainPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await domainPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_domain',
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

    group('.addEntity()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(false);
        final entityBuilder = getEntityBuilder(entity);
        final domainPackage = _getDomainPackage(entityBuilder: entityBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.addEntity(
          name: 'cool',
          outputDir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => entityBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(() => entity.create(logger: logger)).called(1);
      });

      test('throws EntityAlreadyExists when entity exists', () {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final entityBuilder = getEntityBuilder(entity);
        final domainPackage = _getDomainPackage(entityBuilder: entityBuilder);

        // Act + Assert
        expect(
          () => domainPackage.addEntity(
            name: 'cool',
            outputDir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<EntityAlreadyExists>()),
        );
      });
    });

    group('.removeEntity()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(true);
        final entityBuilder = getEntityBuilder(entity);
        final domainPackage = _getDomainPackage(entityBuilder: entityBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.removeEntity(
          name: 'cool',
          dir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => entityBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(() => entity.delete(logger: logger)).called(1);
      });

      test('throws EntityDoesNotExist when entity does not exist', () {
        // Arrange
        final entity = getEntity();
        when(() => entity.existsAny()).thenReturn(false);
        final entityBuilder = getEntityBuilder(entity);
        final domainPackage = _getDomainPackage(entityBuilder: entityBuilder);

        // Act + Assert
        expect(
          () => domainPackage.removeEntity(
            name: 'cool',
            dir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<EntityDoesNotExist>()),
        );
      });
    });

    group('.addServiceInterface()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(false);
        final serviceInterfaceBuilder =
            getServiceInterfaceBuilder(serviceInterface);
        final domainPackage =
            _getDomainPackage(serviceInterfaceBuilder: serviceInterfaceBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.addServiceInterface(
          name: 'cool',
          outputDir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => serviceInterfaceBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(() => serviceInterface.create(logger: logger)).called(1);
      });

      test('throws ServiceInterfaceAlreadyExists when service interface exists',
          () {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final serviceInterfaceBuilder =
            getServiceInterfaceBuilder(serviceInterface);
        final domainPackage =
            _getDomainPackage(serviceInterfaceBuilder: serviceInterfaceBuilder);

        // Act + Assert
        expect(
          () => domainPackage.addServiceInterface(
            name: 'cool',
            outputDir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceInterfaceAlreadyExists>()),
        );
      });
    });

    group('.removeServiceInterface()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(true);
        final serviceInterfaceBuilder =
            getServiceInterfaceBuilder(serviceInterface);
        final domainPackage =
            _getDomainPackage(serviceInterfaceBuilder: serviceInterfaceBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.removeServiceInterface(
          name: 'cool',
          dir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => serviceInterfaceBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(() => serviceInterface.delete(logger: logger)).called(1);
      });

      test(
          'throws ServiceInterfaceDoesNotExist when service interface does not exist',
          () {
        // Arrange
        final serviceInterface = getServiceInterface();
        when(() => serviceInterface.existsAny()).thenReturn(false);
        final serviceInterfaceBuilder =
            getServiceInterfaceBuilder(serviceInterface);
        final domainPackage =
            _getDomainPackage(serviceInterfaceBuilder: serviceInterfaceBuilder);

        // Act + Assert
        expect(
          () => domainPackage.removeServiceInterface(
            name: 'cool',
            dir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<ServiceInterfaceDoesNotExist>()),
        );
      });
    });

    group('.addValueObject()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(false);
        final valueObjectBuilder = getValueObjectBuilder(valueObject);
        final domainPackage =
            _getDomainPackage(valueObjectBuilder: valueObjectBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.addValueObject(
          name: 'cool',
          outputDir: 'my/dir',
          type: 'List<#A>',
          generics: '<A>',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => valueObjectBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(
          () => valueObject.create(
            logger: logger,
            type: 'List<#A>',
            generics: '<A>',
          ),
        ).called(1);
      });

      test('throws ValueObjectAlreadyExists when value object exists', () {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(true);
        final valueObjectBuilder = getValueObjectBuilder(valueObject);
        final domainPackage =
            _getDomainPackage(valueObjectBuilder: valueObjectBuilder);

        // Act + Assert
        expect(
          () => domainPackage.addValueObject(
            name: 'cool',
            outputDir: 'my/dir',
            type: 'List<#A>',
            generics: '<A>',
            logger: FakeLogger(),
          ),
          throwsA(isA<ValueObjectAlreadyExists>()),
        );
      });
    });

    group('.removeValueObject()', () {
      test('completes successfully with correct output', () {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(true);
        final valueObjectBuilder = getValueObjectBuilder(valueObject);
        final domainPackage =
            _getDomainPackage(valueObjectBuilder: valueObjectBuilder);

        // Act
        final logger = FakeLogger();
        domainPackage.removeValueObject(
          name: 'cool',
          dir: 'my/dir',
          logger: logger,
        );

        // Act + Assert
        verify(
          () => valueObjectBuilder(
            name: 'cool',
            dir: 'my/dir',
            domainPackage: domainPackage,
          ),
        ).called(1);
        verify(() => valueObject.delete(logger: logger)).called(1);
      });

      test('throws ValueObjectDoesNotExist when value object does not exist',
          () {
        // Arrange
        final valueObject = getValueObject();
        when(() => valueObject.existsAny()).thenReturn(false);
        final valueObjectBuilder = getValueObjectBuilder(valueObject);
        final domainPackage =
            _getDomainPackage(valueObjectBuilder: valueObjectBuilder);

        // Act + Assert
        expect(
          () => domainPackage.removeValueObject(
            name: 'cool',
            dir: 'my/dir',
            logger: FakeLogger(),
          ),
          throwsA(isA<ValueObjectDoesNotExist>()),
        );
      });
    });
  });

  group('Entity', () {
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final entity = _getEntity(
            name: 'my_entity',
            dir: 'entity/path',
            domainPackage: domainPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await entity.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_entity',
                'output_dir': 'entity/path',
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final entity = _getEntity(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final entityDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);
          final entityTestDir = Directory('domain_package/path/test/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          entity.delete(logger: logger);

          // Assert
          expect(entityDir.existsSync(), false);
          expect(entityTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final entity = _getEntity(
            name: 'Cool',
            dir: 'foo',
            domainPackage: domainPackage,
          );
          final entityDir = Directory('domain_package/path/lib/foo/cool')
            ..createSync(recursive: true);
          final entityTestDir = Directory('domain_package/path/test/foo/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          entity.delete(logger: logger);

          // Assert
          expect(Directory('domain_package/path/lib/foo').existsSync(), false);
          expect(Directory('domain_package/path/test/foo').existsSync(), false);
          expect(entityDir.existsSync(), false);
          expect(entityTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('ServiceInterface', () {
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final serviceInterface = _getServiceInterface(
            name: 'my_service_interface',
            dir: 'service_interface/path',
            domainPackage: domainPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await serviceInterface.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_service_interface',
                'output_dir': 'service_interface/path',
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final serviceInterface = _getServiceInterface(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final serviceInterfaceDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          serviceInterface.delete(logger: logger);

          // Assert
          expect(serviceInterfaceDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final serviceInterface = _getServiceInterface(
            name: 'Cool',
            dir: 'foo',
            domainPackage: domainPackage,
          );
          final serviceInterfaceDir =
              Directory('domain_package/path/lib/foo/cool')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          serviceInterface.delete(logger: logger);

          // Assert
          expect(Directory('domain_package/path/lib/foo').existsSync(), false);
          expect(serviceInterfaceDir.existsSync(), false);
        }),
      );
    });
  });

  group('ValueObject', () {
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final generator = getMasonGenerator();
          final valueObject = _getValueObject(
            name: 'my_value_object',
            dir: 'value_object/path',
            domainPackage: domainPackage,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await valueObject.create(
            logger: logger,
            type: 'Pair<#A, #B>',
            generics: '<A, B>',
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_value_object',
                'output_dir': 'value_object/path',
                'type': 'Pair<#A, #B>',
                'generics': '<A, B>',
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
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final valueObject = _getValueObject(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final valueObjectDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);
          final valueObjectTestDir = Directory('domain_package/path/test/cool')
            ..createSync(recursive: true);

          // Act
          valueObject.delete(logger: FakeLogger());

          // Assert
          expect(valueObjectDir.existsSync(), false);
          expect(valueObjectTestDir.existsSync(), false);
        }),
      );

      test(
        'deletes all related files (with dir)',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final valueObject = _getValueObject(
            name: 'Cool',
            dir: 'foo',
            domainPackage: domainPackage,
          );
          final valueObjectDir = Directory('domain_package/path/lib/foo/cool')
            ..createSync(recursive: true);
          final valueObjectTestDir =
              Directory('domain_package/path/test/foo/cool')
                ..createSync(recursive: true);

          // Act
          valueObject.delete(logger: FakeLogger());

          // Assert
          expect(Directory('domain_package/path/lib/foo').existsSync(), false);
          expect(Directory('domain_package/path/test/foo').existsSync(), false);
          expect(valueObjectDir.existsSync(), false);
          expect(valueObjectTestDir.existsSync(), false);
        }),
      );
    });
  });
}
