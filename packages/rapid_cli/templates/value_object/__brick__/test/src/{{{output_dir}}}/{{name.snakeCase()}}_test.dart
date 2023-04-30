import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:{{project_name}}_domain{{#has_subdomain_name}}_{{subdomain_name}}{{/has_subdomain_name}}/src{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/{{name.snakeCase()}}.dart';

void main() {
  group('{{name.pascalCase()}}', () {
    group('.()', () {
      group('(valid)', () {
        test('', () {
          // Arrange + Act
          // final {{name.camelCase()}} = {{name.pascalCase()}}(/* TODO valid */);

          // Assert
          // expect({{name.camelCase()}}.value, right(/* TODO valid */));
        });

        // TODO: more valid cases
      });

      group('(invalid)', () {
        test('', () {
          // Arrange + Act
          // final {{name.camelCase()}} = {{name.pascalCase()}}(/* TODO invalid */);

          // Assert
          // expect({{name.camelCase()}}.value, left(/* TODO {{name.pascalCase()}}Failure */));
        });

        // TODO: more invalid cases
      });
    });

    group('.random()', () {
      test('(valid)', () {
        // Arrange + Act
        // final {{name.camelCase()}} = {{name.pascalCase()}}.random(isValid: true);

        // Assert
        // expect({{name.camelCase()}}.value, right(/* TODO valid */));
      });

      test('(invalid)', () {
        // Arrange + Act
        // final {{name.camelCase()}} = {{name.pascalCase()}}.random(isValid: false);

        // Assert
        // expect({{name.camelCase()}}.value, left(/* TODO {{name.pascalCase()}}Failure */));
      });
    });

    group('.toString()', () {
      test('(valid)', () {
        // Arrange + Act
        // final {{name.camelCase()}} = {{name.pascalCase()}}(/* TODO valid */);

        // Assert
        // expect({{name.camelCase()}}.toString(), /* TODO */);
      });

      test('(invalid)', () {
        // Arrange + Act
        // final {{name.camelCase()}} = {{name.pascalCase()}}(/* TODO invalid */);

        // Assert
        // expect({{name.camelCase()}}.toString(), /* TODO */);
      });
    });
  });
}
