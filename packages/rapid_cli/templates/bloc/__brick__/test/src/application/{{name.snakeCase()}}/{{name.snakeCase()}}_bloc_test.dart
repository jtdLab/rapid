import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_{{platform}}_{{feature_name}}/src/application/{{name.snakeCase()}}/{{name.snakeCase()}}_bloc.dart';

{{name.pascalCase()}}Bloc _get{{name.pascalCase()}}Bloc() {
  return {{name.pascalCase()}}Bloc();
}

void main() {
  group('{{name.pascalCase()}}Bloc', () {
    test('has initial state Initial', () {
      // Arrange
      final {{name.camelCase()}}Bloc = _get{{name.pascalCase()}}Bloc();

      //  Act + Assert
      expect({{name.camelCase()}}Bloc.state, const {{name.pascalCase()}}State.initial());
    });

    group('started', () {
      // TODO: use https://pub.dev/packages/bloc_test to verify correct states get emitted
    });
  });
}
