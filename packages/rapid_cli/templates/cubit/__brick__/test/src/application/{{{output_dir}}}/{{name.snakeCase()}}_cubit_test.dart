import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_{{platform}}_{{feature_name}}/src/{{#pathCase}}application/{{{output_dir}}}{{/pathCase}}/{{name.snakeCase()}}_cubit.dart';

{{name.pascalCase()}}Cubit _get{{name.pascalCase()}}Cubit() {
  return {{name.pascalCase()}}Cubit();
}

void main() {
  group('{{name.pascalCase()}}Cubit', () {
    test('has initial state Initial', () {
      // Arrange
      final {{name.camelCase()}}Cubit = _get{{name.pascalCase()}}Cubit();

      //  Act + Assert
      expect({{name.camelCase()}}Cubit.state, const {{name.pascalCase()}}State.initial());
    });

    group('started', () {
      // TODO: use https://pub.dev/packages/bloc_test to verify correct states get emitted
    });
  });
}
