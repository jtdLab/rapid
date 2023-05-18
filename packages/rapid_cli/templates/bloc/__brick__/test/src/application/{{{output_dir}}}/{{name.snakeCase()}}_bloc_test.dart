import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_{{platform}}_{{feature_name}}/src/{{#pathCase}}application/{{{output_dir}}}{{/pathCase}}/{{name.snakeCase()}}_bloc.dart';

{{name.pascalCase()}}Bloc _get{{name.pascalCase()}}Bloc() {
  return {{name.pascalCase()}}Bloc();
}

void main() {
  group('{{name.pascalCase()}}Bloc', () {
    test('has initial state {{name.pascalCase()}}Initial', () {
      // Arrange
      final {{name.camelCase()}}Bloc = _get{{name.pascalCase()}}Bloc();

      //  Act + Assert
      expect({{name.camelCase()}}Bloc.state, const {{name.pascalCase()}}Initial());
    });

    group('{{name.pascalCase()}}Started', () {
      // TODO: use https://pub.dev/packages/bloc_test to verify correct states get emitted
    });
  });
}
