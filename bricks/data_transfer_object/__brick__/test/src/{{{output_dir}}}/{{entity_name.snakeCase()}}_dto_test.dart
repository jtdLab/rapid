import 'package:test/test.dart';
import 'package:{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}.dart';
import 'package:{{project_name}}_infrastructure{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/src{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/{{entity_name.snakeCase()}}_dto.dart';

void main() {
  group('{{entity_name.pascalCase()}}Dto', () {
    group('.()', () {
      test('returns correct instance', () {
        // Act
        const {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Assert
        expect({{entity_name.camelCase()}}Dto.id, 'some_id');
      });
    });

    group('.fromDomain()', () {
      test('returns correct instance', () {
        // Arrange
        const {{entity_name.camelCase()}} = {{entity_name.pascalCase()}}(id: 'some_id');

        // Act + Assert
        expect({{entity_name.pascalCase()}}Dto.fromDomain({{entity_name.camelCase()}}), const {{entity_name.pascalCase()}}Dto(id: 'some_id'));
      });
    });

    group('.fromJson()', () {
      test('returns correct instance', () {
        // Arrange
        final {{entity_name.camelCase()}}Json = {'id': 'some_id'};

        // Act + Assert
        expect({{entity_name.pascalCase()}}Dto.fromJson({{entity_name.camelCase()}}Json), const {{entity_name.pascalCase()}}Dto(id: 'some_id'));
      });

      test('throws when json is invalid', () {
        // Act + Assert
        expect(() => {{entity_name.pascalCase()}}Dto.fromJson({'b': 54}), throwsA(isA<Error>()));
      });
    });

    group('.toDomain()', () {
      test('returns correct entity', () {
        // Arrange
        const {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Act + Assert
        expect({{entity_name.camelCase()}}Dto.toDomain(), const {{entity_name.pascalCase()}}(id: 'some_id'));
      });
    });

    group('.toJson()', () {
      test('returns correct json', () {
        // Arrange
        const {{entity_name.camelCase()}}Dto = {{entity_name.pascalCase()}}Dto(id: 'some_id');

        // Act + Assert
        expect({{entity_name.camelCase()}}Dto.toJson(), {'id': 'some_id'});
      });
    });
  });
}
