import 'package:test/test.dart';
import 'package:{{project_name.snakeCase()}}_{{#pathCase}}domain{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}/{{{output_dir}}}{{/pathCase}}/{{entity_name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_infrastructure{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}/{{#pathCase}}src/{{{output_dir}}}{{/pathCase}}/{{entity_name.snakeCase()}}_dto.dart';

void main() {
  group('{{entity_name.pascalCase()}}Dto', () {
    group('.()', () {
      test('', () {
        // Act
        final {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Assert
        expect({{entity_name.camelCase()}}Dto.id, 'some_id');
      });
    });

    group('.fromDomain()', () {
      test('', () {
        // Arrange
        final {{entity_name.camelCase()}} = {{entity_name.pascalCase()}}(id: 'some_id');

        // Act + Assert
        expect({{entity_name.pascalCase()}}Dto.fromDomain({{entity_name.camelCase()}}), {{entity_name.pascalCase()}}Dto(id: 'some_id'));
      });
    });

    group('.fromJson()', () {
      test('', () {
        // Arrange
        final {{entity_name.camelCase()}}Json = {'id': 'some_id'};

        // Act + Assert
        expect({{entity_name.pascalCase()}}Dto.fromJson({{entity_name.camelCase()}}Json), {{entity_name.pascalCase()}}Dto(id: 'some_id'));
      });

      test('throws when json is invalid', () {
        // Act + Assert
        expect(() => {{entity_name.pascalCase()}}Dto.fromJson({'b': 54}), throwsA(isA<Error>()));
      });
    });

    group('.toDomain()', () {
      test('', () {
        // Arrange
        final {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Act + Assert
        expect({{entity_name.camelCase()}}Dto.toDomain(), {{entity_name.pascalCase()}}(id: 'some_id'));
      });
    });

    group('.toJson()', () {
      test('', () {
        // Arrange
        final {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Act + Assert
        expect({{entity_name.camelCase()}}Dto.toJson(), {'id': 'some_id'});
      });
    });
  });
}
